//
//  VTAppResourceManage.m
//  VTX
//
//  Created by wxc on 14/11/10.
//  Copyright (c) 2014年 wxc. All rights reserved.
//

#if !__has_feature(objc_arc)
#error must be built with ARC.
#endif

#import "XCResourceManage.h"
#import "XCLayoutDefine.h"

#define XC_RESOURCE_CONFIG_CACHE   @"__XC_RESOURCE_CONFIG_CACHE__"

@interface XCResourceManage ()
{
    NSString *_watchPath;
    
    NSMutableArray *_files;
}
@property (nonatomic,strong) NSString *mainBundle;         //主目录
@property (nonatomic,readonly) XCResource *appResource;
@property (nonatomic,readonly) BOOL isWatch;
@end

@implementation XCResourceManage
- (void)dealloc
{
}

DEFINE_SINGLETON_FOR_CLASS(XCResourceManage);

- (void)watch:(NSString *)path
{
    _watchPath = [[NSString stringWithFormat:@"%@/../",path] stringByStandardizingPath];
    _isWatch = YES;
}
- (void)startWatch
{
    if (_isWatch == YES)
    {
        [self scanSourceFiles];
    }
}

- (void)scanSourceFiles
{
    NSString *xmlPath = [self getXmlPath];
    NSString *cssPath = [self getCssStylePath];
    
    if (_files == nil)
    {
        _files = [[NSMutableArray alloc] init];
    }
    [_files removeAllObjects];
    
    [self loadFile:xmlPath ext:@[@"xml",@"plist"]];
    [self loadFile:cssPath ext:@[@"css"]];
    
    for (NSString * file in _files)
    {
        [self watchSourceFile:file];
    }
}
- (void)loadFile:(NSString *)path ext:(NSArray *)ext
{
    NSDirectoryEnumerator *	enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    if (enumerator)
    {
        for ( ;; )
        {
            NSString * filePath = [enumerator nextObject];
            if ( nil == filePath )
                break;
            
            NSString * fileName = [filePath lastPathComponent];
            NSString * fileExt = [fileName pathExtension];
            NSString * fullPath = [path stringByAppendingPathComponent:filePath];
            
            BOOL isDirectory = NO;
            BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory];
            if ( exists && NO == isDirectory )
            {
                BOOL isValid = NO;
                
                for (NSString *extension in ext)
                {
                    if (NSOrderedSame == [fileExt compare:extension])
                    {
                        isValid = YES;
                        break;
                    }
                }
                
                if (isValid)
                {
                    [_files addObject:fullPath];
                }
            }
        }
    }
}

- (void)watchSourceFile:(NSString *)filePath
{
    int fileHandle = open( [filePath UTF8String], O_EVTONLY );
    if ( fileHandle )
    {
        unsigned long				mask = DISPATCH_VNODE_DELETE | DISPATCH_VNODE_WRITE | DISPATCH_VNODE_EXTEND;
        __block dispatch_queue_t	queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );
        __block dispatch_source_t	source = dispatch_source_create( DISPATCH_SOURCE_TYPE_VNODE, fileHandle, mask, queue );
        
        __weak typeof(self) this = self;
        __block id eventHandler = ^
        {
            unsigned long flags = dispatch_source_get_data( source );
            if ( flags )
            {
                dispatch_source_cancel( source );
                dispatch_async( dispatch_get_main_queue(), ^
                               {
                                   BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NULL];
                                   if ( exists )
                                   {
                                       [[NSNotificationCenter defaultCenter] postNotificationName:xc_LayoutFileDidChanged_Notic object:filePath];
                                   }
                                   else
                                   {
                                       NSLog(@"-- 变化  %@",filePath);
                                   }
                               });
                
                [this watchSourceFile:filePath];
            }
        };
        
        __block id cancelHandler = ^
        {
            close( fileHandle );
        };
        
        dispatch_source_set_event_handler( source, eventHandler );
        dispatch_source_set_cancel_handler( source, cancelHandler );
        dispatch_resume(source);
    }
}

- (id)init
{
    if (self = [super init])
    {
        self.mainBundle = [[NSBundle mainBundle] bundlePath];
    }
    return self;
}

