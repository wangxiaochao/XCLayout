//
//  XCLayoutStyleFill.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

//样式填充
#import <UIKit/UIKit.h>

@class XCLayoutViewXMLObject;
@interface XCLayoutStyleFill : NSObject

/**
 *样式填充 obj 填充对象 style要填充的样式列表 摘取的 动态属性列表 runtionDic
 */
+ (void)fillStyleGetRuntimeProperty:(UIView *)view style:(NSMutableDictionary *)style runtionDic:(NSMutableDictionary *)runtionDic viewXML:(XCLayoutViewXMLObject *)viewXML;


//单个样式填充
+ (void)fillStyle:(UIView *)view key:(NSString *)key value:(NSString *)value;


//样式填充
//color
+ (UIColor *)getColor:(NSString *)value;
//font
+ (UIFont *)getFont:(NSString *)value;
//image
+ (UIImage *)getImage:(NSString *)value;
@end
