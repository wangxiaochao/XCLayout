//
//  XCLayoutView+Ext+Property.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/3.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutView+Ext+Property.h"
#import "XCLayoutView+Ext+Inner.h"

#import "XCLayoutSizeClassInner.h"

@implementation UIView(XCLayoutViewExtProperty)

- (void)setXc_id:(NSString *)xc_id
{
    self.xc_sizeClass.cid = xc_id;
}
- (NSString *)xc_id
{
    return self.xc_sizeClass.cid;
}


#pragma mark -- 样式设置
//位置
- (XCLayoutPos *)xc_left
{
    return self.xc_sizeClass.left;
}
- (XCLayoutPos *)xc_bottom
{
    return self.xc_sizeClass.bottom;
}
- (XCLayoutPos *)xc_top
{
    return self.xc_sizeClass.top;
}
- (XCLayoutPos *)xc_right
{
    return self.xc_sizeClass.right;
}
- (UIEdgeInsets)xc_tlbr
{
    return self.xc_sizeClass.tlbr;
}
- (void)setXc_tlbr:(UIEdgeInsets)xc_tlbr
{
    self.xc_sizeClass.tlbr = xc_tlbr;
}
- (void)setXc_Left:(CGFloat)xc_Left
{
    self.xc_sizeClass.left.equalTo(xc_Left);
}
- (CGFloat)xc_Left
{
    return self.xc_sizeClass.left.val;
}
- (void)setXc_Top:(CGFloat)xc_Top
{
    self.xc_sizeClass.top.equalTo(xc_Top);
}
- (CGFloat)xc_Top
{
    return self.xc_sizeClass.top.val;
}
- (void)setXc_Bottom:(CGFloat)xc_Bottom
{
    self.xc_sizeClass.bottom.equalTo(xc_Bottom);
}
- (CGFloat)xc_Bottom
{
    return self.xc_sizeClass.bottom.val;
}
- (void)setXc_Right:(CGFloat)xc_Right
{
    self.xc_sizeClass.right.equalTo(xc_Right);
}
- (CGFloat)xc_Right
{
    return self.xc_sizeClass.right.val;
}

//内边距
- (XCLayoutPos *)xc_paddingLeft
{
    return self.xc_sizeClass.paddingLeft;
}
- (XCLayoutPos *)xc_paddingBottom
{
    return self.xc_sizeClass.paddingBottom;
}
- (XCLayoutPos *)xc_paddingTop
{
    return self.xc_sizeClass.paddingTop;
}
- (XCLayoutPos *)xc_paddingRight
{
    return self.xc_sizeClass.paddingRight;
}
- (UIEdgeInsets)xc_padding
{
    return self.xc_sizeClass.padding;
}
- (void)setXc_padding:(UIEdgeInsets)xc_padding
{
    self.xc_sizeClass.padding = xc_padding;
}
- (void)setXc_PaddingBottom:(CGFloat)xc_PaddingBottom
{
    self.xc_sizeClass.paddingBottom.equalTo(xc_PaddingBottom);
}
- (CGFloat)xc_PaddingBottom
{
    return self.xc_sizeClass.paddingBottom.val;
}
- (void)setXc_PaddingTop:(CGFloat)xc_PaddingTop
{
    self.xc_sizeClass.paddingTop.equalTo(xc_PaddingTop);
}
- (CGFloat)xc_PaddingTop
{
    return self.xc_sizeClass.paddingTop.val;
}
- (void)setXc_PaddingLeft:(CGFloat)xc_PaddingLeft
{
    self.xc_sizeClass.paddingLeft.equalTo(xc_PaddingLeft);
}
- (CGFloat)xc_PaddingLeft
{
    return self.xc_sizeClass.paddingLeft.val;
}
- (void)setXc_PaddingRight:(CGFloat)xc_PaddingRight
{
    self.xc_sizeClass.paddingRight.equalTo(xc_PaddingRight);
}
- (CGFloat)xc_PaddingRight
{
    return self.xc_sizeClass.paddingRight.val;
}

