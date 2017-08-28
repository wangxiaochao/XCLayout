//
//  XCServiceLoader.h
//  XCDevKit
//
//  Created by 钧泰科技 on 15/11/30.
//  Copyright © 2015年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface XCServiceLoader : NSObject

+ (XCServiceLoader *)sharedXCServiceLoader;

- (id)service:(Class)classType;

- (NSArray *)services;

- (void)installServices;
- (void)uninstallServices;
@end
