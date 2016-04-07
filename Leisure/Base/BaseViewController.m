//
//  BaseViewController.m
//  Drawer
//
//  Created by zero on 16/3/28.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBarButtonTitle];
    
    [super viewDidLoad];
    
    [self createBackButton];
    
    self.navigationController.navigationBar.layer.borderWidth = 1;
    self.navigationController.navigationBar.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)createBarButtonTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    label.text = _barButtonTitle;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:20];
    self.navigationItem.titleView = label;
}

- (void)createBackButton
{
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"返回"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"返回"]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *navigationspacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    navigationspacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[navigationspacer, leftItem];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end