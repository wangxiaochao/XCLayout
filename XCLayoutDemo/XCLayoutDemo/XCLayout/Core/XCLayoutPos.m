//
//  XCLayoutPos.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/2.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutPos.h"
#import "XCLayoutBody.h"
#import "XCLayoutBodyInner.h"

#import "XCLayoutSizeClass.h"
#import "XCLayoutSizeClassInner.h"

@implementation XCLayoutPos
- (id)init
{
    if (self = [super init])
    {
        _type = XCLayoutPosValType_Nil;
    }
    return self;
}

- (XCLayoutPos* (^)(CGFloat val))equalTo       //赋值
{
    return ^id(CGFloat val){
        _val = val;
        _type = XCLayoutPosValType_Value;
        [self loadLayout];
        return self;
    };
}
- (XCLayoutPos* (^)(CGFloat val))equalTo_not       //赋值
{
    return ^id(CGFloat val){
        _val = val;
        _type = XCLayoutPosValType_Value;
        return self;
    };
}
- (XCLayoutPos* (^)(XCLayoutPos *val))equalToPost       //赋值
{
    return ^id(XCLayoutPos *val){
        _val = val.val;
        _type = XCLayoutPosValType_Value;
        [self loadLayout];
        return self;
    };
}
- (XCLayoutPos* (^)(XCLayoutPos *val))equalToPost_not
{
    return ^id(XCLayoutPos *val){
        _val = val.val;
        _type = XCLayoutPosValType_Value;
        return self;
    };
}


- (XCLayoutPos * (^)(CGFloat val))offset
{
    return ^id(CGFloat val){
        if (_type == XCLayoutPosValType_Nil)
        {
            return nil;
        }
        _val = _val + val;
        _type = XCLayoutPosValType_Value;
        [self loadLayout];
        return self;
    };
}
-(XCLayoutPos* (^)(CGFloat val))offset_not
{
    return ^id(CGFloat val){
        if (_type == XCLayoutPosValType_Nil)
        {
            return nil;
        }
        _val = _val + val;
        _type = XCLayoutPosValType_Value;
        return self;
    };
}


- (void)loadLayout
{
    [self.sizeClass.body setNeedsLayout];       //刷新body
//    if ([self.view isKindOfClass:[XCLayoutBody class]])
//    {
////        [((XCLayoutBody *)self.view) calsFrame:self.view.superview];
//    }
//    else
//    {
//        [self.sizeClass.body setNeedsLayout];       //刷新body
//    }
}
@end
