//
//  XCSuperScrollViewController.m
//  XCDevKit
//
//  Created by 钧泰科技 on 15/5/4.
//  Copyright (c) 2015年 wxc. All rights reserved.
//
#if !__has_feature(objc_arc)
#error must be built with ARC.
#endif

#import "XCSuperScrollViewController.h"


@interface XCSuperScrollViewController ()
{
    UIView *_stAutokeyView;
    
    UIEdgeInsets _contentInsets;
}
@property (nonatomic,assign) BOOL isShowPage;
@end

@implementation XCSuperScrollViewController

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.numberOfTapsRequired=1;
    [_scrollView addGestureRecognizer:tap];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isShowPage = YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _contentInsets = _scrollView.contentInset;
    self.isShowPage = NO;
}

- (UIView *)getFirstResponderView:(UIView *)view
{
    for (UIView *inView in [view subviews])
    {
        if ([inView isKindOfClass:[UITextField class]] || [inView isKindOfClass:[UITextView class]])
        {
            if ([inView isFirstResponder])
            {
                return inView;
            }
        }
        else
        {
            if (inView.subviews.count > 0)
            {
                UIView *v = [self getFirstResponderView:inView];
                if (v != nil) return v;
            }
        }
    }
    
    return nil;
}

- (void)autoFrameWidthkeyboardWillShowDuration:(double)duration curve:(NSInteger)curve height:(CGFloat)height
{
    if (self.isShowPage == NO)
    {
        return;
    }
    //私有方法取第一响应对象
    //    UIView *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    //    _stAutokeyView = firstResponder;
    //for循环取第一响应对象
    UIView *cuView = [self getFirstResponderView:_scrollView];
    if (cuView != nil  && _stAutokeyView != nil && cuView != _stAutokeyView)
    {
        _stAutokeyView = cuView;
        return;
    }
    _stAutokeyView = cuView;
    if (_stAutokeyView == nil) return;
    
    NSLog(@"----  %f",_scrollView.contentSize.height);
    CGRect wrect = [_stAutokeyView convertRect:_stAutokeyView.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGPoint point = _scrollView.contentOffset;
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(_scrollView.contentInset.top, _scrollView.contentInset.left, height, _scrollView.contentInset.right);
        _scrollView.contentInset = contentInsets;
//        _scrollView.scrollIndicatorInsets = contentInsets;
        
        CGFloat maxSY = (_scrollView.contentInset.top + _scrollView.contentInset.bottom + _scrollView.contentSize.height) - _scrollView.frame.size.height;      //最大滚蛋y位置
        CGFloat sy = height - ([UIApplication sharedApplication].keyWindow.frame.size.height - (wrect.size.height+wrect.origin.y)) + 20;                //需要额外滚动距离 y
        
        if (sy > 0)
        {
            _scrollView.contentOffset = CGPointMake(point.x, point.y+sy>maxSY?maxSY:point.y+sy);
        }
    }];
}

- (void)autoFrameWidthkeyboardWillHideDuration:(double)duration curve:(NSInteger)curve height:(CGFloat)height
{
    if (self.isShowPage == NO)
    {
        return;
    }
    if (_stAutokeyView == nil)
    {
        return;
    }
    _stAutokeyView = nil;
    [UIView animateWithDuration:duration animations:^{
        _scrollView.contentInset = _contentInsets;
//        _scrollView.scrollIndicatorInsets = _contentInsets;
    }];
}

- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:NO];
}
@end
