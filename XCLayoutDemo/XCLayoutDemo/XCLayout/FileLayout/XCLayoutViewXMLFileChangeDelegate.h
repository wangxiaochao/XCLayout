//
//  XCLayoutViewXMLFileChangeDelegate.h
//  XCLayout
//
//  Created by 钧泰科技 on 16/3/5.
//  Copyright © 2016年 wxc. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol XCLayoutViewXMLFileChangeDelegate <NSObject>
- (void)xc_willLayoutObjChange;
- (void)xc_didLayoutObjChange;
@end




