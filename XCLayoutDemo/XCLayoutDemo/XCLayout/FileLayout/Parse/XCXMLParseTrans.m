//
//  XCXMLParseTrans.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCXMLParseTrans.h"
#import "XCLayoutFileObj.h"
#import "XCXMLParse.h"
#import "XCStyleController.h"

#import "XCResourceManage.h"

@implementation XCXMLParseTrans

+ (XCLayoutFileObj *)transformFileObj:(XCXMLElement *)rootElement filePath:(NSString *)filePath
{
    XCLayoutFileObj *fileObj = [[XCLayoutFileObj alloc] init];
    fileObj.filePath = filePath;
    
    for (XCXMLElement *element in rootElement.subElements)
    {
        if ([element.name isEqualToString:@"style"])
        {
            fileObj.incloudStyleSrcFilePath = [element.attributes objectForKey:@"src"];
            //装载 src连接的css样式
            fileObj.incloudStyleSrc = [XCStyleController parsStyleToSrcCss:fileObj.incloudStyleSrcFilePath];
            //装载 style 节点下的css样式
            fileObj.style = [NSJSONSerialization JSONObjectWithData:[[NSString stringWithFormat:@"{%@}",element.text] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            break;
        }
    }
    
    for (XCXMLElement *element in rootElement.subElements)
    {
        if ([element.name isEqualToString:@"body"])         //布局节点          //不在支持片段 P 标签了
        {
            XCLayoutFileNodeObj *obj = [[XCLayoutFileNodeObj alloc] init];
            obj.name = element.name;
            obj.cid = [element.attributes objectForKey:@"id"];
            obj.classs = [element.attributes objectForKey:@"class"];
            
            obj.x_action_begn = [element.attributes objectForKey:@"x-action-begn"];
            obj.x_action = [element.attributes objectForKey:@"x-action"];
            obj.x_action_end = [element.attributes objectForKey:@"x-action-end"];
            
            obj.fileObj = fileObj;
            fileObj.body = obj;
            
            [element.attributes removeObjectForKey:@"id"];
            [element.attributes removeObjectForKey:@"class"];
            [element.attributes removeObjectForKey:@"x-action-begn"];
            [element.attributes removeObjectForKey:@"x-action"];
            [element.attributes removeObjectForKey:@"x-action-end"];
            obj.attributes = element.attributes;    //+ 存节点的属性
            
            
            [XCStyleController parsDivStyleByAllCSS:obj];
            
            [self createLayoutDIV:element bodyNode:obj];
        }
    }
    
    return fileObj;
}


+ (void)createLayoutDIV:(XCXMLElement *)nodeElement bodyNode:(XCLayoutFileNodeObj *)bodyNode
{
    for (int i=0;i<nodeElement.subElements.count;i++)
    {
        XCXMLElement *element = [nodeElement.subElements objectAtIndex:i];
        
        if ([element.name isEqualToString:@"x-include"])
        {
            NSString *src = [element.attributes objectForKey:@"src"];
            if (src == nil)
                continue;
            
            
            NSError *error;
            NSString *path = [[XCResourceManage sharedXCResourceManage] getXmlPath:src];
            NSString *xmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            if (xmlString == nil)
                continue;

            XCXMLElement *srcElement = [[[XCXMLParse alloc] init] parse:xmlString];
            [element.attributes removeObjectForKey:@"src"];
            [srcElement.attributes addEntriesFromDictionary:element.attributes];
            
            element = srcElement;
        }
        
        XCLayoutFileNodeObj *obj = [[XCLayoutFileNodeObj alloc] init];
        obj.fileObj = bodyNode.fileObj;
        
        obj.name = element.name;
        obj.cid = [element.attributes objectForKey:@"id"];
        obj.classs = [element.attributes objectForKey:@"class"];
        
        obj.x_event = [element.attributes objectForKey:@"x-event"];
        
        obj.x_action_begn = [element.attributes objectForKey:@"x-action-begn"];
        obj.x_action = [element.attributes objectForKey:@"x-action"];
        obj.x_action_end = [element.attributes objectForKey:@"x-action-end"];
        
        
        [element.attributes removeObjectForKey:@"id"];
        [element.attributes removeObjectForKey:@"class"];
        [element.attributes removeObjectForKey:@"x-event"];
        [element.attributes removeObjectForKey:@"x-action-begn"];
        [element.attributes removeObjectForKey:@"x-action"];
        [element.attributes removeObjectForKey:@"x-action-end"];
        obj.attributes = element.attributes;    //+ 存节点的属性
        
        [XCStyleController parsDivStyleByAllCSS:obj];
        
        [bodyNode.nodes addObject:obj];
        
        if (element.subElements != nil && element.subElements.count > 0)
        {
            [self createLayoutDIV:element bodyNode:obj];
        }
    }
}

//手动新增一个样式 dic
+ (void)addStyleClass:(NSDictionary *)style fileNodeObj:(XCLayoutFileNodeObj *)fileNodeObj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:style];
    if ([dic objectForKey:@"id"])
        fileNodeObj.cid = [dic objectForKey:@"id"];
    if ([dic objectForKey:@"class"])
        fileNodeObj.classs = [dic objectForKey:@"class"];
    if ([dic objectForKey:@"x-event"])
        fileNodeObj.x_event = [dic objectForKey:@"x-event"];
    
    if ([dic objectForKey:@"x-action-begn"])
        fileNodeObj.x_action_begn = [dic objectForKey:@"x-action-begn"];
    if ([dic objectForKey:@"x-action"])
        fileNodeObj.x_action = [dic objectForKey:@"x-action"];
    if ([dic objectForKey:@"x-action-end"])
        fileNodeObj.x_action_end = [dic objectForKey:@"x-action-end"];
    
    [dic removeObjectForKey:@"id"];
    [dic removeObjectForKey:@"class"];
    [dic removeObjectForKey:@"x-event"];
    [dic removeObjectForKey:@"x-action-begn"];
    [dic removeObjectForKey:@"x-action"];
    [dic removeObjectForKey:@"x-action-end"];
    
    [fileNodeObj.style addEntriesFromDictionary:dic];
}
@end





