//
//  XCLayoutView+Ext.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/2.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutView+Ext.h"
#import "XCLayoutView+Ext+Inner.h"
#import <objc/runtime.h>

#import "XCLayoutSizeClassInner.h"
#import "XCLayoutBody.h"

const char * const XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_SIZECLASS = "XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_SIZECLASS";

@implementation UIView(XCLayoutViewExtInner)
#pragma mark --- sizeClass get set
- (XCLayoutSizeClass *)xc_sizeClass
{
    return objc_getAssociatedObject(self, &XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_SIZECLASS);
}
- (void)setXc_sizcClass:(XCLayoutSizeClass *)xc_sizeClass
{
    objc_setAssociatedObject(self, &XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_SIZECLASS, xc_sizeClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma end
@end


@implementation UIView(XCLayoutViewExt)
+ (void)load
{
    Method didAddSubview =  class_getInstanceMethod([self class], @selector(didAddSubview:));
    Method xc_didAddSubview = class_getInstanceMethod([self class], @selector(xc_didAddSubview:));
    method_exchangeImplementations(didAddSubview, xc_didAddSubview);
    
    Method layoutSubviews =  class_getInstanceMethod([self class], @selector(layoutSubviews));
    Method xc_layoutSubviews = class_getInstanceMethod([self class], @selector(xc_layoutSubviews));
    method_exchangeImplementations(layoutSubviews, xc_layoutSubviews);

    Method willRemoveSubview =  class_getInstanceMethod([self class], @selector(willRemoveSubview:));
    Method xc_willRemoveSubview = class_getInstanceMethod([self class], @selector(xc_willRemoveSubview:));
    method_exchangeImplementations(willRemoveSubview, xc_willRemoveSubview);
    
    Method pointInside =  class_getInstanceMethod([self class], @selector(pointInside:withEvent:));
    Method xc_pointInside = class_getInstanceMethod([self class], @selector(xc_pointInside:withEvent:));
    method_exchangeImplementations(pointInside, xc_pointInside);
}

#pragma mark -- 绘制边线


#pragma mark
- (BOOL)xc_pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self xc_pointInside:point withEvent:event];
}

- (void)xc_layoutSubviews
{
    [self xc_layoutSubviews];
    
    if (self.xc_sizeClass.layerDelegate.topBorderLineLayer != nil)
        [self.xc_sizeClass.layerDelegate.topBorderLineLayer setNeedsLayout];
    
    if (self.xc_sizeClass.layerDelegate.bottomBorderLineLayer != nil)
        [self.xc_sizeClass.layerDelegate.bottomBorderLineLayer setNeedsLayout];
    
    
    if (self.xc_sizeClass.layerDelegate.leftBorderLineLayer != nil)
        [self.xc_sizeClass.layerDelegate.leftBorderLineLayer setNeedsLayout];
    
    if (self.xc_sizeClass.layerDelegate.rightBorderLineLayer != nil)
        [self.xc_sizeClass.layerDelegate.rightBorderLineLayer setNeedsLayout];
    
}
- (void)xc_didAddSubview:(UIView *)view
{
    [self xc_didAddSubview:view];
    
    if (view.xc_sizeClass == nil)
        return;
    
    view.xc_sizeClass.superView = self;
    if ([self isKindOfClass:[XCLayoutBody class]])
        view.xc_sizeClass.body = (XCLayoutBody *)self;
    else
    {
        view.xc_sizeClass.body = self.xc_sizeClass.body;
        [view.xc_sizeClass.body setNeedsLayout];
    }
}
- (void)xc_willRemoveSubview:(UIView *)subview
{
    [self xc_willRemoveSubview:subview];
    if (subview.xc_sizeClass == nil || [subview isKindOfClass:[XCLayoutBody class]])
        return;
    
    [subview.xc_sizeClass.body setNeedsLayout];
}
#pragma mark --- 提供的方法
+ (instancetype)xc_init
{
    UIView *view = [[self alloc] init];
    XCLayoutSizeClass *sizeClass = [XCLayoutSizeClass new];
    sizeClass.view = view;
    [view setXc_sizcClass:sizeClass];
    return view;
}
- (XCLayoutSizeClass *)xc_getCurrentSizeClass
{
    return self.xc_sizeClass;
}
#pragma end

- (XCLayoutBody *)xc_getLayoutBody
{
    return (XCLayoutBody *)self.xc_sizeClass.body;
}

@end



















