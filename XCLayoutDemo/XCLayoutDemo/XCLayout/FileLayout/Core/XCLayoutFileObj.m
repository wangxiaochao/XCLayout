//
//  XCLayoutFileObj.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutFileObj.h"

@implementation XCLayoutFileObj
- (id)init
{
    if (self = [super init])
    {

    }
    return self;
}
@end

@implementation XCLayoutFileNodeObj
- (id)init
{
    if (self = [super init])
    {
        self.style = [NSMutableDictionary dictionary];
        self.nodes = [NSMutableArray array];
    }
    return self;
}
@end


