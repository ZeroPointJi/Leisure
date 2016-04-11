//
//  RadioViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioListModel.h"
#import "RadioListModelCell.h"
#import "RadioCarouselModel.h"
#import <MJRefresh.h>

#import "RadioDetailViewController.h"

#define kLIMIT 10

@interface RadioViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger start;

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
    _start += kLIMIT;
    [NetWorkrequestManage requestWithType:POST url:RADIOLISTMORE_URL parameters:@{@"start" : @(_start), @"limit" : @(kLIMIT)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        
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
            [self.tableView reloadData];
            if (allListArr.count != kLIMIT) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        });
        
    } error:^(NSError *error) {
        
    }];
}

// 首次请求
- (void)requestFirstData {
    _start = 0;
    [NetWorkrequestManage requestWithType:POST url:RADIOLIST_URL parameters:@{} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        
        [self.allListArray removeAllObjects];
        [self.carouselArray removeAllObjects];
        [self.hotListArray removeAllObjects];
        
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
            [self createTableView];
            //if (allListArr.count != kLIMIT) {
                //[self.tableView.mj_footer endRefreshingWithNoMoreData];
            //} else {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            //}
        });
        
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self requestFirstData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)createBackButton
{
    
}

- (SDCycleScrollView *)createCycleScorllView
{
    NSMutableArray *imageURLArr = [NSMutableArray array];
    for (RadioCarouselModel *model in self.carouselArray) {
        [imageURLArr addObject:model.img];
    }
    SDCycleScrollView *cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 180) imageURLStringsGroup:imageURLArr];
    cycle.autoScrollTimeInterval = 5;
    
    return cycle;
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RadioListModelCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioListModel class])];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestRefreshData)];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestFirstData)];
    _tableView.tableHeaderView = [self createCycleScorllView];
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_tableView];
}

#pragma mark - Table View Delegate & DataSource -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"RadioAllListHeaderView" owner:nil options:nil];
    UIView *view = [viewArr lastObject];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel *model = self.allListArray[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model withTableView:tableView andIndexPath:indexPath];
    
    [cell setData:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadioListModel *model = self.allListArray[indexPath.row];
    RadioDetailViewController *radioDetailVC = [[RadioDetailViewController alloc] init];
    radioDetailVC.radioModel = model;
    radioDetailVC.barButtonTitle = model.title;
    [self.navigationController pushViewController:radioDetailVC animated:YES];
}

@end