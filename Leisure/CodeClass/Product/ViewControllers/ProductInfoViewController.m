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
        NSLog(@"dataDic = %@", dataDic);
        
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
        NSString *htmlContent = dataDic[@"data"][@"html"];
        
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
