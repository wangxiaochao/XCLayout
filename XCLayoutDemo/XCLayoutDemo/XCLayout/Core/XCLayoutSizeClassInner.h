//
//  XCLayoutSizeClassInner.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/2.
//  Copyright © 2016年 wxc. All rights reserved.
//

//内部使用 不对外

@class XCLayoutBody;

@interface XCLayoutSizeClass()
@property (nonatomic,strong) UIColor *oldBackgroundColor;        //用于记录原本颜色和背景图 点击高亮的时候使用
@property (nonatomic,strong) UIImage *oldBackgroundImage;

@property (nonatomic,strong) XCBorderLineLayerDelegate *layerDelegate;

@property (nonatomic,weak) UIView *view;                //当前对应view XCLayoutView+Ext 中 xc_init()初始化赋值
@property (nonatomic,weak) UIView *superView;           //当前view所在父view XCLayoutView+Ext 中 xc_didAddSubview添加时赋值
@property (nonatomic,weak) UIView *topView;             //当前view布局上一个view XCLayoutBody 中循环计算布局时赋值
@property (nonatomic,weak) XCLayoutBody *body;                 //当前view所在bodyView XCLayoutView+Ext 中 xc_didAddSubview添加时赋值

//在文档流中的 才有意义
@property (nonatomic,assign) int rowIndx;           //当前行 父元素内第几行
@property (nonatomic,assign) CGFloat rowBY;         //当前行 最下方Y轴距离相对父元素

@property (nonatomic,strong) id beginTag;
@property (nonatomic,strong) id endTag;
@property (nonatomic,assign) SEL beginSEL;
@property (nonatomic,assign) SEL endSEL;


- (CGRect)layoutRect;
@end

