//
//  XCLayoutConfig.m
//  XCDevKit
//
//  Created by 钧泰科技 on 15/4/20.
//  Copyright (c) 2015年 wxc. All rights reserved.
//
#if !__has_feature(objc_arc)
#error must be built with ARC.
#endif

#import "XCLayoutFileConfig.h"
#import "XCLayoutUtil.h"
#import "XCResourceManage.h"

@implementation XCLayoutFileConfig
+ (XCLayoutFileConfig *)sharedXCLayoutFileConfig
{
    static XCLayoutFileConfig *sharedXCLayoutFileConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedXCLayoutFileConfig = [[super alloc] init];
    }); 
    return sharedXCLayoutFileConfig;
}
- (void)setPublicCssConfig:(NSString *)cssFile
{
    self.publicCss = [XCLayoutUtil getDictionaryByFileJson:[[XCResourceManage sharedXCResourceManage] getCssStylePath:cssFile]];
}
- (void)setFontConfig:(NSString *)fontFile
{
    self.fontDic = [XCLayoutUtil getDictionaryByFileJson:[[XCResourceManage sharedXCResourceManage] getCssStylePath:fontFile]];
}
- (void)setColorConfig:(NSString *)colorFile
{
    self.colorDic = [XCLayoutUtil getDictionaryByFileJson:[[XCResourceManage sharedXCResourceManage] getCssStylePath:colorFile]];
}
@end
