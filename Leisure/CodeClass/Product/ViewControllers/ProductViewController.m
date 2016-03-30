//
//  ProductViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductListModel.h"

#import "ProductInfoViewController.h"

@interface ProductViewController ()

@property (nonatomic, assign) NSInteger start; // 请求开始位置
@property (nonatomic, assign) NSInteger limit; // 请求的个数

@property (nonatomic, strong) NSMutableArray *listArray; // 列表数据源

@end

@implementation ProductViewController

-(NSMutableArray *)listArray {
    if (!_listArray) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)requestData {
    [NetWorkrequestManage requestWithType:POST url:SHOPLIST_URL parameters:@{@"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dataDic = %@", dataDic);
        
        // 获取列表数据源
        NSArray *listArr = dataDic[@"data"][@"list"];
        for (NSDictionary *list in listArr) {
            ProductListModel *listModel = [[ProductListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:list];
            [self.listArray addObject:listModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 测试跳转
//            ProductInfoViewController *infoVC = [[ProductInfoViewController alloc] init];
//            ProductListModel *model = self.listArray[0];
//            infoVC.contentid = model.contentid;
//            
//            [self.navigationController pushViewController:infoVC animated:YES];
            
        });
        
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor purpleColor];
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
