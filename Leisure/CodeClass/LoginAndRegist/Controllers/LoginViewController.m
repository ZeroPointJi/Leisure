//
//  LoginViewController.m
//  Leisure
//
//  Created by zero on 16/4/8.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.registFirstResponseArray addObject:_emailTextField];
    [self.registFirstResponseArray addObject:_passwordTextField];
}

- (void)createBackButton
{
    [super createBackButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(regist)];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(UIButton *)sender {
    [NetWorkrequestManage requestWithType:POST url:LOGIN_URL parameters:@{@"email" : _emailTextField.text, @"passwd" : _passwordTextField.text} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *result = dataDic[@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result intValue]) {
                //保存用户的auth
                [UserInfoManager conserveUserAuth:[[dataDic objectForKey:@"data"] objectForKey:@"auth"]];
                //保存用户名
                [UserInfoManager conserveUserName:[[dataDic objectForKey:@"data"] objectForKey:@"uname"]];
                //保存用户id
                [UserInfoManager conserveUserID:[[dataDic objectForKey:@"data"] objectForKey:@"uid"]];
                //保存用户icon
                [UserInfoManager conserveUserIcon:[[dataDic objectForKey:@"data"] objectForKey:@"coverimg"]];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSString *msg = dataDic[@"data"][@"msg"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
    } error:^(NSError *error) {
        
    }];
}

- (void)regist
{
    RegistViewController *registVC = [[RegistViewController alloc] init];
    registVC.barButtonTitle = @"注册";
    [self.navigationController pushViewController:registVC animated:YES];
}

@end