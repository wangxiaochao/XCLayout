//
//  XCService.h
//  XCDevKit
//
//  Created by 钧泰科技 on 15/11/30.
//  Copyright © 2015年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ManagedService <NSObject>
@end

@interface XCService : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSBundle *bundle;
@property (nonatomic,assign) BOOL running;


+ (instancetype)instance;

- (void)install;
- (void)uninstall;



- (void)powerOn;
- (void)powerOff;
@end
