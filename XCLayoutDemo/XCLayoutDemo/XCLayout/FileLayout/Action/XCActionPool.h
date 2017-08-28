//
//  XCActionPool.h
//  XLT
//
//  Created by 钧泰科技 on 15/6/9.
//  Copyright (c) 2015年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol XCFilterDelegate <NSObject>

@end

#define xcF_BoolFilter @"bool"
#define xcF_IntFilter @"int"
#define xcF_FloatFilter @"float"

#define xcA_SizeToFitAction @"sizeToFit"

@class XCActionPoolObj;
@interface XCActionPool : NSObject
+ (XCActionPool *)sharedXCActionPool;


- (void)addFilter:(NSString *)filter tag:(id)tag sel:(SEL)sel;
- (void)addAction:(NSString *)action tag:(id)tag sel:(SEL)sel;


- (id)sendAction:(NSString *)action tag:(id)tag;
- (id)sendFilter:(NSString *)filter params:(id)params;

- (XCActionPoolObj *)getActionObjForKey:(NSString *)key;
- (XCActionPoolObj *)getFilterObjForKey:(NSString *)key;
@end


@interface XCActionPoolObj : NSObject
@property (nonatomic,assign) SEL sel;
@property (nonatomic,assign) id tag;
@end