//外边距
- (XCLayoutPos *)xc_marginLeft
{
    return self.xc_sizeClass.marginLeft;
}
- (XCLayoutPos *)xc_marginBottom
{
    return self.xc_sizeClass.marginBottom;
}
- (XCLayoutPos *)xc_marginTop
{
    return self.xc_sizeClass.marginTop;
}
- (XCLayoutPos *)xc_marginRight
{
    return self.xc_sizeClass.marginRight;
}
- (UIEdgeInsets)xc_margin
{
    return self.xc_sizeClass.margin;
}
- (void)setXc_margin:(UIEdgeInsets)xc_margin
{
    self.xc_sizeClass.margin = xc_margin;
}
- (void)setXc_MarginBottom:(CGFloat)xc_MarginBottom
{
    self.xc_sizeClass.marginBottom.equalTo(xc_MarginBottom);
}
- (CGFloat)xc_MarginBottom
{
    return self.xc_sizeClass.marginBottom.val;
}
- (void)setXc_MarginTop:(CGFloat)xc_MarginTop
{
    self.xc_sizeClass.marginTop.equalTo(xc_MarginTop);
}
- (CGFloat)xc_MarginTop
{
    return self.xc_sizeClass.marginTop.val;
}
- (void)setXc_MarginLeft:(CGFloat)xc_MarginLeft
{
    self.xc_sizeClass.marginLeft.equalTo(xc_MarginLeft);
}
- (CGFloat)xc_MarginLeft
{
    return self.xc_sizeClass.marginLeft.val;
}
- (void)setXc_MarginRight:(CGFloat)xc_MarginRight
{
    self.xc_sizeClass.marginRight.equalTo(xc_MarginRight);
}
- (CGFloat)xc_MarginRight
{
    return self.xc_sizeClass.marginRight.val;
}

//尺寸
- (XCLayoutSize *)xc_width
{
    return self.xc_sizeClass.width;
}
- (XCLayoutSize *)xc_height
{
    return self.xc_sizeClass.height;
}
- (void)setXc_size:(CGSize)xc_size
{
    self.xc_sizeClass.size = xc_size;
}
- (void)sizeLayoutFit
{
    self.xc_sizeClass.width.equalToFit();
    self.xc_sizeClass.height.equalToFit();
}
- (void)setXc_heightAuto:(BOOL)xc_heightAuto
{
    self.xc_sizeClass.heightAuto = xc_heightAuto;
}
- (BOOL)xc_heightAuto
{
    return self.xc_sizeClass.heightAuto;
}


- (void)setXc_Width:(CGFloat)xc_Width
{
    self.xc_sizeClass.width.equalTo(xc_Width);
}
- (CGFloat)xc_Width
{
    return self.xc_sizeClass.width.sizeValue;
}
- (void)setXc_Height:(CGFloat)xc_Height
{
    self.xc_sizeClass.height.equalTo(xc_Height);
}
- (CGFloat)xc_Height
{
    return self.xc_sizeClass.height.sizeValue;
}


- (void)setXc_display:(XCLayoutDisplay)xc_display
{
    self.xc_sizeClass.display = xc_display;
}
- (XCLayoutDisplay)xc_display
{
    return self.xc_sizeClass.display;
}

- (void)setXc_position:(XCLayoutPosition)xc_position
{
    self.xc_sizeClass.position = xc_position;
}
- (XCLayoutPosition)xc_position
{
    return self.xc_sizeClass.position;
}

- (void)setXc_center:(XCLayoutCenter)xc_center
{
    self.xc_sizeClass.center = xc_center;
}
- (XCLayoutCenter)xc_center
{
    return self.xc_sizeClass.center;
}

- (void)setXc_inlineBr:(BOOL)xc_inlineBr
{
    self.xc_sizeClass.inlineBr = xc_inlineBr;
}
- (BOOL)xc_inlineBr
{
    return self.xc_sizeClass.inlineBr;
}
#pragma end


#pragma mark -- 边线
- (void)setXc_bottomBorderLine:(XCBorderLineDraw *)xc_bottomBorderLine
{
    self.xc_sizeClass.bottomBorderLine = xc_bottomBorderLine;
}
- (XCBorderLineDraw *)xc_bottomBorderLine
{
    return self.xc_sizeClass.bottomBorderLine;
}
- (void)setXc_topBorderLine:(XCBorderLineDraw *)xc_topBorderLine
{
    self.xc_sizeClass.topBorderLine = xc_topBorderLine;
}
- (XCBorderLineDraw *)xc_topBorderLine
{
    return self.xc_sizeClass.topBorderLine;
}
- (void)setXc_leftBorderLine:(XCBorderLineDraw *)xc_leftBorderLine
{
    self.xc_sizeClass.leftBorderLine = xc_leftBorderLine;
}
- (XCBorderLineDraw *)xc_leftBorderLine
{
    return self.xc_sizeClass.leftBorderLine;
}
- (void)setXc_rightBorderLine:(XCBorderLineDraw *)xc_rightBorderLine
{
    self.xc_sizeClass.rightBorderLine = xc_rightBorderLine;
}
- (XCBorderLineDraw *)xc_rightBorderLine
{
    return self.xc_sizeClass.rightBorderLine;
}
- (void)setXc_borderLine:(XCBorderLineDraw *)xc_borderLine
{
    self.xc_sizeClass.borderLine = xc_borderLine;
}
- (XCBorderLineDraw *)xc_borderLine
{
    return self.xc_sizeClass.borderLine;
}

