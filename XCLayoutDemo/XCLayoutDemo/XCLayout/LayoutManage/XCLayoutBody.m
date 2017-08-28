//
//  XCLayoutBody.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/2.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutBody.h"
#import "XCLayoutBodyInner.h"

#import "XCLayoutView+Ext.h"
#import "XCLayoutView+Ext+Inner.h"

#import "XCLayoutSizeClass.h"
#import "XCLayoutSizeClassInner.h"

#import "XCLayoutUtil.h"
@implementation XCLayoutBody
{
    CGRect _superRect;
    CGRect _bodyRect;
}
- (id)init
{
    if (self = [super init])
    {
        self.isAutoLayout = YES;
        
        XCLayoutSizeClass *sizeClass = [XCLayoutSizeClass new];
        sizeClass.view = self;
        sizeClass.body = self;
        [self setXc_sizcClass:sizeClass];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.isAutoLayout = YES;
        
        XCLayoutSizeClass *sizeClass = [XCLayoutSizeClass new];
        sizeClass.view = self;
        sizeClass.body = self;
        [self setXc_sizcClass:sizeClass];
    }
    return self;
}
//停止自动响应布局
- (void)stopAuto
{
    self.isAutoLayout = NO;
}
//开始自动响应布局 并立刻刷新一次布局
- (void)startAuto
{
    self.isAutoLayout = YES;
    [self setNeedsLayout];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView*)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.superview)
    {
        if (!CGRectEqualToRect(_superRect, self.superview.frame))
        {
            _superRect = self.superview.frame;
            _bodyRect = CGRectZero;
            
            [self setNeedsLayout];
        }
    }
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview != nil)
    {
        if (self.superview != nil)
        {
            [self.superview removeObserver:self forKeyPath:@"frame"];
            [self.superview removeObserver:self forKeyPath:@"bounds"];
        }
        [newSuperview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
        
        XCLayoutSizeClass *sizeClass = [XCLayoutSizeClass new];
        sizeClass.view = newSuperview;
        sizeClass.body = self;
        [newSuperview setXc_sizcClass:sizeClass];
        
        _superRect = newSuperview.frame;
        _bodyRect = CGRectZero;
        return;
    }
    
    [self.superview removeObserver:self forKeyPath:@"frame"];
    [self.superview removeObserver:self forKeyPath:@"bounds"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGRectEqualToRect(_bodyRect, CGRectZero) && CGRectEqualToRect(_bodyRect, self.frame))
    {
        return;
    }
    [self layout];
}

//- (CGRect)calsFrame:(UIView *)superView
//{
//    CGRect rect = CGRectZero;
//    rect.origin.x = self.xc_sizeClass.marginLeft.val;
//    rect.origin.y = self.xc_sizeClass.marginTop.val;
//    
//    if (self.xc_sizeClass.width.type == XCLayoutSizeValueType_Auto || self.xc_sizeClass.width.type == XCLayoutSizeValueType_Super) {
//        rect.size.width = superView.frame.size.width - self.xc_sizeClass.marginLeft.val - self.xc_sizeClass.marginRight.val;
//    }else{
//        rect.size.width = 0;
//    }
//    
//    if (self.xc_sizeClass.height.type == XCLayoutSizeValueType_Auto || self.xc_sizeClass.height.type == XCLayoutSizeValueType_Super) {
//        rect.size.height = superView.frame.size.height - self.xc_sizeClass.marginTop.val - self.xc_sizeClass.marginBottom.val;
//    }else{
//        rect.size.height = 0;
//    }
//    
//    return rect;
//}
- (void)zeroFrame:(UIView *)superView
{
    if (superView.xc_sizeClass == nil)
        return;
    
    superView.frame = CGRectZero;
    
    for (UIView *view in superView.subviews)
    {
        if (view.xc_sizeClass == nil)
            continue;
        
        view.frame = CGRectZero;
        
        if (view.subviews.count > 0)
        {
            [self zeroFrame:view];
        }
    }
    
}

