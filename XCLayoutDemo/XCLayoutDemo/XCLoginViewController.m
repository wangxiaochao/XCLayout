//
//  XCLoginViewController.m
//  CY
//
//  Created by 钧泰科技 on 16/7/21.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCLoginViewController.h"
#import "XCRegisteredViewController.h"
//#import "XCRPwdViewController.h"
//#import "XCSetUserInfoViewController.h"

//#import "AppDelegate.h"
//#import "XCLoginBean.h"
@interface XCLoginViewController ()

@end

@implementation XCLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    
    [_scrollView xc_layoutFilePath:@"account/login.xml" owen:self dataSource:nil];
    [_scrollView xc_settingOutlet:self];
    [_scrollView setXc_eventDeleagte:self];
    
    self.phone.keyboardType = UIKeyboardTypePhonePad;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)layoutViewXMLControlClick:(UIControl *)btn cid:(NSString *)cid forControlEvents:(UIControlEvents)forControlEvents owen:(id)owen
{
    if ([cid isEqualToString:@"registered"])
    {        
        [self toRegistered];
        return;
    }
    if ([cid isEqualToString:@"rPwd"])
    {
//        [self toRPwd];
        return;
    }
    if ([cid isEqualToString:@"login"])
    {
//        [self login];
    }
}
- (void)toRegistered
{
    XCRegisteredViewController *reg = [[XCRegisteredViewController alloc] init];
    UINavigationController *regNav = [[UINavigationController alloc] initWithRootViewController:reg];
    [self presentViewController:regNav animated:YES completion:nil];
}




@end
