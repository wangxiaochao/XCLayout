//
//  XCBorderLineDraw.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/5.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCBorderLineDraw : NSObject
@property(nonatomic,strong) UIColor *color;       //边界线的颜色
@property(nonatomic,strong) UIColor *insetColor __attribute__((deprecated));       //嵌入颜色，用于实现立体效果,这个属性无效。
@property(nonatomic,assign) CGFloat thick;        //边界线厚度,默认为1
@property(nonatomic,assign) CGFloat headIndent;   //边界线头部缩进单位
@property(nonatomic, assign) CGFloat tailIndent;  //边界线尾部缩进单位
@property(nonatomic, assign) CGFloat dash;        //虚线的点数如果为0则是实线。

-(id)initWithColor:(UIColor*)color;
@end

@class XCLayoutSizeClass;
@interface XCBorderLineLayerDelegate : NSObject
@property(nonatomic ,strong) CAShapeLayer *leftBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *rightBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *topBorderLineLayer;
@property(nonatomic ,strong) CAShapeLayer *bottomBorderLineLayer;

@property(nonatomic ,weak) XCLayoutSizeClass *sizeClass;

- (id)initWithLayout:(XCLayoutSizeClass *)sizeClass;
@end




