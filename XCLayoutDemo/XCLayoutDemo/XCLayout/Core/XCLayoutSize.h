//
//  XCLayoutSize.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/2.
//  Copyright © 2016年 wxc. All rights reserved.
//

//布局的尺寸对象
#import <UIKit/UIKit.h>

//内部使用
typedef enum : unsigned char
{
    XCLayoutSizeValueType_Auto,              //填充 填充剩余位置
    XCLayoutSizeValueType_Fit,               //适应 根据子控件决定
    XCLayoutSizeValueType_Super,              //铺满 总是跟父控件一样大
    XCLayoutSizeValueType_Frame,              //使用frame
    XCLayoutSizeValueType_Value,             //值
    XCLayoutSizeValueType_Ratio              //比例
}XCLayoutSizeValueType;

@class XCLayoutSizeClass;
@interface XCLayoutSize : NSObject

- (XCLayoutSize * (^)())equalToAuto;       //填充
- (XCLayoutSize * (^)())equalToFit;        //适应
- (XCLayoutSize * (^)())equalToSuper;       //铺满
- (XCLayoutSize * (^)())equalToFrame;      //使用frame
- (XCLayoutSize * (^)(CGFloat val))equalTo;
- (XCLayoutSize * (^)(XCLayoutSize *val))equalToSize;            //等于某个size对象
- (XCLayoutSize * (^)(CGFloat val))equalToDevice;       //根据设备伸缩值 基准是 4寸屏幕
//0-1
- (XCLayoutSize * (^)(CGFloat val))ratio;


//非刷新
- (XCLayoutSize * (^)())equalToAuto_not;       //填充
- (XCLayoutSize * (^)())equalToFit_not;        //适应
- (XCLayoutSize * (^)())equalToSuper_not;       //铺满
- (XCLayoutSize * (^)())equalToFrame_not;      //使用frame
- (XCLayoutSize * (^)(CGFloat val))equalTo_not;
- (XCLayoutSize * (^)(XCLayoutSize *val))equalToSize_not;            //等于某个size对象
- (XCLayoutSize * (^)(CGFloat val))equalToDevice_not;
//0-1
- (XCLayoutSize * (^)(CGFloat val))ratio_not;


//设置偏移量 在equal基础上偏移 进行+运算
- (XCLayoutSize* (^)(CGFloat val))offset;               //偏移  值 比例可以使用偏移
//设置偏移量 不响应变动
- (XCLayoutSize* (^)(CGFloat val))offset_not;


@property (nonatomic,assign) XCLayoutSizeValueType type;
@property (nonatomic,assign) CGFloat sizeValue;

//对象引用
@property (nonatomic,weak) UIView *view;
@property (nonatomic,weak) XCLayoutSizeClass *sizeClass;
@end











