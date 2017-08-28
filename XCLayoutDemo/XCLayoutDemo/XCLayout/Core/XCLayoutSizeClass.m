//
//  XCLayoutSizeClass.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/1.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutSizeClass.h"
#import "XCLayoutSizeClassInner.h"

#import "XCLayoutView+Ext+Inner.h"
#import "XCLayoutView+Ext.h"

#import "XCLayoutBody.h"
#import "XCLayoutBodyInner.h"

#import "XCLayoutUtil.h"

@implementation XCLayoutSizeClass
- (void)dealloc
{
    self.beginLayoutBlock = nil;
    self.endLayoutBlock = nil;
}

- (id)init
{
    if (self = [super init])
    {
        _heightAuto = YES;
    }
    return self;
}

- (void)loadLayout
{
    [self.body setNeedsLayout];       //刷新body
}

//位置
- (XCLayoutPos *)top
{
    if (_top == nil)
    {
        _top = [XCLayoutPos new];
        _top.view = self.view;
        _top.sizeClass = self;
    }
    return _top;
}
- (XCLayoutPos *)left
{
    if (_left == nil)
    {
        _left = [XCLayoutPos new];
        _left.view = self.view;
        _left.sizeClass = self;
    }
    return _left;
}
- (XCLayoutPos *)bottom
{
    if (_bottom == nil)
    {
        _bottom = [XCLayoutPos new];
        _bottom.view = self.view;
        _bottom.sizeClass = self;
    }
    return _bottom;
}
- (XCLayoutPos *)right
{
    if (_right == nil)
    {
        _right = [XCLayoutPos new];
        _right.view = self.view;
        _right.sizeClass = self;
    }
    return _right;
}

- (void)setTlbr:(UIEdgeInsets)tlbr
{
    self.top.equalTo_not(tlbr.top);
    self.left.equalTo_not(tlbr.left);
    self.bottom.equalTo_not(tlbr.bottom);
    self.right.equalTo(tlbr.right);
}
- (UIEdgeInsets)tlbr
{
    return UIEdgeInsetsMake(self.top.val, self.left.val, self.bottom.val, self.right.val);
}
//内边距
- (XCLayoutPos *)paddingTop
{
    if (_paddingTop == nil)
    {
        _paddingTop = [XCLayoutPos new];
        _paddingTop.view = self.view;
        _paddingTop.sizeClass = self;
    }
    return _paddingTop;
}
- (XCLayoutPos *)paddingBottom
{
    if (_paddingBottom == nil)
    {
        _paddingBottom = [XCLayoutPos new];
        _paddingBottom.view = self.view;
        _paddingBottom.sizeClass = self;
    }
    return _paddingBottom;
}
- (XCLayoutPos *)paddingRight
{
    if (_paddingRight == nil)
    {
        _paddingRight = [XCLayoutPos new];
        _paddingRight.view = self.view;
        _paddingRight.sizeClass = self;
    }
    return _paddingRight;
}
- (XCLayoutPos *)paddingLeft
{
    if (_paddingLeft == nil)
    {
        _paddingLeft = [XCLayoutPos new];
        _paddingLeft.view = self.view;
        _paddingLeft.sizeClass = self;
    }
    return _paddingLeft;
}
- (void)setPadding:(UIEdgeInsets)padding
{
    self.paddingTop.equalTo_not(padding.top);
    self.paddingLeft.equalTo_not(padding.left);
    self.paddingBottom.equalTo_not(padding.bottom);
    self.paddingRight.equalTo(padding.right);
}
- (UIEdgeInsets)padding
{
    return UIEdgeInsetsMake(self.paddingTop.val, self.paddingLeft.val, self.paddingBottom.val, self.paddingRight.val);
}
//外边距
- (XCLayoutPos *)marginLeft
{
    if (_marginLeft == nil)
    {
        _marginLeft = [XCLayoutPos new];
        _marginLeft.view = self.view;
        _marginLeft.sizeClass = self;
    }
    return _marginLeft;
}
- (XCLayoutPos *)marginTop
{
    if (_marginTop == nil)
    {
        _marginTop = [XCLayoutPos new];
        _marginTop.view = self.view;
        _marginTop.sizeClass = self;
    }
    return _marginTop;
}
- (XCLayoutPos *)marginBottom
{
    if (_marginBottom == nil)
    {
        _marginBottom = [XCLayoutPos new];
        _marginBottom.view = self.view;
        _marginBottom.sizeClass = self;
    }
    return _marginBottom;
}
- (XCLayoutPos *)marginRight
{
    if (_marginRight == nil)
    {
        _marginRight = [XCLayoutPos new];
        _marginRight.view = self.view;
        _marginRight.sizeClass = self;
    }
    return _marginRight;
}
- (UIEdgeInsets)margin
{
    return UIEdgeInsetsMake(self.marginTop.val, self.marginLeft.val, self.marginBottom.val, self.marginRight.val);
}
- (void)setMargin:(UIEdgeInsets)margin
{
    self.marginTop.equalTo_not(margin.top);
    self.marginBottom.equalTo_not(margin.bottom);
    self.marginLeft.equalTo_not(margin.left);
    self.marginRight.equalTo(margin.right);
}

