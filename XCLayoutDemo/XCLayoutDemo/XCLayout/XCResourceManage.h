//
//  VTAppResourceManage.h
//  VTX
//
//  Created by wxc on 14/11/10.
//  Copyright (c) 2014年 wxc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class XCResource;

@interface XCResourceManage : NSObject



+ (XCResourceManage *)sharedXCResourceManage;

//监控文件变化-- 暂时只监控 css和xml的变化
- (void)watch:(NSString *)path;
- (void)startWatch;

- (void)initResource;
- (XCResource *)settingResource:(NSString *)imagesPath xmlPath:(NSString *)xmlPath pageSettingPath:(NSString *)pageSettingPath cssStylePath:(NSString *)cssStylePath configPath:(NSString *)configPath;
//获取资源路径
- (NSString *)getImagesPath:(NSString *)file;
- (NSString *)getXmlPath:(NSString *)file;
- (NSString *)getPageSettingPath:(NSString *)file;
- (NSString *)getCssStylePath:(NSString *)file;
- (NSString *)getConfigPath:(NSString *)file;
//获取资源包路径
- (NSString *)getImagesPath;
- (NSString *)getXmlPath;
- (NSString *)getPageSettingPath;
- (NSString *)getCssStylePath;
- (NSString *)getConfigPath;
/////
- (UIImage *)getImage:(NSString *)image;
@end

@interface XCResource : NSObject<NSCoding>
@property (nonatomic,strong) NSString *imagesPath;         //图片资源
@property (nonatomic,strong) NSString *xmlPath;            //xml布局资源路径
@property (nonatomic,strong) NSString *pageSettingPath;    //组件/页面 装配资源
@property (nonatomic,strong) NSString *cssStylePath;       //样式资源路径
@property (nonatomic,strong) NSString *configPath;         //配置资源路径
@end