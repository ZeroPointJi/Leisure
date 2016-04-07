//
//  TopicViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicListModel.h"
#import "TopicListModelCell.h"

#define kLIMIT 10

@interface TopicViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL ishot;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, strong) NSMutableArray *addTimeListArray; // 最新数据源
@property (nonatomic, strong) NSMutableArray *hotListArray; // 热门数据源

@end

@implementation TopicViewController

-(NSMutableArray *)addTimeListArray {
    if (!_addTimeListArray) {
        self.addTimeListArray = [NSMutableArray array];
    }
    return _addTimeListArray;
}

- (NSMutableArray *)hotListArray
{
    if (!_hotListArray) {
        self.hotListArray = [NSMutableArray array];
    }
    return _hotListArray;
}

- (void)requestRefreshDattWithSort
{
    _start += kLIMIT;
    NSString *sort = nil;
    if (_ishot) {
        sort = @"hot";
    } else {
        sort = @"addtime";
    }
    [NetWorkrequestManage requestWithType:POST url:TOPICLIST_URL parameters:@{@"sort" : sort, @"start" : @(_start), @"limit" : @(kLIMIT)} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        //NSLog(@"dataDic = %@", dataDic);
        
        // 获取详情列表的数据源
        NSArray *listArr = dataDic[@"data"][@"list"];
        for (NSDictionary *list in listArr) {
            TopicListModel *listModel = [[TopicListModel alloc] init];
            TopicUserInfoModel *userInfo = [[TopicUserInfoModel alloc] init];
            TopicCounterListModel *counter = [[TopicCounterListModel alloc] init];
            
            [listModel setValuesForKeysWithDictionary:list];
            [counter setValuesForKeysWithDictionary:list[@"counterList"]];
            [userInfo setValuesForKeysWithDictionary:list[@"userinfo"]];
            
            listModel.userInfo = userInfo;
            listModel.counter = counter;
            
            if ([sort isEqualToString:@"addtime"]) {
                [self.addTimeListArray addObject:listModel];
            } else {
                [self.hotListArray addObject:listModel];
            }
        }
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (listArr.count != kLIMIT) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        });
        
    } error:^(NSError *error) {
        
    }];
}

-(void)requestDataWith
{
    NSString *sort = nil;
    sort = _ishot ? @"hot" : @"addtime";
    self.start = 0;
    [NetWorkrequestManage requestWithType:POST url:TOPICLIST_URL parameters:@{@"sort" : sort, @"start" : @(_start), @"limit" : @(kLIMIT)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
       
        if (_ishot) {
            [self.hotListArray removeAllObjects];
        } else {
            [self.addTimeListArray removeAllObjects];
        }
        
        // 获取列表数据
        NSArray *listArr = dataDic[@"data"][@"list"];
        for (NSDictionary *list in listArr) {
            TopicListModel *listModel = [[TopicListModel alloc] init];
            TopicUserInfoModel *userInfo = [[TopicUserInfoModel alloc] init];
            TopicCounterListModel *counter = [[TopicCounterListModel alloc] init];
            
            [listModel setValuesForKeysWithDictionary:list];
            [counter setValuesForKeysWithDictionary:list[@"counterList"]];
            [userInfo setValuesForKeysWithDictionary:list[@"userinfo"]];
            
            listModel.userInfo = userInfo;
            listModel.counter = counter;
            
            if ([sort isEqualToString:@"addtime"]) {
                [self.addTimeListArray addObject:listModel];
            } else {
                [self.hotListArray addObject:listModel];
            }
        }
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createTableView];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ishot = NO;
    
    [self createSegmentedControl];
    
    [self requestDataWith];
}

- (void)createBackButton
{
    
}

- (void)createSegmentedControl
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"New", @"Hot"]];
    _segmentedControl.frame = CGRectMake(ScreenWidth / 2 - 60, 10, 120, 20);
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(changeState) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
}

- (void)changeState
{
    self.ishot = !self.ishot;
    [self requestDataWith];
}

- (void)createTableView
{
    [self.tableView removeFromSuperview];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 104) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDataWith)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestRefreshDattWithSort)];
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Table View Delegate & DataSouce

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicListModel *model = nil;
    if (_ishot) {
        model = _hotListArray[indexPath.row];
    } else {
        model = _addTimeListArray[indexPath.row];
    }
    return [TopicListModelCell getHeight:model];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_ishot) {
        return self.hotListArray.count;
    } else  {
        return self.addTimeListArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel *model = nil;
    if (_ishot) {
        model = self.hotListArray[indexPath.row];
    } else {
        model = self.addTimeListArray[indexPath.row];
    }
    
    BaseTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopicListModel class])];
    if (cell == nil) {
        cell = [FactoryTableViewCell createTableViewCell:model];
    }
    [cell setData:model];
    
    return cell;
}

@end