//尺寸
- (XCLayoutSize *)width
{
    if (_width == nil)
    {
        _width = [XCLayoutSize new];
        _width.view = self.view;
        _width.sizeClass = self;
    }
    return _width;
}
- (XCLayoutSize *)height
{
    if (_height == nil)
    {
        _height = [XCLayoutSize new];
        _height.view = self.view;
        _height.sizeClass = self;
    }
    return _height;
}
- (void)setSize:(CGSize)size
{
    self.width.equalTo_not(size.width);
    self.height.equalTo(size.height);
}

- (void)setHeightAuto:(BOOL)heightAuto
{
    if (_heightAuto != heightAuto)
    {
        _heightAuto = heightAuto;
        [self loadLayout];
    }
}

- (void)setDisplay:(XCLayoutDisplay)display
{
    if (_display != display)
    {
        _display = display;
        if (_display == XCLayoutDisplay_Nono)
        {
            self.view.hidden = YES;
        }
        [self loadLayout];
    }
}
- (void)setPosition:(XCLayoutPosition)position
{
    if (_position != position)
    {
        _position = position;
        [self loadLayout];
    }
}
- (void)setCenter:(XCLayoutCenter)center
{
    if (_center != center)
    {
        _center = center;
        [self loadLayout];
    }
}
- (void)setInlineBr:(BOOL)inlineBr
{
    if (_inlineBr != inlineBr)
    {
        _inlineBr = inlineBr;
        [self loadLayout];
    }
}

#pragma mark --- 画线
-(void)setBorderLine:(XCBorderLineDraw *)borderLine
{
    self.leftBorderLine = borderLine;
    self.rightBorderLine = borderLine;
    self.topBorderLine = borderLine;
    self.bottomBorderLine = borderLine;
}
- (XCBorderLineDraw *)borderLine
{
    return self.leftBorderLine;
}

- (void)setBottomBorderLine:(XCBorderLineDraw *)bottomBorderLine
{
    if (_bottomBorderLine != bottomBorderLine)
    {
        _bottomBorderLine = bottomBorderLine;
        if (self.layerDelegate == nil)
            self.layerDelegate = [[XCBorderLineLayerDelegate alloc] initWithLayout:self];
        
        CAShapeLayer *borderLayer = self.layerDelegate.bottomBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_bottomBorderLine];
        self.layerDelegate.bottomBorderLineLayer = borderLayer;
    }
}
- (void)setTopBorderLine:(XCBorderLineDraw *)topBorderLine
{
    if (_topBorderLine != topBorderLine)
    {
        _topBorderLine = topBorderLine;
        if (self.layerDelegate == nil)
            self.layerDelegate = [[XCBorderLineLayerDelegate alloc] initWithLayout:self];
        
        CAShapeLayer *borderLayer = self.layerDelegate.topBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_topBorderLine];
        self.layerDelegate.topBorderLineLayer = borderLayer;
    }
}
- (void)setLeftBorderLine:(XCBorderLineDraw *)leftBorderLine
{
    if (_leftBorderLine != leftBorderLine)
    {
        _leftBorderLine = leftBorderLine;
        if (self.layerDelegate == nil)
            self.layerDelegate = [[XCBorderLineLayerDelegate alloc] initWithLayout:self];
        
        CAShapeLayer *borderLayer = self.layerDelegate.leftBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_leftBorderLine];
        self.layerDelegate.leftBorderLineLayer = borderLayer;
    }
}
- (void)setRightBorderLine:(XCBorderLineDraw *)rightBorderLine
{
    if (_rightBorderLine != rightBorderLine)
    {
        _rightBorderLine = rightBorderLine;
        if (self.layerDelegate == nil)
            self.layerDelegate = [[XCBorderLineLayerDelegate alloc] initWithLayout:self];
        
        CAShapeLayer *borderLayer = self.layerDelegate.rightBorderLineLayer;
        [self updateBorderLayer:&borderLayer withBorderLineDraw:_rightBorderLine];
        self.layerDelegate.rightBorderLineLayer = borderLayer;
    }
}


