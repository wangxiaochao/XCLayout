//
//  XCLayoutPos.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/2.
//  Copyright © 2016年 wxc. All rights reserved.
//

//位置对象

#import <UIKit/UIKit.h>

//内部使用
typedef enum : unsigned char
{
    XCLayoutPosValType_Nil,               //是空 未赋值
    XCLayoutPosValType_Value
}XCLayoutPosValType;

@class XCLayoutSizeClass;
@interface XCLayoutPos : NSObject

- (XCLayoutPos* (^)(CGFloat val))equalTo;       //赋值
- (XCLayoutPos* (^)(CGFloat val))equalTo_not;
- (XCLayoutPos* (^)(XCLayoutPos *val))equalToPost;       //赋值
- (XCLayoutPos* (^)(XCLayoutPos *val))equalToPost_not;


//设置偏移量 在equal基础上偏移 进行+运算
- (XCLayoutPos* (^)(CGFloat val))offset;        //偏移
//设置偏移量 不响应变动
- (XCLayoutPos* (^)(CGFloat val))offset_not;

//通过如下属性获取上面的设置结果。
@property (nonatomic,assign, readonly) CGFloat val;
@property (nonatomic,assign) XCLayoutPosValType type;

//对面引用
@property (nonatomic,weak) UIView *view;
@property (nonatomic,weak) XCLayoutSizeClass *sizeClass;
@end
