//
//  ProductInfoViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "ProductCommentlistModel.h"

@interface ProductInfoViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSMutableArray *commentListArray; // 用户评论数据源

@end

@implementation ProductInfoViewController

- (NSMutableArray *)commentListArray {
    if (!_commentListArray) {
        self.commentListArray = [NSMutableArray array];
    }
    return _commentListArray;
}

-(void)requestData {
    [NetWorkrequestManage requestWithType:POST url:SHOPINFO_URL parameters:@{@"contentid" : _contentid} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        //NSLog(@"dataDic = %@", dataDic);
        
        // 获取评论列表数据
        NSArray *commentListArr = dataDic[@"data"][@"commentlist"];
        for (NSDictionary *commentList in commentListArr) {
            // 创建commentlistmodel
            ProductCommentlistModel *commentListModel = [[ProductCommentlistModel alloc] init];
            [commentListModel setValuesForKeysWithDictionary:commentList];
            
            //  创建用户对象
            ProductUserInfoModel *userInfo = [[ProductUserInfoModel alloc] init];
            [userInfo setValuesForKeysWithDictionary:commentList[@"userinfo"]];
            
            commentListModel.userInfo = userInfo;
            
            [self.commentListArray addObject:commentListModel];
        }
        
        // 获取详情信息, 用webview进行展示
        //NSURL *url = [NSURL URLWithString:dataDic[@"data"][@"shareinfo"][@"url"]];
        NSURL *url = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
        NSString *htmlString = dataDic[@"data"][@"postsinfo"][@"html"];
        NSString *newString = [NSString importStyleWithHtmlString:htmlString];
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:newString baseURL:url];
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
}

@end
