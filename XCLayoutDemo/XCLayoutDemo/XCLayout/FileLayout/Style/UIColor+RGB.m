//
//  UIColor+RGB.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/7/18.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor(UIColorRGB)

//RGB转换
+ (UIColor *)UIColorFromRGB:(NSString *)RGB
{
    RGB = [RGB stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (RGB.length == 7)        //无透明度
    {
        RGB = [RGB stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
        long colorLong = strtoul([RGB cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
        int R = ((colorLong>>16) & 0xFF);
        int G = ((colorLong>>8) & 0xFF);
        int B = ((colorLong) & 0xFF);
        
        return [UIColor colorWithRed:R/255. green:G/255. blue:B/255. alpha:1.];
    }
    if (RGB.length == 9)        //有透明度
    {
        RGB = [RGB stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
        long colorLong = strtoul([RGB cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
        int P = ((colorLong>>24) & 0xFF);;
        int R = ((colorLong>>16) & 0xFF);
        int G = ((colorLong>>8) & 0xFF);
        int B = ((colorLong) & 0xFF);
        
        return [UIColor colorWithRed:R/255. green:G/255. blue:B/255. alpha:P/255.];
    }
    
    return nil;
}
@end
