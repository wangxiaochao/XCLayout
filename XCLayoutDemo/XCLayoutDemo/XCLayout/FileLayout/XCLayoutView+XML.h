//
//  XCLayoutView+XML.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCLayoutFileObj.h"
#import "XCLayoutBody.h"

#import "XCLayoutViewXMLFileChangeDelegate.h"
#import "XCLayoutViewXMLEventDelegate.h"

@interface UIView(XCLayoutViewXML) <XCLayoutViewXMLFileChangeDelegate>
//解析一个布局文件
+ (XCLayoutFileObj *)xc_createLayoutObj:(NSString *)layoutFilePath;
- (void)xc_layoutFilePath:(NSString *)layoutFilePath owen:(id)owen dataSource:(id)dataSource;  //owen 是设置this赋值的对象
- (void)xc_layoutFileObj:(XCLayoutFileObj *)fileObj owen:(id)owen dataSource:(id)dataSource;

//设置数据源 会立刻出发赋值
- (void)xc_setDataSource:(id)dataSource;

@property (nonatomic,weak) id<XCLayoutViewXMLEventDelegate> xc_eventDeleagte;
- (void)xc_settingOutlet:(id)tagger;
- (UIView *)xc_getElementById:(NSString *)ID;    //根据ID获取

//数据操作
- (void)xc_dataFill:(id)data;

//为某个view添加样式
- (void)xc_addStyleClass:(NSDictionary *)style;

//获取可用样式
//根据ID获取
- (NSMutableDictionary *)xc_getStyleById:(NSString *)cid;
//根据自身类获取
- (NSMutableDictionary *)xc_getStyleBySelf;
//根据类样式获取
- (NSMutableDictionary *)xc_getStyleByClass:(NSString *)clsName;
//根据key获取
- (NSMutableDictionary *)xc_getStyleByKey:(NSString *)key;
@end
