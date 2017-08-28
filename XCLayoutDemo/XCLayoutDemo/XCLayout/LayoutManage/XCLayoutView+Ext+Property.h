//
//  XCLayoutView+Ext+Property.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/3.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCLayoutSizeClass.h"

@interface UIView(XCLayoutViewExtProperty)
@property (nonatomic,strong) NSString *xc_id;
//位置
@property (nonatomic,readonly) XCLayoutPos *xc_top;
@property (nonatomic,readonly) XCLayoutPos *xc_right;
@property (nonatomic,readonly) XCLayoutPos *xc_bottom;
@property (nonatomic,readonly) XCLayoutPos *xc_left;
@property (nonatomic,assign) UIEdgeInsets xc_tlbr;

@property (nonatomic,assign) CGFloat xc_Top,xc_Right,xc_Bottom,xc_Left;

//内边距
@property (nonatomic,readonly) XCLayoutPos *xc_paddingTop;
@property (nonatomic,readonly) XCLayoutPos *xc_paddingRight;
@property (nonatomic,readonly) XCLayoutPos *xc_paddingBottom;
@property (nonatomic,readonly) XCLayoutPos *xc_paddingLeft;
@property (nonatomic,assign) UIEdgeInsets xc_padding;

@property (nonatomic,assign) CGFloat xc_PaddingTop,xc_PaddingRight,xc_PaddingBottom,xc_PaddingLeft;

//外边距
@property (nonatomic,readonly) XCLayoutPos *xc_marginTop;
@property (nonatomic,readonly) XCLayoutPos *xc_marginRight;
@property (nonatomic,readonly) XCLayoutPos *xc_marginBottom;
@property (nonatomic,readonly) XCLayoutPos *xc_marginLeft;
@property (nonatomic,assign) UIEdgeInsets xc_margin;

@property (nonatomic,assign) CGFloat xc_MarginTop,xc_MarginRight,xc_MarginBottom,xc_MarginLeft;

//尺寸
@property (nonatomic,readonly) XCLayoutSize *xc_width;
@property (nonatomic,readonly) XCLayoutSize *xc_height;
@property (nonatomic,readwrite) CGSize xc_size;
- (void)sizeLayoutFit;

@property (nonatomic,assign) BOOL xc_heightAuto;

@property (nonatomic,readwrite) CGFloat xc_Width,xc_Height;

//元素类型
@property (nonatomic,assign) XCLayoutDisplay xc_display;
//定位类型
@property (nonatomic,assign) XCLayoutPosition xc_position;
//居中
@property (nonatomic,assign) XCLayoutCenter xc_center;

@property (nonatomic,assign) BOOL xc_inlineBr;   //内链布局是否自动换行 默认NO

//绘制的边界线。
@property(nonatomic, strong) XCBorderLineDraw *xc_leftBorderLine;
@property(nonatomic, strong) XCBorderLineDraw *xc_rightBorderLine;
@property(nonatomic, strong) XCBorderLineDraw *xc_topBorderLine;
@property(nonatomic, strong) XCBorderLineDraw *xc_bottomBorderLine;
//同时设置4个边界线。
@property(nonatomic, strong) XCBorderLineDraw *xc_borderLine;


//设置布局背景图片和高亮的背景图片。
@property(nonatomic,strong) UIImage *xc_backgroundImage;


//设置布局开始时候的回调函数
- (void)xc_setLayoutBeginSEL:(id)tag sel:(SEL)sel;
//设置布局结束的时候回调的函数
- (void)xc_setLayoutEndSEL:(id)tag sel:(SEL)sel;

//开始 结束
- (void)xc_callBeginSEL;
- (void)xc_callEndSEL;

@property(nonatomic,copy) void (^xc_beginLayoutBlock)(UIView *view);
@property(nonatomic,copy) void (^xc_endLayoutBlock)(UIView *view);
@end



@interface XCButtonView : UIView
//布局高亮的背景色,支持在布局中执行触摸的事件，用户触摸手势按下时背景会高亮
@property(nonatomic,strong) UIImage *xc_highlightedBackgroundImage;
@property(nonatomic,strong) UIColor *xc_highlightedBackgroundColor;
@end





