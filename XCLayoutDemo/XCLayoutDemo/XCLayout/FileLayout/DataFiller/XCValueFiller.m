//
//  XCValueFiller.m
//  XLT
//
//  Created by 钧泰科技 on 15/6/9.
//  Copyright (c) 2015年 wxc. All rights reserved.
//

#import "XCValueFiller.h"
#import "XCActionPool.h"

@implementation XCValueFiller

+ (id)comDataImmit:(NSString *)value data:(id)data
{
    NSRange range = [value rangeOfString:@"{{"];
    if (range.location == NSNotFound || data == nil)
    {
        return [self drawData:value data:nil];
    }
    
    NSMutableString *result = [NSMutableString string];
    while (YES)
    {
        NSRange range = [value rangeOfString:@"{{"];
        if (range.location == NSNotFound)
        {
            [result appendString:value];
            break;
        }
        
        if (range.location > 0)
        {
            [result appendString:[value substringToIndex:range.location]];
        }
        
        value = [value substringFromIndex:range.location+2];
        range = [value rangeOfString:@"}}"];
        NSString *dataKey = [value substringToIndex:range.location];
        id drawData = [self drawData:dataKey data:data];
        
        value = [value substringFromIndex:range.location+2];
        if (drawData == nil || drawData == [NSNull null])
        {
            [result appendString:@""];
            continue;
        }
        if ([drawData isKindOfClass:[NSString class]])
        {
            [result appendString:drawData];
            continue;
        }
        if ([drawData isKindOfClass:[NSNumber class]])
        {
            [result appendString:[drawData stringValue]];
            continue;
        }
        return drawData;
    }
    
    return result;
}

+ (id)drawData:(NSString *)key data:(id)data
{
    NSRange range = [key rangeOfString:@"|"];
    if (range.location == NSNotFound)
    {
        return [self comObjectDataImmit:key data:data];
    }
    
    //有过滤器
    NSArray *vs = [key componentsSeparatedByString:@"|"];;
    if (vs.count == 0)
    {
        return nil;
    }
    
    id value = [self comObjectDataImmit:[vs objectAtIndex:0] data:data];
    vs = [vs objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, vs.count-1)]];
    for (NSString *filter in vs)
    {
        vs = [filter componentsSeparatedByString:@":"];
        NSMutableArray *mArray = [NSMutableArray arrayWithObject:value];
        NSArray *otherParams = [vs objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, vs.count-1)]];
        if (otherParams.count > 0)
        {
            [mArray addObjectsFromArray:otherParams];
        }
        id fValue = [[XCActionPool sharedXCActionPool] sendFilter:[vs objectAtIndex:0] params:mArray];
        if (fValue)
        {
            value = fValue;
        }
    }
         
    return value;
}

+ (id)comObjectDataImmit:(NSString *)key data:(id)data
{
    if (data == nil)
    {
        return key;
    }
    id vData = data;
    NSArray *vs = [key componentsSeparatedByString:@"."];
    for (NSString *s in vs)
    {
        vData = [vData objectForKey:s];
    }
    
    return vData==nil?key:vData;
}

@end
