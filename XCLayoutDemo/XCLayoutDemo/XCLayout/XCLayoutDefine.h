//
//  XCLayoutDefine.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/1.
//  Copyright © 2016年 wxc. All rights reserved.
//

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[super alloc] init]; \
}); \
return shared##className; \
}


#define xc_LayoutFileDidChanged_Notic @"xc_LayoutFileDidChanged_Notic"          //布局文件发生变化通知


//元素布局类型
typedef enum : unsigned char
{
    XCLayoutDisplay_Block = 0,               //块  默认 前后有换行
    XCLayoutDisplay_Inline = 1,              //内链
    XCLayoutDisplay_Nono = 2                //隐藏不占用空间
}XCLayoutDisplay;


//元素定位类型
typedef enum : int
{
    XCLayoutPosition_Static = 0,               //正常流式定位 默认
    XCLayoutPosition_Absolute = 1,              //绝对定位 -- 从流布局中移除 不会作为下一个元素的top元素
    XCLayoutPosition_Relative= 2                //相对定位 元素额外偏移 top left bottom right
}XCLayoutPosition;


//元素 居中 相对 定位       居中将移除相对父元素文档流
typedef enum : int
{
    XCLayoutCenter_Nono = 0,              //没有
    XCLayoutCenter_Center = 1,
    XCLayoutCenter_CenterX = 2,
    XCLayoutCenter_CenterY = 3
}XCLayoutCenter;



