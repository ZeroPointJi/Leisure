//
//  RegistViewController.m
//  Leisure
//
//  Created by zero on 16/4/8.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController () 

@property (nonatomic, assign) NSInteger isBoy;

@property (weak, nonatomic) IBOutlet UITextField *unameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *boyButton;
@property (weak, nonatomic) IBOutlet UIButton *girlButton;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _boyButton.layer.cornerRadius = 10;
    _girlButton.layer.cornerRadius = 10;
    
    [self.registFirstResponseArray addObject:_unameTextField];
    [self.registFirstResponseArray addObject:_emailTextField];
    [self.registFirstResponseArray addObject:_passwordTextField];
    
    [self selectGender:nil];
}

- (IBAction)selectGender:(UIButton *)sender {
    if ([sender.titleLabel.text hasSuffix:@"男"]) {
        self.isBoy = 1;
        [self.boyButton setBackgroundColor:[UIColor blueColor]];
        [self.girlButton setBackgroundColor:[UIColor whiteColor]];
    } else {
        self.isBoy = 0;
        [self.boyButton setBackgroundColor:[UIColor whiteColor]];
        [self.girlButton setBackgroundColor:[UIColor blueColor]];
    }
}

- (IBAction)regist:(id)sender {
    
    [NetWorkrequestManage requestWithType:POST url:REGISTER_URL parameters:@{@"uname" : [_unameTextField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], @"email" : _emailTextField.text, @"passwd" : _passwordTextField.text, @"gender" : [NSNumber numberWithInteger:_isBoy]} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *result = dataDic[@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result intValue]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                NSString *msg = dataDic[@"data"][@"msg"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        });
        
    } error:^(NSError *error) {
        
    }];
}

@end