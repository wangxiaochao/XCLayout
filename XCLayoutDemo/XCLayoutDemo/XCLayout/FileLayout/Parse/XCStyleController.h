//
//  XCStyleController.h
//  XCDevKit
//
//  Created by 钧泰科技 on 15/4/17.
//  Copyright (c) 2015年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>



@class XCLayoutFileObj,XCLayoutFileNodeObj;

@interface XCStyleController : NSObject

+ (NSMutableDictionary *)parsStyleToSrcCss:(NSString *)src;

+ (void)parsDivStyleByAllCSS:(XCLayoutFileNodeObj *)node;

//根据ID获取
+ (NSMutableDictionary *)getStyleById:(NSString *)cid node:(XCLayoutFileNodeObj *)node;
//根据自身类获取
+ (NSMutableDictionary *)getStyleBySelf:(XCLayoutFileNodeObj *)node;
//根据类样式获取
+ (NSMutableDictionary *)getStyleByClass:(NSString *)clsName node:(XCLayoutFileNodeObj *)node;
//根据key获取
+ (NSMutableDictionary *)getStyleByKey:(NSString *)key node:(XCLayoutFileNodeObj *)node;
@end
