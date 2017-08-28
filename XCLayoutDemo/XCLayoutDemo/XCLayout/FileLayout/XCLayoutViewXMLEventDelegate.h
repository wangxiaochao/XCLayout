//
//  XCLayoutViewXMLEventDelegate.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

typedef enum{
    xc_isClick,                //单击
    xc_isDoubleClick,          //双击
    xc_isLongPress             //长按
}XCLayoutViewXMLEvents;

@protocol XCLayoutViewXMLEventDelegate <NSObject>
@optional
- (void)layoutViewXMLControlClick:(UIControl *)btn cid:(NSString *)cid forControlEvents:(UIControlEvents)forControlEvents owen:(id)owen;
- (void)layoutViewXMLEvents:(UIView *)view cid:(NSString *)cid forEvents:(XCLayoutViewXMLEvents)forEvents owen:(id)owen;
@end
