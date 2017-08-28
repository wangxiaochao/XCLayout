//
//  XCLayoutView+Ext.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/2.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCLayoutView+Ext+Property.h"
@class XCLayoutBody;
@interface UIView(XCLayoutViewExt)

//纳入布局内的创建方式
+ (instancetype)xc_init;
- (XCLayoutSizeClass *)xc_getCurrentSizeClass;

- (XCLayoutBody *)xc_getLayoutBody;
@end
