//
//  LoginViewController.m
//  Leisure
//
//  Created by zero on 16/4/8.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBackButton
{
    [super createBackButton];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(UIButton *)sender {
    
}

@end