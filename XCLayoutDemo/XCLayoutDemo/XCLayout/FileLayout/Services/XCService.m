//
//  XCService.m
//  XCDevKit
//
//  Created by 钧泰科技 on 15/11/30.
//  Copyright © 2015年 wxc. All rights reserved.
//

#import "XCService.h"
#import "XCServiceLoader.h"


@implementation XCService

+ (instancetype)instance
{
    return [[XCServiceLoader sharedXCServiceLoader] service:[self class]];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.name = NSStringFromClass([self class]);
        self.bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[[self class] description] ofType:@"bundle"]];
    }
    return self;
}

- (void)dealloc
{
    if ( _running )
    {
        [self powerOff];
    }
    
    self.bundle = nil;
    self.name = nil;
}

- (void)install
{
}

- (void)uninstall
{
}

- (void)powerOn
{
}

- (void)powerOff
{
}
@end



