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
#import "CollectDB.h"

@interface ReadInfoViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ReadInfoViewController

- (void)requestData
{
    [NetWorkrequestManage requestWithType:POST url:READCONTENT_URL parameters:@{@"contentid" : _model.contentID} finish:^(NSData *data) {
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
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(0, 0, 50, 44);
    [commentButton setImage:[UIImage imageNamed:@"评论2"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(pushCommontView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithCustomView:commentButton];
    
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(0, 0, 50, 44);
    UIImage *image = [UIImage imageNamed:_isCollect ? @"喜欢2" : @"喜欢1"];
    [collectButton setImage:image forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(selectCollect:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
    
    self.navigationItem.rightBarButtonItems = @[commentItem, collectItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)selectCollect:(UIButton *)button
{
    if ([[UserInfoManager getUserAuth] isEqualToString:@" "]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
    } else {
        CollectDB *collectDB = [[CollectDB alloc] init];
        if (_isCollect) {
            [button setImage:[UIImage imageNamed:@"喜欢1"] forState:UIControlStateNormal];
            [collectDB deleteModel:_model];
            _isCollect = NO;
        } else {
            [button setImage:[UIImage imageNamed:@"喜欢2"] forState:UIControlStateNormal];
            [collectDB insertModel:_model];
            _isCollect = YES;
        }
    }
}

- (void)pushCommontView
{
    if ([[UserInfoManager getUserAuth] isEqualToString:@" "]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:naVC animated:YES completion:nil];
    } else {
        ReadCommontListViewController *commontVC = [[ReadCommontListViewController alloc] init];
        commontVC.contentid = _model.contentID;
        commontVC.barButtonTitle = @"评论";
        [self.navigationController pushViewController:commontVC animated:YES];
    }
}

@end
