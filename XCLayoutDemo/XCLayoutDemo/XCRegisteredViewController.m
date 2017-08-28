//
//  XCRegisteredViewController.m
//  CY
//
//  Created by 钧泰科技 on 16/7/26.
//  Copyright © 2016年 wxc. All rights reserved.
//

#import "XCRegisteredViewController.h"

@interface XCRegisteredViewController ()

@end

@implementation XCRegisteredViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新用户";
    
    [_scrollView xc_layoutFilePath:@"account/registered.xml" owen:self dataSource:nil];
    [_scrollView xc_settingOutlet:self];
    [_scrollView setXc_eventDeleagte:self];
    
    self.phoneNumber.keyboardType = UIKeyboardTypePhonePad;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)layoutViewXMLControlClick:(UIControl *)btn cid:(NSString *)cid forControlEvents:(UIControlEvents)forControlEvents owen:(id)owen
{
    
}
- (void)checkPhoneNumber
{

}
- (void)sendCode
{

}
@end
