//
//  XCPrimitiveAction.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/9.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCPrimitiveAction.h"

@implementation XCPrimitiveAction

+ (void)sizeToFit:(id)tag
{
    [(UIView *)tag sizeToFit];
}

@end
