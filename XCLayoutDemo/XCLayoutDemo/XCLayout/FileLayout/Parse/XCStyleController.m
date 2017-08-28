//
//  XCStyleController.m
//  XCDevKit
//
//  Created by 钧泰科技 on 15/4/17.
//  Copyright (c) 2015年 wxc. All rights reserved.
//
#if !__has_feature(objc_arc)
#error must be built with ARC.
#endif

#import "XCStyleController.h"
#import "XCLayoutUtil.h"
#import "XCResourceManage.h"
#import "XCLayoutFileConfig.h"
#import "XCLayoutFileObj.h"

#define XC_CLASS_CSS_Format(name) [NSString stringWithFormat:@".%@",name]
#define XC_ID_CSS_Format(ID) [NSString stringWithFormat:@"#%@",ID]

#define XC_LOAD_CSS_STYLE(node,cssDic,classArray) \
\
do {[node.style addEntriesFromDictionary:[cssDic objectForKey:node.name]];\
for (NSString *classNmae in classArray)                                    \
[node.style addEntriesFromDictionary:[cssDic objectForKey:XC_CLASS_CSS_Format(classNmae)]];\
[node.style addEntriesFromDictionary:[cssDic objectForKey:XC_ID_CSS_Format(node.cid)]];} while(0)

@implementation XCStyleController
+ (NSMutableDictionary *)parsStyleToSrcCss:(NSString *)src
{
    NSMutableDictionary *cssDic = [NSMutableDictionary dictionary];
    
    NSArray *cssArreyFile = [src  componentsSeparatedByString:@";"];
    for (NSString *file in cssArreyFile)
    {
        NSMutableDictionary *fileDic = [XCLayoutUtil getDictionaryByFileJson:[[XCResourceManage sharedXCResourceManage] getCssStylePath:file]];
        if (cssDic.allKeys.count == 0)
        {
            [cssDic addEntriesFromDictionary:fileDic];
            continue;
        }
        
        [self cssTablePriority:cssDic pCssTable:fileDic];
    }
    
    return cssDic;
}

//处理css样式表优先级 twoTable中覆盖oneTable样式
+ (void)cssTablePriority:(NSMutableDictionary *)oneTable pCssTable:(NSMutableDictionary *)twoTable
{
    for (NSString *cssName in [twoTable allKeys])
    {
        if ([oneTable objectForKey:cssName])
        {
            [[oneTable objectForKey:cssName] addEntriesFromDictionary:[twoTable objectForKey:cssName]];
            continue;
        }
        
        [oneTable setObject:[twoTable objectForKey:cssName] forKey:cssName];
    }
}

//从所有相关css样式表中装配样式// id > class > tag    ,row > style > src > public
+ (void)parsDivStyleByAllCSS:(XCLayoutFileNodeObj *)node
{
    NSArray *classArray = [node.classs componentsSeparatedByString:@" "];
    //取tag样式 从public 中提取
    NSMutableDictionary *publicCssDic = [XCLayoutFileConfig sharedXCLayoutFileConfig].publicCss;
    XC_LOAD_CSS_STYLE(node, publicCssDic,classArray);
    XC_LOAD_CSS_STYLE(node, node.fileObj.incloudStyleSrc, classArray);
    XC_LOAD_CSS_STYLE(node, node.fileObj.style, classArray);
    
    [node.style addEntriesFromDictionary:node.attributes];
}

//根据ID获取
+ (NSMutableDictionary *)getStyleById:(NSString *)cid node:(XCLayoutFileNodeObj *)node
{
    cid = XC_ID_CSS_Format(cid);
    
    if ([node.fileObj.style objectForKey:cid])
        return [node.fileObj.style objectForKey:cid];
    
    if ([node.fileObj.incloudStyleSrc objectForKey:cid])
        return [node.fileObj.incloudStyleSrc objectForKey:cid];

    NSMutableDictionary *publicCssDic = [XCLayoutFileConfig sharedXCLayoutFileConfig].publicCss;
    if ([publicCssDic objectForKey:cid])
        return [publicCssDic objectForKey:cid];
    
    return nil;
}
//根据自身类获取
+ (NSMutableDictionary *)getStyleBySelf:(XCLayoutFileNodeObj *)node
{
    if ([node.fileObj.style objectForKey:node.name])
        return [node.fileObj.style objectForKey:node.name];
    
    if ([node.fileObj.incloudStyleSrc objectForKey:node.name])
        return [node.fileObj.incloudStyleSrc objectForKey:node.name];
    
    NSMutableDictionary *publicCssDic = [XCLayoutFileConfig sharedXCLayoutFileConfig].publicCss;
    if ([publicCssDic objectForKey:node.name])
        return [publicCssDic objectForKey:node.name];
    
    return nil;
}
//根据类样式获取
+ (NSMutableDictionary *)getStyleByClass:(NSString *)clsName node:(XCLayoutFileNodeObj *)node
{
    clsName = XC_CLASS_CSS_Format(clsName);
    
    if ([node.fileObj.style objectForKey:clsName])
        return [node.fileObj.style objectForKey:clsName];
    
    if ([node.fileObj.incloudStyleSrc objectForKey:clsName])
        return [node.fileObj.incloudStyleSrc objectForKey:clsName];
    
    NSMutableDictionary *publicCssDic = [XCLayoutFileConfig sharedXCLayoutFileConfig].publicCss;
    if ([publicCssDic objectForKey:clsName])
        return [publicCssDic objectForKey:clsName];
    
    return nil;
}
+ (NSMutableDictionary *)getStyleByKey:(NSString *)key node:(XCLayoutFileNodeObj *)node
{
    if ([node.fileObj.style objectForKey:key])
        return [node.fileObj.style objectForKey:key];
    
    if ([node.fileObj.incloudStyleSrc objectForKey:key])
        return [node.fileObj.incloudStyleSrc objectForKey:key];
    
    NSMutableDictionary *publicCssDic = [XCLayoutFileConfig sharedXCLayoutFileConfig].publicCss;
    if ([publicCssDic objectForKey:key])
        return [publicCssDic objectForKey:key];
    
    return nil;
}
@end
