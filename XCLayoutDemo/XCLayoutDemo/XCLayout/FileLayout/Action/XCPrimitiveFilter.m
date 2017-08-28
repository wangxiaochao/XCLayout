//
//  XCBoolFilter.m
//  XLT
//
//  Created by 钧泰科技 on 15/6/25.
//  Copyright (c) 2015年 wxc. All rights reserved.
//

#import "XCPrimitiveFilter.h"

@implementation XCPrimitiveFilter

+ (NSNumber *)boolFilter:(NSString *)value
{
    NSInteger v = [value integerValue];
    
    if (v == 1)
    {
        return [NSNumber numberWithBool:YES];
    }
    
    return [NSNumber numberWithBool:NO];
}

+ (NSNumber *)intFilter:(NSString *)value
{
    return [NSNumber numberWithInteger:[value integerValue]];
}

+ (NSNumber *)floatFilter:(NSString *)value
{
    NSNumber *number = [NSNumber numberWithFloat:[value floatValue]];
    return number;
}

@end







