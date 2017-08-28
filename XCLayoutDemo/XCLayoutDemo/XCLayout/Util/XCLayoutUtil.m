//
//  XCLayoutUtil.m
//  XCDevKit
//
//  Created by 钧泰科技 on 15/4/20.
//  Copyright (c) 2015年 wxc. All rights reserved.
//
#if !__has_feature(objc_arc)
#error must be built with ARC.
#endif

#import "XCLayoutUtil.h"
#import <objc/runtime.h>

@implementation XCLayoutUtil

//动态方法调用
+ (id)callBackSel:(id)eventObj sel:(SEL)sel parames:(id)parames
{
    @autoreleasepool {
        NSMethodSignature *signature = [eventObj methodSignatureForSelector:sel];
        NSUInteger length = [signature numberOfArguments];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:eventObj];
        [invocation setSelector:sel];
        
        if (length == 2)
        {
            [invocation invoke];
            if ([signature methodReturnLength])
            {
                return [self returnData:invocation];
            }
            return nil;
        }
        for (NSUInteger i = 2; i < length; ++i)
        {
            if ([parames count] == i-2)
            {
                break;
            }
            id p = [parames objectAtIndex:i-2];
            if (p == nil || p == [NSNull null])
            {
                [invocation setArgument:nil atIndex:i];
            }
            else
                [invocation setArgument:&p atIndex:i];
        }
        [invocation invoke];
        if ([signature methodReturnLength])
        {
            return [self returnData:invocation];
        }
        return nil;
    }
}
+ (id)returnData:(NSInvocation *)invocation
{
    __autoreleasing id data;
    [invocation getReturnValue:&data];
    return data;
}

//解析json 样式文件 自动追加 前后{}
+ (NSMutableDictionary *)getDictionaryByFileJson:(NSString *)file
{
    NSError *error = nil;
    NSString *assemblyJson = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    NSString * regexStr = @"/\\*.*\\*/|//.*";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    assemblyJson = [regularExpression stringByReplacingMatchesInString:assemblyJson options:NSMatchingReportProgress range:NSMakeRange(0, assemblyJson.length) withTemplate:@""];
    assemblyJson =[NSString  stringWithFormat:@"{%@}",assemblyJson];
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[assemblyJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    
    if (error)
    {
        return nil;
    }
    return dic;
}

+ (NSString *)getRuntimeValue:(NSString *)value l:(NSString *)l r:(NSString *)r
{
    NSRange lr = [value rangeOfString:l];
    NSRange rr = [value rangeOfString:r];
    
    value =[value substringWithRange:NSMakeRange(lr.location + lr.length, rr.location - (lr.location + lr.length))];
    return value;
}

+ (void)setObjProperty:(id)obj key:(NSString *)key value:(id)value
{
    @try
    {
        if (value == nil || value == [NSNull null])
        {
//            [obj setValue:@"" forKeyPath:key];
            return;
        }
        
//        if ([value isKindOfClass:[NSNumber class]])
//        {
//            [obj setValue:[value stringValue] forKeyPath:key];
//            return;
//        }
//        if ([obj valueForKeyPath:key] !=nil && [[obj valueForKeyPath:key] isKindOfClass:[NSNumber class]] && ([[obj valueForKeyPath:key] isEqualToNumber:[NSNumber numberWithBool:NO]] || [[obj valueForKeyPath:key] isEqualToNumber:[NSNumber numberWithBool:YES]]))
//        {
//            [obj setValue:[NSNumber numberWithInteger:[value intValue]] forKeyPath:key];
//            return;
//        }
        [obj setValue:value forKeyPath:key];
    }
    @catch (NSException *exception)
    {
        
    }
}

#pragma mark -
#pragma mark 创建一个纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (BOOL)isSizeFits:(UIView *)view
{
    if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UITextField class]]
        || [view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UIButton class]]
        || [view isKindOfClass:[UIImageView class]])
    {
        return YES;
    }
    return NO;
}
@end
