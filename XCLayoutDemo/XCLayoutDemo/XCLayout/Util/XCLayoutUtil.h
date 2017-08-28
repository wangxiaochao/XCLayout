//
//  XCLayoutUtil.h
//  XCDevKit
//
//  Created by 钧泰科技 on 15/4/20.
//  Copyright (c) 2015年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XCLayoutUtil : NSObject

+ (id)callBackSel:(id)eventObj sel:(SEL)sel parames:(id)parames;

//解析json 样式文件 自动追加 前后{}
+ (NSMutableDictionary *)getDictionaryByFileJson:(NSString *)file;
//解析$()值
+ (NSString *)getRuntimeValue:(NSString *)value l:(NSString *)l r:(NSString *)r;

+ (void)setObjProperty:(id)obj key:(NSString *)key value:(id)value;

//+ (void)additionalAutoLayout:(id)object target:(id)target;


/**
 *创建一个纯色的图片
 *param color要创建图片的颜色 andSize图片大小
 *@return 创建好的纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;



+ (BOOL)isSizeFits:(UIView *)view;
@end