- (void)updateBorderLayer:(CAShapeLayer**)ppLayer withBorderLineDraw:(XCBorderLineDraw *)borderLineDraw
{
    if (borderLineDraw == nil)
    {
        if (*ppLayer != nil)
        {
            (*ppLayer).delegate = nil;
            [(*ppLayer) removeFromSuperlayer];
            *ppLayer = nil;
        }
    }
    else
    {
        if (_layerDelegate == nil)
            _layerDelegate = [[XCBorderLineLayerDelegate alloc] initWithLayout:self];
        
        if ( *ppLayer == nil)
        {
            *ppLayer = [[CAShapeLayer alloc] init];
            (*ppLayer).delegate = _layerDelegate;
            [self.view.layer addSublayer:*ppLayer];
        }
        
        //如果是点线则是用path，否则就用背景色
        if (borderLineDraw.dash != 0)
        {
            (*ppLayer).lineDashPhase = borderLineDraw.dash / 2;
            NSNumber *num = @(borderLineDraw.dash);
            (*ppLayer).lineDashPattern = @[num,num];
            
            (*ppLayer).strokeColor = borderLineDraw.color.CGColor;
            (*ppLayer).lineWidth = borderLineDraw.thick;
            (*ppLayer).backgroundColor = nil;
            
        }
        else
        {
            (*ppLayer).lineDashPhase = 0;
            (*ppLayer).lineDashPattern = nil;
            
            (*ppLayer).strokeColor = nil;
            (*ppLayer).lineWidth = 0;
            (*ppLayer).backgroundColor = borderLineDraw.color.CGColor;
            
        }
        
        [(*ppLayer) setNeedsLayout];
        
    }
}
#pragma end

#pragma mark --- 设置背景图片
-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage)
    {
        _backgroundImage = backgroundImage;
        self.view.layer.contents = (id)_backgroundImage.CGImage;
    }
}
#pragma end

#pragma mark --- 事件回调

//设置布局开始时候的回调函数
- (void)setLayoutBeginSEL:(id)tag sel:(SEL)sel
{
    self.beginTag = tag;
    self.beginSEL = sel;
}
//设置布局结束的时候回调的函数
- (void)setLayoutEndSEL:(id)tag sel:(SEL)sel
{
    self.endTag = tag;
    self.endSEL = sel;
}

- (void)callBeginSEL
{
    if (self.beginTag && self.beginSEL)
    {
        if ([self.beginTag respondsToSelector:self.beginSEL])
        {
            [XCLayoutUtil callBackSel:self.beginTag sel:self.beginSEL parames:@[self.view]];
        }
    }
}
- (void)callEndSEL
{
    if (self.endTag && self.endSEL)
    {
        if ([self.endTag respondsToSelector:self.endSEL])
        {
            [XCLayoutUtil callBackSel:self.endTag sel:self.endSEL parames:@[self.view]];
        }
    }
}

#pragma end


//** 获取 rect

