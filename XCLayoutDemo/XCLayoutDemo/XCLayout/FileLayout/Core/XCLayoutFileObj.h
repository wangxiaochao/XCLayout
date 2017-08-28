//
//  XCLayoutFileObj.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XCLayoutFileNodeObj;
@class XCLayoutViewXMLObject;
@interface XCLayoutFileObj : NSObject
@property (nonatomic,weak) XCLayoutViewXMLObject *xmlObject;        //xml布局对象引用
@property (nonatomic,strong) NSString *incloudStyleSrcFilePath;      //引入的外部样式文件
@property (nonatomic,strong) NSMutableDictionary *incloudStyleSrc;      //引入的外部样式文件 样式

@property (nonatomic,strong) NSString *filePath;    //布局文件路径
@property (nonatomic,strong) NSMutableDictionary   *style;    //布局模板样式-页面内样式

@property (nonatomic,strong) XCLayoutFileNodeObj *body;     //body节点
@end


@interface XCLayoutFileNodeObj : NSObject
@property (nonatomic,weak) XCLayoutFileObj *fileObj;        //所属文件对象

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *cid;
@property (nonatomic,strong) NSString *classs;
@property (nonatomic,strong) NSString *x_event;                 //添加事件类型
@property (nonatomic,strong) NSString *x_action_begn;          //最开始执行一个动作 view刚创建完立刻执行这个动作
@property (nonatomic,strong) NSString *x_action;            //最后执行一个动作 view将要addView到父元素前
@property (nonatomic,strong) NSString *x_action_end;            //结束了 执行一个动作 view addView到父元素后 执行这个动作

@property (nonatomic,strong) NSMutableDictionary *attributes;
@property (nonatomic,strong) NSMutableDictionary *runtionAttributes;        //需要动态赋值的 属性列表

@property (nonatomic,strong) NSMutableDictionary *style;
@property (nonatomic,strong) NSMutableArray *nodes;
@end




