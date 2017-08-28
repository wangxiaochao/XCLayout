//
//  XCLayoutSize.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/2.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutSize.h"
#import "XCLayoutBody.h"
#import "XCLayoutBodyInner.h"

#import "XCLayoutSizeClass.h"
#import "XCLayoutSizeClassInner.h"

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

@implementation XCLayoutSize
- (id)init
{
    if (self = [super init])
    {
        _type = XCLayoutSizeValueType_Auto;
        _sizeValue = 0;
    }
    return self;
}

- (XCLayoutSize * (^)())equalToAuto
{
    return ^id(){
        _type = XCLayoutSizeValueType_Auto;
        _sizeValue = 0;
        [self loadLayout];
        return self;
    };
}
- (XCLayoutSize * (^)())equalToFit
{
    return ^id(){
        _type = XCLayoutSizeValueType_Fit;
        _sizeValue = 0;
        [self loadLayout];
        return self;
    };
}
- (XCLayoutSize * (^)())equalToSuper
{
    return ^id(){
        _type = XCLayoutSizeValueType_Super;
        _sizeValue = 0;
        [self loadLayout];
        return self;
    };
}
- (XCLayoutSize * (^)())equalToFrame       //使用frame
{
    return ^id(){
        _type = XCLayoutSizeValueType_Frame;
        _sizeValue = 0;
        [self loadLayout];
        return self;
    };
}

- (XCLayoutSize * (^)(CGFloat val))equalTo
{
    return ^id(CGFloat val){
        _type = XCLayoutSizeValueType_Value;
        _sizeValue = val;
        [self loadLayout];
        return self;
    };
}
- (XCLayoutSize * (^)(XCLayoutSize *val))equalToSize            //等于某个size对象
{
    return ^id(XCLayoutSize *val){
        _type = val.type;
        _sizeValue = val.sizeValue;
        
        [self loadLayout];
        return self;
    };
}
- (XCLayoutSize * (^)(CGFloat val))equalToDevice
{
    return ^id(CGFloat val){
        _type = XCLayoutSizeValueType_Value;
        _sizeValue = val;
        
        if (iPhone6)
            _sizeValue = _sizeValue*(375.0/320.0);
        else if (iPhone6p)
            _sizeValue = _sizeValue*(414.0/320.0);
        
        [self loadLayout];
        return self;
    };
}

//0-1
- (XCLayoutSize * (^)(CGFloat val))ratio
{
    return ^id(CGFloat val){
        _type = XCLayoutSizeValueType_Ratio;
        if (val <= 0)
            val = 0;
        if (val >= 1)
            val = 1;
        
        _sizeValue = val;
        [self loadLayout];
        return self;
    };
}


- (XCLayoutSize * (^)())equalToAuto_not
{
    return ^id(){
        _type = XCLayoutSizeValueType_Auto;
        _sizeValue = 0;
        return self;
    };
}
- (XCLayoutSize * (^)())equalToFit_not
{
    return ^id(){
        _type = XCLayoutSizeValueType_Fit;
        _sizeValue = 0;
        return self;
    };
}
- (XCLayoutSize * (^)())equalToSuper_not
{
    return ^id(){
        _type = XCLayoutSizeValueType_Super;
        _sizeValue = 0;
        return self;
    };
}
- (XCLayoutSize * (^)())equalToFrame_not      //使用frame
{
    return ^id(){
        _type = XCLayoutSizeValueType_Frame;
        _sizeValue = 0;
        return self;
    };
}
- (XCLayoutSize * (^)(CGFloat val))equalTo_not
{
    return ^id(CGFloat val){
        _type = XCLayoutSizeValueType_Value;
        _sizeValue = val;
        return self;
    };
}
- (XCLayoutSize * (^)(XCLayoutSize *val))equalToSize_not            //等于某个size对象
{
    return ^id(XCLayoutSize *val){
        _type = val.type;
        _sizeValue = val.sizeValue;
        return self;
    };
}
- (XCLayoutSize * (^)(CGFloat val))equalToDevice_not
{
    return ^id(CGFloat val){
        _type = XCLayoutSizeValueType_Value;
        _sizeValue = val;
        
        if (iPhone6)
            _sizeValue = _sizeValue*(375.0/320.0);
        else if (iPhone6p)
            _sizeValue = _sizeValue*(414.0/320.0);
        return self;
    };
}


//0-1
- (XCLayoutSize * (^)(CGFloat val))ratio_not
{
    return ^id(CGFloat val){
        _type = XCLayoutSizeValueType_Ratio;
        if (val <= 0)
            val = 0;
        if (val >= 1)
            val = 1;
        
        _sizeValue = val;
        return self;
    };
}


//设置偏移量 在equal基础上偏移 进行+运算
- (XCLayoutSize* (^)(CGFloat val))offset               //偏移  值 比例可以使用偏移
{
    return ^id(CGFloat val){
        if (_type == XCLayoutSizeValueType_Value)
        {
            _sizeValue = _sizeValue + val;
            [self loadLayout];
        }
        else if (_type == XCLayoutSizeValueType_Ratio)
        {
            _sizeValue = _sizeValue + val;
            
            if (_sizeValue <= 0)
                _sizeValue = 0;
            if (_sizeValue >= 1)
                _sizeValue = 1;
            
            [self loadLayout];
        }
        return self;
    };
}
//设置偏移量 不响应变动
- (XCLayoutSize* (^)(CGFloat val))offset_not
{
    return ^id(CGFloat val){
        if (_type == XCLayoutSizeValueType_Value)
        {
            _sizeValue = _sizeValue + val;
        }
        else if (_type == XCLayoutSizeValueType_Ratio)
        {
            _sizeValue = _sizeValue + val;
            
            if (_sizeValue <= 0)
                _sizeValue = 0;
            if (_sizeValue >= 1)
                _sizeValue = 1;
        }
        return self;
    };
}



- (void)loadLayout
{
    [self.sizeClass.body setNeedsLayout];       //刷新body
//    if ([self.view isKindOfClass:[XCLayoutBody class]])
//    {
//        [((XCLayoutBody *)self.view) calsFrame:self.view.superview];
//    }
//    else
//    {
//        [self.sizeClass.body setNeedsLayout];       //刷新body
//    }
}
@end
