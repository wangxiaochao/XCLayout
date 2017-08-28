//
//  XCLayoutView+XML.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutView+XML.h"
#import <objc/runtime.h>

#import "XCResourceManage.h"
#import "XCXMLParse.h"
#import "XCXMLParseTrans.h"
#import "XCLayoutStyleFill.h"
#import "XCActionPool.h"
#import "XCLayoutUtil.h"

#import "XCValueFiller.h"

#import "XCLayoutViewXMLObject.h"

#import "XCLayoutView+Ext.h"
#import "XCLayoutSizeClassInner.h"
#import "XCLayoutSizeClass+Ext.h"           //sizeClass扩展类 在不修改布局对象本身的条件下 加入xml布局需要的元素属性

#import "XCStyleController.h"       //获取样式

const char * const XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_VIEW_XMLOBJECT = "XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_VIEW_XMLOBJECT";


#import "XCLayoutView+XML+Inner.h"
@implementation UIView(XCLayoutViewXMLInner)

- (XCLayoutViewXMLObject *)xc_layoutViewXMLObject
{
    return objc_getAssociatedObject(self, &XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_VIEW_XMLOBJECT);
}
- (void)setXc_layoutViewXMLObject:(XCLayoutViewXMLObject *)xc_layoutViewXMLObject
{
    objc_setAssociatedObject(self, &XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_VIEW_XMLOBJECT, xc_layoutViewXMLObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UIView(XCLayoutViewXML)

#pragma mark -- 载入布局
- (void)xc_layoutFilePath:(NSString *)layoutFilePath owen:(id)owen dataSource:(id)dataSource //owen 是设置this赋值的对象
{
    if (self.xc_layoutViewXMLObject == nil)
    {
        self.xc_layoutViewXMLObject = [[XCLayoutViewXMLObject alloc] init];
        self.xc_layoutViewXMLObject.view = self;
    }
    [self xc_layoutFileObj:[UIView xc_createLayoutObj:layoutFilePath] owen:owen dataSource:dataSource];
}
- (void)xc_layoutFileObj:(XCLayoutFileObj *)fileObj owen:(id)owen dataSource:(id)dataSource
{
    if (self.xc_layoutViewXMLObject == nil)
    {
        self.xc_layoutViewXMLObject = [[XCLayoutViewXMLObject alloc] init];
        self.xc_layoutViewXMLObject.view = self;
    }
    
    self.xc_layoutViewXMLObject.layoutFilePath = fileObj.filePath;        //记录文件路径
    self.xc_layoutViewXMLObject.fileObj = fileObj;
    self.xc_layoutViewXMLObject.owen = owen;
    self.xc_layoutViewXMLObject.dataSource = dataSource;
    
    fileObj.xmlObject = self.xc_layoutViewXMLObject;        //互相设置引用
    
    //开始布局
    [self xc_startLayout];
}

#pragma end

#pragma mark -- 解析一个布局文件
+ (XCLayoutFileObj *)xc_createLayoutObj:(NSString *)layoutFilePath
{
    NSError *error;
    NSString *path = [[XCResourceManage sharedXCResourceManage] getXmlPath:layoutFilePath];
    NSString *xmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (xmlString == nil)
    {
        return nil;
    }
    XCXMLElement *element = [[[XCXMLParse alloc] init] parse:xmlString];
    
    XCLayoutFileObj *obj = [XCXMLParseTrans transformFileObj:element filePath:layoutFilePath];
    return obj;
}
#pragma end

#pragma mark - 开始布局
- (void)xc_setDataSource:(id)dataSource
{
    if (self.xc_layoutViewXMLObject == nil)
    {
        return;
    }
    self.xc_layoutViewXMLObject.dataSource = dataSource;
    
    [self xc_dataFill:dataSource];
}


- (void)xc_startLayout
{
    XCLayoutFileObj *fileObj = self.xc_layoutViewXMLObject.fileObj;
    
    XCLayoutFileNodeObj *bodyObj = fileObj.body;        //样式  首先获取body样式
    
    //根据body创建 Body
    XCLayoutBody *body = [[XCLayoutBody alloc] init];
    //设置body样式引用
    self.xc_layoutViewXMLObject.body = body.xc_getCurrentSizeClass;
    
    //维护元素本身与xml布局样式关系
    body.xc_getCurrentSizeClass.fileNodeObj = bodyObj;
    body.xc_getCurrentSizeClass.cid = bodyObj.cid;
    
    if (bodyObj.x_action_begn)
    {
        [[XCActionPool sharedXCActionPool] sendAction:bodyObj.x_action_begn tag:body];
    }
    [body stopAuto];        //停止刷新布局
    
    //设置样式
    [XCLayoutStyleFill fillStyleGetRuntimeProperty:body style:fileObj.body.style runtionDic:fileObj.body.runtionAttributes viewXML:self.xc_layoutViewXMLObject];
    
    if (bodyObj.nodes.count > 0)            //创建子元素
    {
        [self xc_initSubviews:body fileNodeObj:bodyObj];
    }
    
    
    if (bodyObj.x_action)
    {
        [[XCActionPool sharedXCActionPool] sendAction:bodyObj.x_action tag:body];
    }
    
    [self addSubview:body];
    [body startAuto];  //开始刷新
    
    if (bodyObj.x_action_end)
    {
        [[XCActionPool sharedXCActionPool] sendAction:bodyObj.x_action_end tag:body];
    }
}

- (void)xc_initSubviews:(UIView *)superView fileNodeObj:(XCLayoutFileNodeObj *)fileNodeObj
{
    for (XCLayoutFileNodeObj *node in fileNodeObj.nodes)
    {
        UIView *view = [NSClassFromString(node.name) xc_init];
        if (view == nil)
            continue;
        
        //维护元素本身与xml布局样式关系
        view.xc_getCurrentSizeClass.fileNodeObj = node;
        view.xc_getCurrentSizeClass.cid = node.cid;
        
        if (node.cid)
        {
            [[self.xc_layoutViewXMLObject cids] setObject:view.xc_getCurrentSizeClass forKey:node.cid];
        }
        
        if (node.x_action_begn)
        {
            [[XCActionPool sharedXCActionPool] sendAction:node.x_action_begn tag:view];
        }
        
        //设置样式
        [XCLayoutStyleFill fillStyleGetRuntimeProperty:view style:node.style runtionDic:node.runtionAttributes viewXML:self.xc_layoutViewXMLObject];
        //设置事件
        if ([view isKindOfClass:[UIControl class]])
        {
            [self setEvents:view value:node.x_event viewXML:self.xc_layoutViewXMLObject];
        }
        else if (node.x_event != nil && ![node.x_event isEqualToString:@""])
        {
            [self setEvents:view value:node.x_event viewXML:self.xc_layoutViewXMLObject];
        }
        
        
        if (node.nodes.count > 0)            //创建子元素
        {
            [self xc_initSubviews:view fileNodeObj:node];
        }
        
        if (node.x_action)
        {
            [[XCActionPool sharedXCActionPool] sendAction:node.x_action tag:view];
        }
        
        [superView addSubview:view];
        
        if (node.x_action_end)
        {
            [[XCActionPool sharedXCActionPool] sendAction:node.x_action_end tag:view];
        }
    }
}

- (id<XCLayoutViewXMLEventDelegate>)xc_eventDeleagte
{
    return self.xc_layoutViewXMLObject.eventDelegate;
}
- (void)setXc_eventDeleagte:(id<XCLayoutViewXMLEventDelegate>)xc_eventDeleagte
{
    self.xc_layoutViewXMLObject.eventDelegate = xc_eventDeleagte;
}
- (void)xc_settingOutlet:(id)tagger
{
    for (NSString *key in [self.xc_layoutViewXMLObject.cids allKeys])
    {
        UIView *layout = ((XCLayoutSizeClass *)[self.xc_layoutViewXMLObject.cids objectForKey:key]).view;
        [XCLayoutUtil setObjProperty:tagger key:key value:layout];
    }
}
- (UIView *)xc_getElementById:(NSString *)ID    //根据ID获取
{
    XCLayoutSizeClass *sizeClass = [[self.xc_layoutViewXMLObject cids] objectForKey:ID];
    if (sizeClass)
    {
        return sizeClass.view;
    }
    return nil;
}
//- (XCLayoutBody *)xc_getBody
//{
//    XCLayoutSizeClass *body = (XCLayoutSizeClass *)self.xc_layoutViewXMLObject.body;
//    return (XCLayoutBody *)body.view;
//}

//数据操作
- (void)xc_dataFill:(id)data
{
    if (data == nil)
    {
        return;
    }
    
    for (UIView *view in [self subviews])
    {
        XCLayoutFileNodeObj *fileNodeObj = view.xc_getCurrentSizeClass.fileNodeObj;
        if (fileNodeObj == nil || fileNodeObj.runtionAttributes.count == 0)
        {
            if ([view subviews].count > 0)
            {
                [view xc_dataFill:data];
            }
            continue;
        }
        
        
        for (NSString *key in [fileNodeObj.runtionAttributes allKeys])
        {
            NSString *keyValue = [fileNodeObj.runtionAttributes objectForKey:key];
            
            id value = [XCValueFiller comDataImmit:keyValue data:data];
            
            [XCLayoutStyleFill fillStyle:view key:key value:value];
        }
        
        if ([view subviews].count > 0)
        {
            [view xc_dataFill:data];
        }
    }
}

//为某个view添加样式
- (void)xc_addStyleClass:(NSDictionary *)style
{
    if (self.xc_getCurrentSizeClass == nil) return;
    if (self.xc_getCurrentSizeClass.fileNodeObj == nil) return;
    
    XCLayoutFileNodeObj *node = self.xc_getCurrentSizeClass.fileNodeObj;
    [XCXMLParseTrans addStyleClass:style fileNodeObj:node];  //新增样式
    
    //设置样式
    [XCLayoutStyleFill fillStyleGetRuntimeProperty:self style:node.style runtionDic:node.runtionAttributes viewXML:node.fileObj.xmlObject];
    //设置事件
    if ([self isKindOfClass:[UIControl class]])
    {
        [self setEvents:self value:node.x_event viewXML:node.fileObj.xmlObject];
    }
    else if (node.x_event != nil && ![node.x_event isEqualToString:@""])
    {
        [self setEvents:self value:node.x_event viewXML:node.fileObj.xmlObject];
    }
    
    [self.xc_getLayoutBody setNeedsLayout];     //刷新页面布局
}

- (NSMutableDictionary *)xc_getStyleById:(NSString *)cid
{
    if (self.xc_getCurrentSizeClass == nil) return nil;
    if (self.xc_getCurrentSizeClass.fileNodeObj == nil) return nil;
    
    XCLayoutFileNodeObj *node = self.xc_getCurrentSizeClass.fileNodeObj;
    return [XCStyleController getStyleById:cid node:node];
}
//根据自身类获取
- (NSMutableDictionary *)xc_getStyleBySelf
{
    if (self.xc_getCurrentSizeClass == nil) return nil;
    if (self.xc_getCurrentSizeClass.fileNodeObj == nil) return nil;
    
    XCLayoutFileNodeObj *node = self.xc_getCurrentSizeClass.fileNodeObj;
    return [XCStyleController getStyleBySelf:node];
}
//根据类样式获取
- (NSMutableDictionary *)xc_getStyleByClass:(NSString *)clsName
{
    if (self.xc_getCurrentSizeClass == nil) return nil;
    if (self.xc_getCurrentSizeClass.fileNodeObj == nil) return nil;
    
    XCLayoutFileNodeObj *node = self.xc_getCurrentSizeClass.fileNodeObj;
    return [XCStyleController getStyleByClass:clsName node:node];
}
//根据key获取
- (NSMutableDictionary *)xc_getStyleByKey:(NSString *)key
{
    if (self.xc_getCurrentSizeClass == nil) return nil;
    if (self.xc_getCurrentSizeClass.fileNodeObj == nil) return nil;
    
    XCLayoutFileNodeObj *node = self.xc_getCurrentSizeClass.fileNodeObj;
    return [XCStyleController getStyleByKey:key node:node];
}
#pragma mark --- 文件变化

- (void)xc_willLayoutObjChange
{
    XCLayoutBody *body = (XCLayoutBody *)((XCLayoutSizeClass *)self.xc_layoutViewXMLObject.body).view;
    [body removeFromSuperview];
}
- (void)xc_didLayoutObjChange
{
    [self xc_startLayout];
}
#pragma end



- (void)setEvents:(UIView *)view value:(NSString *)value viewXML:(XCLayoutViewXMLObject *)viewXML
{
    if (viewXML == nil)
    {
        return;
    }
    if ([viewXML respondsToSelector:@selector(controlClick:)])
    {
        if ([view isKindOfClass:[UIControl class]])
        {
            [(UIButton *)view addTarget:viewXML action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
            return;
        }
    }
    
    if ([viewXML respondsToSelector:@selector(viewEvents:)])
    {
        if ([value isEqualToString:@"click"])
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:viewXML action:@selector(viewEvents:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            view.userInteractionEnabled = YES;
            [view addGestureRecognizer:tap];
            return;
        }
        if ([value isEqualToString:@"double-click"])
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:viewXML action:@selector(viewEvents:)];
            tap.numberOfTapsRequired = 2;
            tap.numberOfTouchesRequired = 1;
            view.userInteractionEnabled = YES;
            [view addGestureRecognizer:tap];
            return;
        }
        if ([value isEqualToString:@"long-press"])
        {
            UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:viewXML action:@selector(viewEvents:)];
            tap.minimumPressDuration=1.5;
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            view.userInteractionEnabled = YES;
            [view addGestureRecognizer:tap];
            return;
        }
    }
}

@end






















