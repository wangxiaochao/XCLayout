//
//  XCServiceLoader.m
//  XCDevKit
//
//  Created by 钧泰科技 on 15/11/30.
//  Copyright © 2015年 wxc. All rights reserved.
//

#import "XCServiceLoader.h"
#import "XCService.h"
#import "XCDevKit_Object_Runtime.h"
#import "XCDockerManager.h"
#import "XCLayoutDefine.h"

@implementation XCServiceLoader
{
    NSMutableDictionary * _services;
}


DEFINE_SINGLETON_FOR_CLASS(XCServiceLoader)
- (id)init
{
    self = [super init];
    if ( self )
    {
        _services = [[NSMutableDictionary alloc] init];
        
        [self installServices];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(UIApplicationDidFinishLaunchingNotification)
                                                     name:UIApplicationDidFinishLaunchingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(UIApplicationWillTerminateNotification)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
    return self;
}
- (void)dealloc
{
    [_services removeAllObjects];
    _services = nil;
}

- (void)installServices
{
    for ( NSString * className in [XCService subClasses] )
    {
        Class classType = NSClassFromString( className );
        if ( nil == classType )
            continue;

        XCService * service = [self service:classType];
        if ( service )
        {
            [service install];
        }
    }
}

- (void)uninstallServices
{
    for (XCService * service in _services )
    {
        [service uninstall];
    }
    
    [_services removeAllObjects];
}

- (NSArray *)services
{
    return [_services allValues];
}

- (id)service:(Class)classType
{
    XCService * service = [_services objectForKey:[classType description]];
    
    if ( nil == service )
    {
        service = [[classType alloc] init];
        if ( service )
        {
            [_services setObject:service forKey:[classType description]];
        }
        
        if ([service conformsToProtocol:@protocol(ManagedService)] )
        {
            [service powerOn];
        }
    }
    
    return service;
}

- (void)UIApplicationDidFinishLaunchingNotification
{
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, 1.0 * 1 * NSEC_PER_SEC ), dispatch_get_main_queue(),  ^{
        [[XCDockerManager sharedXCDockerManager] installDockers];
    });

}

- (void)UIApplicationWillTerminateNotification
{
    [[XCDockerManager sharedXCDockerManager] uninstallDockers];
}
@end

