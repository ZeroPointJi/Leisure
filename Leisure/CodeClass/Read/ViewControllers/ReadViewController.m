//
//  ReadViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadCarouselModel.h"
#import "ReadListModel.h"

#import "ReadDetailViewController.h"

@interface ReadViewController ()

@property (nonatomic, strong) NSMutableArray *carouselArray; // 轮播图的数据源
@property (nonatomic, strong) NSMutableArray *listArray; // 列表数据源

@end

@implementation ReadViewController

-(NSMutableArray *)listArray {
    if (!_listArray) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}

-(NSMutableArray *)carouselArray {
    if (!_carouselArray) {
        self.carouselArray = [NSMutableArray array];
    }
    return _carouselArray;
}


-(void)requestData {
    [NetWorkrequestManage requestWithType:POST url:READHOMELIST_URL parameters:nil finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"dataDic = %@", dataDic);
        
        // 获取轮播图数据
        NSArray *carouselArr = [[dataDic objectForKey:@"data"] objectForKey:@"carousel"];
        for (NSDictionary *carousel in carouselArr) {
            // 创建model
            ReadCarouselModel *carouselModel = [[ReadCarouselModel alloc] init];
            [carouselModel setValuesForKeysWithDictionary:carousel];
            
            [self.carouselArray addObject:carouselModel];
        }
        
        // 获取列表数据源
        NSArray *listArray = dataDic[@"data"][@"list"];
        for (NSDictionary *list in listArray) {
            // 创建列表数据model
            ReadListModel *listModel = [[ReadListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:list];
            
            [self.listArray addObject:listModel];
        }
        
        // 回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 测试跳转到详情列表
//            ReadDetailViewController *detailVC = [[ReadDetailViewController alloc] init];
//            
//            ReadListModel *model = self.listArray[0];
//            detailVC.typeID = model.type;
//            
//            [self.navigationController pushViewController:detailVC animated:YES];
            
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor yellowColor];
    // 请求数据
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