- (void)initResource
{
    _appResource = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:XC_RESOURCE_CONFIG_CACHE]];
    if (_appResource == nil)
    {
        _appResource = [[XCResource alloc] init];
        _appResource.pageSettingPath = @"/Pages.bundle";
        _appResource.cssStylePath = @"/CSS.bundle";
        _appResource.imagesPath = @"/Images.bundle";
        _appResource.configPath = @"/Config.bundle";
        _appResource.xmlPath = @"/XML.bundle";
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_appResource] forKey:XC_RESOURCE_CONFIG_CACHE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (XCResource *)settingResource:(NSString *)imagesPath xmlPath:(NSString *)xmlPath pageSettingPath:(NSString *)pageSettingPath cssStylePath:(NSString *)cssStylePath configPath:(NSString *)configPath
{
    if (imagesPath)
        _appResource.imagesPath = imagesPath;

    if (xmlPath)
        _appResource.xmlPath = xmlPath;
    
    if (pageSettingPath)
        _appResource.pageSettingPath = pageSettingPath;
    
    if (cssStylePath)
        _appResource.cssStylePath = cssStylePath;
    
    if (configPath)
        _appResource.configPath = configPath;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_appResource] forKey:XC_RESOURCE_CONFIG_CACHE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return _appResource;
}

- (NSString *)getImagesPath:(NSString *)file
{
    return [self.mainBundle stringByAppendingFormat:@"%@/%@",_appResource.imagesPath,file];
}
- (NSString *)getXmlPath:(NSString *)file
{
    if (_isWatch == YES)
    {
        return [_watchPath stringByAppendingFormat:@"%@/%@",_appResource.xmlPath,file];
    }
    return [self.mainBundle stringByAppendingFormat:@"%@/%@",_appResource.xmlPath,file];
}
- (NSString *)getPageSettingPath:(NSString *)file
{
    return [self.mainBundle stringByAppendingFormat:@"%@/%@",_appResource.pageSettingPath,file];
}
- (NSString *)getCssStylePath:(NSString *)file
{
    if (_isWatch == YES)
    {
        return [_watchPath stringByAppendingFormat:@"%@/%@",_appResource.cssStylePath,file];
    }
    return [self.mainBundle stringByAppendingFormat:@"%@/%@",_appResource.cssStylePath,file];
}
- (NSString *)getConfigPath:(NSString *)file
{
    return [self.mainBundle stringByAppendingFormat:@"%@/%@",_appResource.configPath,file];
}

//获取资源包路径
- (NSString *)getImagesPath
{
    return [self.mainBundle stringByAppendingFormat:@"%@",_appResource.imagesPath];
}
- (NSString *)getXmlPath
{
    if (_isWatch == YES)
    {
        return [_watchPath stringByAppendingFormat:@"%@",_appResource.xmlPath];
    }
    return [self.mainBundle stringByAppendingFormat:@"%@",_appResource.xmlPath];
}
- (NSString *)getPageSettingPath
{
    return [self.mainBundle stringByAppendingFormat:@"%@",_appResource.pageSettingPath];
}
- (NSString *)getCssStylePath
{
    if (_isWatch == YES)
    {
        return [_watchPath stringByAppendingFormat:@"%@",_appResource.cssStylePath];
    }
    return [self.mainBundle stringByAppendingFormat:@"%@",_appResource.cssStylePath];
}
- (NSString *)getConfigPath
{
    return [self.mainBundle stringByAppendingFormat:@"%@",_appResource.configPath];
}

- (UIImage *)getImage:(NSString *)image
{
    UIImage *i = [UIImage imageWithContentsOfFile:[self getImagesPath:image]];
    return i;
}
@end



@implementation XCResource
- (void)dealloc
{
}


//将对象编码(即:序列化)
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_imagesPath==nil?@"":_imagesPath forKey:@"imagesPath"];
    [aCoder encodeObject:_xmlPath==nil?@"":_xmlPath forKey:@"xmlPath"];
    [aCoder encodeObject:_pageSettingPath==nil?@"":_pageSettingPath forKey:@"pageSettingPath"];
    [aCoder encodeObject:_cssStylePath==nil?@"":_cssStylePath forKey:@"cssStylePath"];
    [aCoder encodeObject:_configPath==nil?@"":_configPath forKey:@"configPath"];
}

//将对象解码(反序列化)
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.imagesPath =[aDecoder decodeObjectForKey:@"imagesPath"];
        self.xmlPath = [aDecoder decodeObjectForKey:@"xmlPath"];
        self.pageSettingPath =[aDecoder decodeObjectForKey:@"pageSettingPath"];
        self.cssStylePath =[aDecoder decodeObjectForKey:@"cssStylePath"];
        self.configPath = [aDecoder decodeObjectForKey:@"configPath"];
    }
    return (self);
    
}
@end


