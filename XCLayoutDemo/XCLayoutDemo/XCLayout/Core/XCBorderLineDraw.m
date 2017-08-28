//
//  XCBorderLineDraw.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/5.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCBorderLineDraw.h"

@implementation XCBorderLineDraw
-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _color = [UIColor blackColor];
        _insetColor = nil;
        _thick = 1;
        _headIndent = 0;
        _tailIndent = 0;
        _dash  = 0;
    }
    
    return self;
}

-(id)initWithColor:(UIColor *)color
{
    self = [self init];
    if (self != nil)
    {
        _color = color;
    }
    
    return self;
}

@end


#import "XCLayoutSizeClass.h"
#import "XCLayoutSizeClassInner.h"

@implementation XCBorderLineLayerDelegate


- (id)initWithLayout:(XCLayoutSizeClass *)sizeClass
{
    self = [self init];
    if (self != nil)
    {
        _sizeClass = sizeClass;
    }
    
    return self;
}


-(void)layoutSublayersOfLayer:(CAShapeLayer *)layer
{
    if (self.sizeClass == nil)
        return;
    
    CGSize layoutSize = self.sizeClass.view.layer.bounds.size;
    
    CGRect layerRect;
    CGPoint fromPoint;
    CGPoint toPoint;
    
    if (layer == self.leftBorderLineLayer)
    {
        layerRect = CGRectMake(0, self.sizeClass.leftBorderLine.headIndent, self.sizeClass.leftBorderLine.thick, layoutSize.height - self.sizeClass.leftBorderLine.headIndent - self.sizeClass.leftBorderLine.tailIndent);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(0, layerRect.size.height);
        
    }
    else if (layer == self.rightBorderLineLayer)
    {
        layerRect = CGRectMake(layoutSize.width - self.sizeClass.rightBorderLine.thick / 2, self.sizeClass.rightBorderLine.headIndent, self.sizeClass.rightBorderLine.thick / 2, layoutSize.height - self.sizeClass.rightBorderLine.headIndent - self.sizeClass.rightBorderLine.tailIndent);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(0, layerRect.size.height);
        
    }
    else if (layer == self.topBorderLineLayer)
    {
        layerRect = CGRectMake(self.sizeClass.topBorderLine.headIndent, 0, layoutSize.width - self.sizeClass.topBorderLine.headIndent - self.sizeClass.topBorderLine.tailIndent, self.sizeClass.topBorderLine.thick/2);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(layerRect.size.width, 0);
    }
    else if (layer == self.bottomBorderLineLayer)
    {
        layerRect = CGRectMake(self.sizeClass.bottomBorderLine.headIndent, layoutSize.height - self.sizeClass.bottomBorderLine.thick / 2, layoutSize.width - self.sizeClass.bottomBorderLine.headIndent - self.sizeClass.bottomBorderLine.tailIndent, self.sizeClass.bottomBorderLine.thick /2);
        fromPoint = CGPointMake(0, 0);
        toPoint = CGPointMake(layerRect.size.width, 0);
    }
    else
    {
        NSAssert(0, @"oops!");
    }
    
    
    //把动画效果取消。
    if (!CGRectEqualToRect(layer.frame, layerRect))
    {
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        
        if (layer.lineDashPhase == 0)
        {
            layer.path = nil;
        }
        else
        {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, fromPoint.x, fromPoint.y);
            CGPathAddLineToPoint(path, nil, toPoint.x,toPoint.y);
            layer.path = path;
            CGPathRelease(path);
            
        }
        
        
        layer.frame = layerRect;
        
        [CATransaction commit];
    }
    
}

@end




