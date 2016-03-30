//
//  RadioViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioListModel.h"
#import "RadioCarouselModel.h"

#import "RadioDetailViewController.h"

@interface RadioViewController ()

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSMutableArray *allListArray; // 所有电台列表数据源
@property (nonatomic, strong) NSMutableArray *carouselArray; // 轮播图数据源
@property (nonatomic, strong) NSMutableArray *hotListArray; // 热门电台数据源

@end

@implementation RadioViewController

-(NSMutableArray *)hotListArray {
    if (!_hotListArray) {
        self.hotListArray = [NSMutableArray array];
    }
    return _hotListArray;
}

-(NSMutableArray *)carouselArray {
    if (!_carouselArray) {
        self.carouselArray = [NSMutableArray array];
    }
    return _carouselArray;
}
- (NSMutableArray *)allListArray {
    if (!_allListArray) {
        self.allListArray = [NSMutableArray array];
    }
    return _allListArray;
}

// 上拉刷新请求
- (void)requestRefreshData {
    [NetWorkrequestManage requestWithType:POST url:RADIOLISTMORE_URL parameters:@{@"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
//        NSLog(@"dataDic = %@", dataDic);
        
        // 获取所有电台列表数据
        NSArray *allListArr = dataDic[@"data"][@"list"];
        for (NSDictionary *allList in allListArr) {
            RadioListModel *listModel = [[RadioListModel alloc] init];
            RadioUserInfoModel *userInfo = [[RadioUserInfoModel alloc] init];
            
            [listModel setValuesForKeysWithDictionary:allList];
            [userInfo setValuesForKeysWithDictionary:allList[@"userinfo"]];
            
            listModel.userInfo = userInfo;
            
            [self.allListArray addObject:listModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            RadioDetailViewController *detailVC = [[RadioDetailViewController alloc] init];
            RadioListModel *model = self.allListArray[0];
            detailVC.radioID = model.radioid;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        });
        
    } error:^(NSError *error) {
        
    }];
}

// 首次请求
- (void)requestFirstData {
    [NetWorkrequestManage requestWithType:POST url:RADIOLIST_URL parameters:@{} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSLog(@"dataDic = %@", dataDic);
        
        // 获取所有电台列表数据
        NSArray *allListArr = dataDic[@"data"][@"alllist"];
        for (NSDictionary *allList in allListArr) {
            RadioListModel *listModel = [[RadioListModel alloc] init];
            RadioUserInfoModel *userInfo = [[RadioUserInfoModel alloc] init];
            
            [listModel setValuesForKeysWithDictionary:allList];
            [userInfo setValuesForKeysWithDictionary:allList[@"userinfo"]];
            
            listModel.userInfo = userInfo;
            
            [self.allListArray addObject:listModel];
        }
        
        // 获取轮播图数据
        NSArray *carouselArr = dataDic[@"data"][@"carousel"];
        for (NSDictionary *carousel in carouselArr) {
            RadioCarouselModel *carouselModel = [[RadioCarouselModel alloc] init];
            [carouselModel setValuesForKeysWithDictionary:carousel];
            
            [self.carouselArray addObject:carouselModel];
        }
        
        // 获取热门电台数据
        NSArray *hotListArr = dataDic[@"data"][@"hotlist"];
        for (NSDictionary *hotList in hotListArr) {
            RadioListModel *listModel = [[RadioListModel alloc] init];
            RadioUserInfoModel *userInfo = [[RadioUserInfoModel alloc] init];
            
            [listModel setValuesForKeysWithDictionary:hotList];
            [userInfo setValuesForKeysWithDictionary:hotList[@"userinfo"]];
            
            listModel.userInfo = userInfo;
            
            [self.hotListArray addObject:listModel];
        }
        
        // 回到主线程操作ui
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    
//    [self requestFirstData];
    [self requestRefreshData];
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
