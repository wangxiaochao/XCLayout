//
//  XCDevKit_Object_Runtime.h
//  XCDevKit
//
//  Created by 钧泰科技 on 15/11/30.
//  Copyright © 2015年 wxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(XCDevKit_Object_Runtime)
+ (NSArray *)subClasses;

+ (NSArray *)methods;
+ (NSArray *)methodsUntilClass:(Class)baseClass;
+ (NSArray *)methodsWithPrefix:(NSString *)prefix;
+ (NSArray *)methodsWithPrefix:(NSString *)prefix untilClass:(Class)baseClass;

+ (NSArray *)properties;
+ (NSArray *)propertiesUntilClass:(Class)baseClass;
+ (NSArray *)propertiesWithPrefix:(NSString *)prefix;
+ (NSArray *)propertiesWithPrefix:(NSString *)prefix untilClass:(Class)baseClass;

+ (NSArray *)classesWithProtocolName:(NSString *)protocolName;

+ (void *)replaceSelector:(SEL)sel1 withSelector:(SEL)sel2;

@end