- (CGRect)layoutRect
{
    XCLayoutSizeClass *superSizeClass = self.superView.xc_sizeClass;       //父元素
    XCLayoutSizeClass *topSizeClass = self.topView.xc_sizeClass;           //上一个元素

    UIEdgeInsets superPadding = superSizeClass.padding;
    UIEdgeInsets margin = self.margin;
    
    CGPoint point = CGPointMake(superPadding.left+margin.left,superPadding.top+margin.top);
    CGSize size = self.size;
    
    if (self.center == XCLayoutCenter_Nono)
    {
        if (self.display == XCLayoutDisplay_Inline && topSizeClass.display == XCLayoutDisplay_Inline)      //并列布局
        {
            [self calsInlineLayout:&size point:&point];
        }
        else                //整行换行布局
        {
            [self calsBlockLayout:&size point:&point];
        }
    }
    
    
    if (self.position == XCLayoutPosition_Absolute)  //绝对定位     不在文档流内 不设置rowIndx 和 rowBY;
    {
        [self calsAbsoluteLayout:&size point:&point];
    }
    
    if (self.center != XCLayoutCenter_Nono)
    {
        [self calsCenter:&size point:&point superView:self.superView superPadding:superPadding margin:margin];
    }
    
//    if (self.width.type == XCLayoutSizeValueType_Fit && self.height.type == XCLayoutSizeValueType_Fit)      //宽高都sizefits
//        size = [self.view sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
//    else if (self.width.type == XCLayoutSizeValueType_Fit)
//    {
//        CGSize fitSize = [self.view sizeThatFits:CGSizeMake(MAXFLOAT, size.height)];
//        size = CGSizeMake(fitSize.width, size.height);
//    }
//    else if (self.height.type == XCLayoutSizeValueType_Fit)
//    {
//        CGSize fitSize = [self.view sizeThatFits:CGSizeMake(size.width, MAXFLOAT)];
//        size = CGSizeMake(size.width, fitSize.height);
//    }
    
    self.rowBY = size.height + point.y;
    if (self.display == XCLayoutDisplay_Inline && topSizeClass.display == XCLayoutDisplay_Inline)      //并列布局
    {
        if (self.rowBY < self.topView.xc_sizeClass.rowBY)
        {
            self.rowBY = self.topView.xc_sizeClass.rowBY;
        }
    }
    
//    //处理父元素
//    if (superSizeClass.width.type == XCLayoutSizeValueType_Fit)
//    {
//        self.superView.frame = CGRectMake(self.superView.frame.origin.x, self.superView.frame.origin.y, point.x+size.width+superSizeClass.paddingRight.val, self.superView.frame.size.height);
//        if (superSizeClass.display == XCLayoutDisplay_Inline && superSizeClass.topView.xc_sizeClass.display == XCLayoutDisplay_Inline)
//        {
//            self.superView.frame = [superSizeClass layoutRect];
//        }
//    }
    
    return CGRectMake(point.x, point.y, size.width, size.height);
}

//并列布局
- (void)calsInlineLayout:(CGSize *)size point:(CGPoint *)point
{
    XCLayoutSizeClass *superSizeClass = self.superView.xc_sizeClass;
    
    [self calsExpectSize:size type:0];
    
    point->y = (self.topView.frame.origin.y - self.topView.xc_MarginTop) + self.marginTop.val;
    point->x = self.topView.frame.size.width + self.topView.frame.origin.x + self.marginLeft.val;
    
    if (size->width < 0)
        size->width = 0;
    if (size->height < 0)
        size->height = 0;
    
    BOOL isBr = NO;   //是否需要换行
    //判断是否需要换行
    if ((point->x + size->width + self.marginRight.val) > self.superView.frame.size.width)
        isBr = YES;     //需要换行
    else
        isBr = NO;      //不需要换行
    
    if (superSizeClass.inlineBr == NO || isBr == NO)         //不换行
    {
        self.rowIndx = self.topView.xc_sizeClass.rowIndx;
        return;
    }
    
    //需要换行
    [self calsBlockLayout:size point:point];
        
}
//整行布局
- (void)calsBlockLayout:(CGSize *)size point:(CGPoint *)point
{
    XCLayoutSizeClass *superSizeClass = self.superView.xc_sizeClass;       //父元素
    
    UIEdgeInsets superPadding = superSizeClass.padding;
    UIEdgeInsets margin = self.margin;
    
    [self calsExpectSize:size type:1];
    
    point->x = superPadding.left + self.marginLeft.val;
    
    if (self.topView)
        point->y = self.topView.xc_sizeClass.rowBY + self.marginTop.val;
    else
        point->y = superPadding.top + self.marginTop.val;
    
    
    
    if (self.position == XCLayoutPosition_Relative)         //相对定位 元素偏移
    {
        if (self.left.type == XCLayoutPosValType_Nil && self.right.type != XCLayoutPosValType_Nil)
            point->x = point->x - self.right.val;
        else if (self.left.type != XCLayoutPosValType_Nil)
            point->x = point->x + self.left.val;
        
        
        if (self.top.type == XCLayoutPosValType_Nil && self.bottom.type != XCLayoutPosValType_Nil)
            point->y = point->y - self.bottom.val;
        else if (self.top.type != XCLayoutPosValType_Nil)
            point->y = point->y + self.top.val;
    }
    
    //设置行 和 布局进度属性
    if (self.topView)
    {
        self.rowIndx = self.topView.xc_sizeClass.rowIndx + 1;
    }
    else
        self.rowIndx = 0;
}

