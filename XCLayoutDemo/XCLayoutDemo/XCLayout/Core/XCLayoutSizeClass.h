//
//  XCLayoutSizeClass.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/1.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCLayoutDefine.h"

#import "XCLayoutPos.h"
#import "XCLayoutSize.h"

#import "XCBorderLineDraw.h"


@interface XCLayoutSizeClass : NSObject
@property (nonatomic,strong) NSString *cid;

//位置
@property (nonatomic,strong) XCLayoutPos *top;
@property (nonatomic,strong) XCLayoutPos *right;
@property (nonatomic,strong) XCLayoutPos *bottom;
@property (nonatomic,strong) XCLayoutPos *left;
@property (nonatomic,assign) UIEdgeInsets tlbr;

//内边距
@property (nonatomic,strong) XCLayoutPos *paddingTop;
@property (nonatomic,strong) XCLayoutPos *paddingRight;
@property (nonatomic,strong) XCLayoutPos *paddingBottom;
@property (nonatomic,strong) XCLayoutPos *paddingLeft;
@property (nonatomic,assign) UIEdgeInsets padding;

//外边距
@property (nonatomic,strong) XCLayoutPos *marginTop;
@property (nonatomic,strong) XCLayoutPos *marginRight;
@property (nonatomic,strong) XCLayoutPos *marginBottom;
@property (nonatomic,strong) XCLayoutPos *marginLeft;
@property (nonatomic,assign) UIEdgeInsets margin;

//尺寸
@property (nonatomic,strong) XCLayoutSize *width;
@property (nonatomic,strong) XCLayoutSize *height;
@property (nonatomic,assign,readwrite) CGSize size;
@property (nonatomic,assign) BOOL heightAuto;       //高是否可以被子控件撑开 默认都是可以的

//元素类型
@property (nonatomic,assign) XCLayoutDisplay display;
//定位类型
@property (nonatomic,assign) XCLayoutPosition position;
//居中
@property (nonatomic,assign) XCLayoutCenter center;

@property (nonatomic,assign) BOOL inlineBr;   //内链布局是否自动换行 默认NO



//绘制的边界线。
@property(nonatomic, strong) XCBorderLineDraw *leftBorderLine;
@property(nonatomic, strong) XCBorderLineDraw *rightBorderLine;
@property(nonatomic, strong) XCBorderLineDraw *topBorderLine;
@property(nonatomic, strong) XCBorderLineDraw *bottomBorderLine;
//同时设置4个边界线。
@property(nonatomic, strong) XCBorderLineDraw *borderLine;


//布局高亮的背景色,我们支持在布局中执行触摸的事件，用户触摸手势按下时背景会高亮
@property(nonatomic,strong) UIColor *highlightedBackgroundColor;

//设置布局背景图片和高亮的背景图片。
@property(nonatomic,strong) UIImage *backgroundImage;
@property(nonatomic,strong) UIImage *highlightedBackgroundImage;

//设置布局开始时候的回调函数
- (void)setLayoutBeginSEL:(id)tag sel:(SEL)sel;
//设置布局结束的时候回调的函数
- (void)setLayoutEndSEL:(id)tag sel:(SEL)sel;

- (void)callBeginSEL;
- (void)callEndSEL;

@property(nonatomic,copy) void (^beginLayoutBlock)(UIView *view);
@property(nonatomic,copy) void (^endLayoutBlock)(UIView *view);
@end



