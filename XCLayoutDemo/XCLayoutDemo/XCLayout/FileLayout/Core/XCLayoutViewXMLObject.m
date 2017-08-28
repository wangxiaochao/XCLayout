//
//  XCLayoutViewXMLObject.m
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/4.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLayoutViewXMLObject.h"
#import "XCLayoutView+Ext.h"
#import "XCLayoutView+XML.h"

@implementation XCLayoutViewXMLObject
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)init
{
    if (self = [super init])
    {
        self.cids = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileChange:) name:xc_LayoutFileDidChanged_Notic object:nil];
    }
    return self;
}

- (void)fileChange:(NSNotification *)notic
{
    NSString *path = [notic object];
    
    NSString *fileName = [path lastPathComponent];
    NSString *fileExt = [path pathExtension];
    NSString *layoutPathName = [self.layoutFilePath lastPathComponent];
    
    if (![fileName rangeOfString:@"_f."].location == NSNotFound && ![fileName isEqualToString:layoutPathName] && ![fileExt isEqualToString:@"css"])
    {
        return;
    }
    
    //即将变化
    if ([self.view respondsToSelector:@selector(xc_willLayoutObjChange)])
    {
        [self.view xc_willLayoutObjChange];
    }
    
    self.fileObj = [UIView xc_createLayoutObj:self.layoutFilePath];
    
    if ([self.view respondsToSelector:@selector(xc_didLayoutObjChange)])
    {
        [self.view xc_didLayoutObjChange];
    }
    
}


- (void)controlClick:(UIControl *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:NO];
    if ([self.eventDelegate respondsToSelector:@selector(layoutViewXMLControlClick:cid:forControlEvents:owen:)])
    {
        [self.eventDelegate layoutViewXMLControlClick:event cid:[event xc_getCurrentSizeClass].cid forControlEvents:UIControlEventTouchUpInside owen:self.owen];
        return;
    }
    if (self.controlClick)
    {
        self.controlClick(event,[event xc_getCurrentSizeClass].cid,UIControlEventTouchUpInside,self.owen);
        return;
    }
}
- (void)viewEvents:(UIGestureRecognizer *)gap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:NO];
    XCLayoutViewXMLEvents type = xc_isClick;
    
    if ([gap isMemberOfClass:[UITapGestureRecognizer class]])
    {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gap;
        
        if (tap.numberOfTapsRequired == 1)
        {
            type = xc_isClick;
        }
        if (tap.numberOfTapsRequired == 2)
        {
            type = xc_isDoubleClick;
        }
    }
    if ([gap isMemberOfClass:[UILongPressGestureRecognizer class]])
    {
        type = xc_isLongPress;
    }
    
    if ([self.eventDelegate respondsToSelector:@selector(layoutViewXMLEvents:cid:forEvents:owen:)])
    {
        [self.eventDelegate layoutViewXMLEvents:gap.view cid:[gap.view xc_getCurrentSizeClass].cid forEvents:type owen:self.owen];
        return;
    }
    
    if (self.events)
    {
        self.events(gap.view,[gap.view xc_getCurrentSizeClass].cid,type,self.owen);
    }
}
@end






