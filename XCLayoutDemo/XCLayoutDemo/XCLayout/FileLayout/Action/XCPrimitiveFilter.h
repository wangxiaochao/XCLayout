//
//  XCBoolFilter.h
//  XLT
//
//  Created by 钧泰科技 on 15/6/25.
//  Copyright (c) 2015年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCPrimitiveFilter : NSObject

+ (NSNumber *)boolFilter:(NSString *)value;

+ (NSNumber *)intFilter:(NSString *)value;

+ (NSNumber *)floatFilter:(NSString *)value;
@end