//居中布局
- (void)calsCenter:(CGSize *)size point:(CGPoint *)point superView:(UIView *)superView superPadding:(UIEdgeInsets)superPadding margin:(UIEdgeInsets)margin
{
    
    [self calsExpectSize:size type:3];
    
    if (self.center == XCLayoutCenter_Center)
    {
        point->x = superView.frame.size.width/2 - size->width/2;
        point->y = superView.frame.size.height/2 - size->height/2;
    }
    else if (self.center == XCLayoutCenter_CenterX)
    {
        point->x = superView.frame.size.width/2 - size->width/2;
    }
    else if (self.center == XCLayoutCenter_CenterY)
    {
        point->y = superView.frame.size.height/2 - size->height/2;
    }
    
}

//绝对定位 计算位置
- (void)calsAbsoluteLayout:(CGSize *)size point:(CGPoint *)point
{
    [self calsExpectSize:size type:2];
    
    if (self.top.type == XCLayoutPosValType_Nil && self.bottom.type != XCLayoutPosValType_Nil)
        point->y = self.superView.frame.size.height - size->height - self.bottom.val;
    else if (self.top.type == XCLayoutPosValType_Nil && self.bottom.type == XCLayoutPosValType_Nil)
        point->y = 0;
    else
        point->y = self.top.val;
    

    if (self.left.type == XCLayoutPosValType_Nil && self.right.type != XCLayoutPosValType_Nil)
        point->x = self.superView.frame.size.width - size->width - self.right.val;
    else if (self.left.type == XCLayoutPosValType_Nil && self.right.type == XCLayoutPosValType_Nil)
        point->x = 0;
    else
        point->x = self.left.val;
        
}


