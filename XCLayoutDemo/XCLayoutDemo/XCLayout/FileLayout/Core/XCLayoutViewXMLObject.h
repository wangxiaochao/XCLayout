//
//  XCLayoutViewXMLObject.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCLayoutFileObj.h"
#import "XCLayoutViewXMLEventDelegate.h"

#import "XCLayoutViewXMLFileChangeDelegate.h"

@protocol XCLayoutViewXMLObjectEventDelegate <NSObject>
@required
- (void)controlClick:(UIControl *)event;
- (void)viewEvents:(UIGestureRecognizer *)gap;
@end

@interface XCLayoutViewXMLObject : NSObject<XCLayoutViewXMLObjectEventDelegate>
@property (nonatomic,weak) UIView<XCLayoutViewXMLFileChangeDelegate> *view;  //与view本身的引用
@property (nonatomic,weak) id dataSource;       //数据源
@property (nonatomic,strong) NSString *layoutFilePath;
@property (nonatomic,strong) XCLayoutFileObj *fileObj;
@property (nonatomic,weak) id owen;                     // //owen 是设置this赋值的对象 引用
@property (nonatomic,weak) id body;         //body布局sizeClass对象的引用

@property (nonatomic,strong) NSMutableDictionary *cids;      //cid集合    
@property (nonatomic,weak) id<XCLayoutViewXMLEventDelegate> eventDelegate;       //事件代理
@property (nonatomic,strong) void (^controlClick) (UIControl *btn,NSString *cid,UIControlEvents forControlEvents,id owen);
@property (nonatomic,strong) void (^events) (UIView *view,NSString *cid,XCLayoutViewXMLEvents forEvents,id owen);
@end
