//
//  XCLayoutXMLPropertySimpI.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/5.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutXMLPropertySimpI.h"

@implementation XCLayoutXMLPropertySimpI
+ (XCLayoutXMLPropertySimpI *)sharedSimp
{
    static XCLayoutXMLPropertySimpI *sharedXCLayoutXMLPropertySimpI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedXCLayoutXMLPropertySimpI = [[super alloc] init];
    });
    return sharedXCLayoutXMLPropertySimpI;
}


- (id)init
{
    if (self = [super init])
    {
        _simp = [NSMutableDictionary dictionary];
    }
    return self;
}

@end



