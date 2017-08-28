//
//  XCLayoutBody.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/2.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCLayoutBody : UIView
//当前是否正在布局中,如果正在布局中则返回YES,否则返回NO
@property(nonatomic,assign,readonly) BOOL isLayouting;

//计算所在view布局后大小调用此方法
- (CGSize)getSuperLayoutSize;

//布局
- (void)layout;
//停止自动响应布局
- (void)stopAuto;
//开始自动响应布局 并离开刷新一次布局
- (void)startAuto;
@end



