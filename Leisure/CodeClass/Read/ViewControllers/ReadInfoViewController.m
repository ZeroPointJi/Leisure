//
//  ReadInfoViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadInfoViewController.h"
#import "ReadCommontListViewController.h"
#import "LoginViewController.h"

@interface ReadInfoViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ReadInfoViewController

- (void)requestData
{
    [NetWorkrequestManage requestWithType:POST url:READCONTENT_URL parameters:@{@"contentid" : _contentid} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSURL *url = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
        NSString *htmlString = dataDic[@"data"][@"html"];
        NSString *newString = [NSString importStyleWithHtmlString:htmlString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:newString baseURL:url];
        });
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestData];
}

- (void)createBackButton
{
    [super createBackButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"评论2"] style:UIBarButtonItemStyleDone target:self action:@selector(pushCommontView)];
}

- (void)pushCommontView
{
    if ([[UserInfoManager getUserAuth] isEqualToString:@" "]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
    } else {
        ReadCommontListViewController *commontVC = [[ReadCommontListViewController alloc] init];
        commontVC.contentid = self.contentid;
        commontVC.barButtonTitle = @"评论";
        [self.navigationController pushViewController:commontVC animated:YES];
    }
}

@end