- (void)setXc_backgroundImage:(UIImage *)xc_backgroundImage
{
    self.xc_sizeClass.backgroundImage = xc_backgroundImage;
}
- (UIImage *)xc_backgroundImage
{
    return self.xc_sizeClass.backgroundImage;
}
#pragma end

//设置布局开始时候的回调函数
- (void)xc_setLayoutBeginSEL:(id)tag sel:(SEL)sel
{
    [self.xc_sizeClass setLayoutBeginSEL:tag sel:sel];
}
//设置布局结束的时候回调的函数
- (void)xc_setLayoutEndSEL:(id)tag sel:(SEL)sel
{
    [self.xc_sizeClass setLayoutEndSEL:tag sel:sel];
}

- (void)xc_callBeginSEL
{
    [self.xc_sizeClass callBeginSEL];
}
- (void)xc_callEndSEL
{
    [self.xc_sizeClass callEndSEL];
}

- (void)setXc_beginLayoutBlock:(void (^)(UIView *))beginLayoutBlock
{
    self.xc_sizeClass.beginLayoutBlock = beginLayoutBlock;
}
- (void (^)(UIView *))xc_beginLayoutBlock
{
    return self.xc_sizeClass.beginLayoutBlock;
}
- (void)setXc_endLayoutBlock:(void (^)(UIView *))endLayoutBlock
{
    self.xc_sizeClass.endLayoutBlock = endLayoutBlock;
}
- (void (^)(UIView *))xc_endLayoutBlock
{
    return self.xc_sizeClass.endLayoutBlock;
}
@end


@implementation XCButtonView

#pragma mark -- 背景高亮和图片
- (void)setXc_highlightedBackgroundColor:(UIColor *)xc_highlightedBackgroundColor
{
    self.xc_sizeClass.highlightedBackgroundColor = xc_highlightedBackgroundColor;
}
- (UIColor *)xc_highlightedBackgroundColor
{
    return self.xc_sizeClass.highlightedBackgroundColor;
}

- (void)setXc_highlightedBackgroundImage:(UIImage *)xc_highlightedBackgroundImage
{
    self.xc_sizeClass.highlightedBackgroundImage = xc_highlightedBackgroundImage;
}
- (UIImage *)xc_highlightedBackgroundImage
{
    return self.xc_sizeClass.highlightedBackgroundImage;
}
#pragma end

#pragma mark --- teach事件 背景高亮
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (![self isKindOfClass:[UIView class]])
    {
        return;
    }
    
    
    XCButtonView *view = (XCButtonView *)self;
    
    if (view.xc_highlightedBackgroundColor != nil)
    {
        view.xc_sizeClass.oldBackgroundColor = view.backgroundColor;
        view.backgroundColor = view.xc_highlightedBackgroundColor;
    }
    
    if (view.xc_highlightedBackgroundImage != nil)
    {
        view.xc_sizeClass.oldBackgroundImage = view.xc_backgroundImage;
        view.xc_backgroundImage = view.xc_highlightedBackgroundImage;
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    XCButtonView *view = (XCButtonView *)self;
    if (![self isKindOfClass:[UIView class]] || (view.xc_highlightedBackgroundColor == nil && view.xc_highlightedBackgroundImage == nil))
    {
        return;
    }
    
    [self performSelector:@selector(xc_doTargetAction) withObject:nil afterDelay:0.25];
    //    [self xc_doTargetAction];
}
- (void)xc_doTargetAction
{
    if (![self isKindOfClass:[UIView class]])
    {
        return;
    }
    XCButtonView *view = (XCButtonView *)self;
    
    if (view.xc_highlightedBackgroundColor != nil)
    {
        view.backgroundColor = view.xc_sizeClass.oldBackgroundColor;
        view.xc_sizeClass.oldBackgroundColor = nil;
    }
    
    if (view.xc_highlightedBackgroundImage != nil)
    {
        view.xc_backgroundImage = view.xc_sizeClass.oldBackgroundImage;
        view.xc_sizeClass.oldBackgroundImage = nil;
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if (![self isKindOfClass:[UIView class]])
    {
        return;
    }
    XCButtonView *view = (XCButtonView *)self;
    if (view.xc_highlightedBackgroundColor != nil)
    {
        view.backgroundColor = view.xc_sizeClass.oldBackgroundColor;
        view.xc_sizeClass.oldBackgroundColor = nil;
    }
    
    if (view.xc_highlightedBackgroundImage != nil)
    {
        view.xc_backgroundImage = view.xc_sizeClass.oldBackgroundImage;
        view.xc_sizeClass.oldBackgroundImage = nil;
    }
    
}
#pragma end

@end






