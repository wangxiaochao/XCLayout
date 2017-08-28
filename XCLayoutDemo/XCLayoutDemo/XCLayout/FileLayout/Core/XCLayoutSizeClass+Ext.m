//
//  XCLayoutSizeClass+Ext.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/5.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutSizeClass+Ext.h"
#import <objc/runtime.h>

const char * const XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_SIZECLASS_FILENODEOBJECT = "XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_SIZECLASS_FILENODEOBJECT";


@implementation XCLayoutSizeClass(XCLayoutSizeClassExt)
- (void)setFileNodeObj:(XCLayoutFileNodeObj *)fileNodeObj
{
    objc_setAssociatedObject(self, &XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_SIZECLASS_FILENODEOBJECT, fileNodeObj, OBJC_ASSOCIATION_ASSIGN);
}
- (XCLayoutFileNodeObj *)fileNodeObj
{
    return objc_getAssociatedObject(self, &XC_ASSOCIATEDOBJECT_KEY_XCLAYOUT_SIZECLASS_FILENODEOBJECT);
}
@end










