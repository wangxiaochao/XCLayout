//
//  XCLayoutConfig.h
//  XCDevKit
//
//  Created by 钧泰科技 on 15/4/20.
//  Copyright (c) 2015年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XCLayoutFileConfig : NSObject
@property (nonatomic,strong) NSMutableDictionary *publicCss;
@property (nonatomic,strong) NSMutableDictionary *fontDic;
@property (nonatomic,strong) NSMutableDictionary *colorDic;

+ (XCLayoutFileConfig *)sharedXCLayoutFileConfig;

- (void)setPublicCssConfig:(NSString *)cssFile;
- (void)setFontConfig:(NSString *)fontFile;
- (void)setColorConfig:(NSString *)colorFile;
@end
