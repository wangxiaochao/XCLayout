//
//  XCXMLParseTrans.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XCXMLElement;
@class XCLayoutFileObj;
@class XCLayoutFileNodeObj;

@interface XCXMLParseTrans : NSObject
+ (XCLayoutFileObj *)transformFileObj:(XCXMLElement *)rootElement filePath:(NSString *)filePath;        //必要传一下文件路径 方便fileObj对象记录文件路径

//手动新增一个样式 dic
+ (void)addStyleClass:(NSDictionary *)style fileNodeObj:(XCLayoutFileNodeObj *)fileNodeObj;
@end