//初步计算 size
- (void)calsExpectSize:(CGSize *)size type:(NSInteger)type
{
    XCLayoutSizeClass *superSizeClass = self.superView.xc_sizeClass;       //父元素
    
    UIEdgeInsets superPadding = superSizeClass.padding;
    UIEdgeInsets margin = self.margin;
    
    if (type == 0)  //并列布局          //不同的布局模式 对 auto 类型的尺寸有不同的计算方式 因此做判断
    {
        if (self.width.type == XCLayoutSizeValueType_Auto)
            size->width = self.superView.frame.size.width - self.topView.frame.size.width - self.topView.frame.origin.x - self.marginLeft.val - self.marginRight.val;
        if (self.height.type == XCLayoutSizeValueType_Auto)
            size->height = self.superView.frame.size.height - self.topView.frame.origin.y + self.topView.xc_MarginTop -self.marginTop.val - self.marginBottom.val;
    }
    else if (type == 1) //整行布局
    {
        if (self.width.type == XCLayoutSizeValueType_Auto)
        {
            size->width = self.superView.frame.size.width - superPadding.left - superPadding.right - margin.left - margin.right;
        }
        if (self.height.type == XCLayoutSizeValueType_Auto)
        {
            if (self.topView)
                size->height = self.superView.frame.size.height - self.topView.xc_sizeClass.rowBY - self.marginTop.val - self.marginBottom.val - superPadding.bottom;
            else
                size->height = self.superView.frame.size.height - superPadding.top - superPadding.bottom - margin.top - margin.bottom;
        }
    }
    else if (type == 2) //绝对定位 计算位置
    {
        if (self.width.type == XCLayoutSizeValueType_Auto)
        {
            size->width = self.superView.frame.size.width - superPadding.left - superPadding.right - margin.left - margin.right;
        }
        if (self.height.type == XCLayoutSizeValueType_Auto)
        {
            size->height = self.superView.frame.size.height - superPadding.top - superPadding.bottom - margin.top - margin.bottom;
        }
    }
    else if (type == 3) //居中
    {
        if (self.width.type == XCLayoutSizeValueType_Auto)
        {
            size->width = self.superView.frame.size.width - superPadding.left - superPadding.right - margin.left - margin.right;
        }
        if (self.height.type == XCLayoutSizeValueType_Auto)
        {
            size->height = self.superView.frame.size.height - superPadding.top - superPadding.bottom - margin.top - margin.bottom;
        }
    }
    
    
    //初步计算 宽高 填充模式 暂不计算
    if (self.width.type == XCLayoutSizeValueType_Frame)
        size->width = self.view.frame.size.width;
    else if (self.width.type == XCLayoutSizeValueType_Value)     //等值 直接赋值
        size->width = self.width.sizeValue;
    else if (self.width.type == XCLayoutSizeValueType_Ratio)  //比例 直接计算赋值
        size->width = self.superView.frame.size.width * self.width.sizeValue;
    else if (self.width.type == XCLayoutSizeValueType_Super)    //铺满 直接跟父窗体宽一样 单要减去父元素padding
        size->width = self.superView.frame.size.width - (superPadding.left + superPadding.right + margin.left + margin.right);
    
    if (self.height.type == XCLayoutSizeValueType_Frame)
        size->height = self.view.frame.size.height;
    else if (self.height.type == XCLayoutSizeValueType_Value)     //等值 直接赋值
        size->height = self.height.sizeValue;
    else if (self.height.type == XCLayoutSizeValueType_Ratio)  //比例 直接计算赋值
        size->height = self.superView.frame.size.height * self.height.sizeValue;
    else if (self.height.type == XCLayoutSizeValueType_Super)    //铺满 直接跟父窗体宽一样 单要减去父元素padding
        size->height = self.superView.frame.size.height - (superPadding.top + superPadding.bottom + margin.top + margin.bottom);
    
    if ([XCLayoutUtil isSizeFits:self.view])
    {
        if (self.width.type == XCLayoutSizeValueType_Fit && self.height.type == XCLayoutSizeValueType_Fit)      //宽高都sizefits
        {
            CGSize fitSize = [self.view sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            size->width = fitSize.width;
            size->height = fitSize.height;
        }
        else if (self.width.type == XCLayoutSizeValueType_Fit)
        {
            CGSize fitSize = [self.view sizeThatFits:CGSizeMake(MAXFLOAT, size->height)];
            size->width = fitSize.width;
        }
        else if (self.height.type == XCLayoutSizeValueType_Fit)
        {
            CGSize fitSize = [self.view sizeThatFits:CGSizeMake(size->width, MAXFLOAT)];
            size->height = fitSize.height;
        }
    }
    else
    {
        CGSize fitSize = [self viewSizeThatFits];
        if (self.width.type == XCLayoutSizeValueType_Fit && self.height.type == XCLayoutSizeValueType_Fit)      //宽高都sizefits
        {
            size->width = fitSize.width;
            size->height = fitSize.height;
        }
        else if (self.width.type == XCLayoutSizeValueType_Fit)
        {
            size->width = fitSize.width;
        }
        else if (self.height.type == XCLayoutSizeValueType_Fit)
        {
            size->height = fitSize.height;
        }
    }
}

- (CGSize)viewSizeThatFits
{
    CGFloat w = 0;
    CGFloat h = 0;
    UIEdgeInsets padding = self.padding;
    
    for (UIView *view in self.view.subviews)
    {
        XCLayoutSizeClass *sizeClass = [view xc_sizeClass];
        if (sizeClass == nil)
        {
            continue;
        }
        if (sizeClass.position == XCLayoutPosition_Absolute)
        {
            continue;
        }
        
        CGFloat xP = view.frame.size.width + view.frame.origin.x + sizeClass.margin.right;
        if (xP > w)
        {
            w = xP;
        }
        CGFloat yP = view.frame.size.height + view.frame.origin.y + sizeClass.margin.bottom;
        if (yP > h)
        {
            h = yP;
        }
    }
    
    return CGSizeMake(w+padding.right, h+padding.bottom);
}

@end