- (CGSize)getSuperLayoutSize
{
    //初始化所以frame
    
    [self zeroFrame:self];
    
    [self layout];
    UIEdgeInsets margin = self.xc_sizeClass.margin;
    return CGSizeMake(self.frame.size.width + margin.left + margin.right, self.frame.size.height + margin.top + margin.bottom);
}
- (void)layout
{
    if (self.isAutoLayout == NO)
    {
        return;
    }
    //初始化所以frame
    [self zeroFrame:self];
    
    if (!self.isLayouting)
    {
        _isLayouting = YES;
        
        if (self.xc_beginLayoutBlock != nil)
            self.xc_beginLayoutBlock(self);
        
        [self.xc_sizeClass callBeginSEL];
        
        CGRect rect = [self.xc_sizeClass layoutRect];
        _bodyRect = rect;
        self.frame = rect;
        
        //刷新布局
        [self iterationSubviews:self];
        
        if ([self.superview isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scrollView = (UIScrollView *)self.superview;
            
            CGFloat bottom = self.xc_sizeClass.marginBottom.val;
            if (self.frame.origin.y + self.frame.size.height + bottom  > scrollView.contentSize.height)
                scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, (self.frame.origin.y + self.frame.size.height + bottom));
        }
        else
        {
            if (![self.superview.nextResponder isKindOfClass:[UIViewController class]] && ![self.superview.superview isKindOfClass:[UITableViewCell class]] && ![self.superview isKindOfClass:[UITableViewCell class]])
            {
                CGFloat bottom = self.xc_sizeClass.marginBottom.val;
                if (self.xc_height.type == XCLayoutSizeValueType_Fit || (self.frame.origin.y + self.frame.size.height + bottom) > self.superview.frame.size.height)
                {
                    _superRect = CGRectMake(self.superview.frame.origin.x, self.superview.frame.origin.y, self.superview.frame.size.width, (self.frame.origin.y + self.frame.size.height + bottom));
                    self.superview.frame = _superRect;
                }
            }
        }
        
        if (self.xc_endLayoutBlock != nil)
        {
            self.xc_endLayoutBlock(self);
        }
        [self.xc_sizeClass callEndSEL];
        
        _isLayouting = NO;
    }
}


- (void)iterationSubviews:(UIView *)superView
{
    UIView *topView;
    for (UIView *view in superView.subviews)
    {
        if (view.xc_sizeClass == nil)
            continue;
        
        if (view.xc_beginLayoutBlock != nil)
        {
            view.xc_beginLayoutBlock(view);
        }
        [view.xc_sizeClass callBeginSEL];       //开始回调
        
        XCLayoutSizeClass *sizeClass = view.xc_sizeClass;
        if (sizeClass.display == XCLayoutDisplay_Nono || view.hidden == YES)      //隐藏 直接跳过
            continue;
        
        sizeClass.topView = topView;                //赋值topview
        CGRect rect = [sizeClass layoutRect];
        view.frame = rect;
        
        if (view.xc_endLayoutBlock != nil)
        {
            view.xc_endLayoutBlock(view);
        }
        [view.xc_sizeClass callEndSEL]; //结束回调
        
        if (sizeClass.center == XCLayoutCenter_Nono && sizeClass.position != XCLayoutPosition_Absolute)
            topView = view;
        
        if (view.subviews.count > 0)
        {
            [self iterationSubviews:view];
        }
        
        if (![XCLayoutUtil isSizeFits:view])
        {
            if (sizeClass.width.type == XCLayoutSizeValueType_Fit || sizeClass.height.type == XCLayoutSizeValueType_Fit)
            {
                rect = [sizeClass layoutRect];
                view.frame = rect;
            }
        }
        
        if ([superView isKindOfClass:[UIScrollView class]] && sizeClass.position != XCLayoutPosition_Absolute)
        {
            UIScrollView *scrollView = (UIScrollView *)superView;
            
            if ((view.frame.origin.y + view.frame.size.height + sizeClass.marginBottom.val + superView.xc_sizeClass.paddingBottom.val) > scrollView.contentSize.height)
                scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, (view.frame.origin.y + view.frame.size.height + sizeClass.marginBottom.val + superView.xc_sizeClass.paddingBottom.val));
        }
        else
        {
            if (superView.xc_heightAuto == YES && sizeClass.position != XCLayoutPosition_Absolute)
            {
                if ((view.frame.origin.y + view.frame.size.height + sizeClass.marginBottom.val + superView.xc_sizeClass.paddingBottom.val) > superView.frame.size.height)
                {
                    superView.frame = CGRectMake(superView.frame.origin.x, superView.frame.origin.y, superView.frame.size.width, (view.frame.origin.y + view.frame.size.height + sizeClass.marginBottom.val + superView.xc_sizeClass.paddingBottom.val));
                    
                    superView.xc_sizeClass.rowBY = superView.frame.size.height + superView.frame.origin.y;
                }
            }
            
        }
        
    }
}



@end













