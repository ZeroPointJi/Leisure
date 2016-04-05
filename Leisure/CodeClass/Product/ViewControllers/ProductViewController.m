//
//  ProductViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductListModel.h"
#import "ProductListModelCell.h"

#import "ProductInfoViewController.h"

#define kLIMIT 10

@interface ProductViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger start; // 请求开始位置

@property (nonatomic, strong) NSMutableArray *listArray; // 列表数据源

@end

@implementation ProductViewController

-(NSMutableArray *)listArray {
    if (!_listArray) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)requestRefreshData {
    _start += kLIMIT;
    [NetWorkrequestManage requestWithType:POST url:SHOPLIST_URL parameters:@{@"start" : @(_start), @"limit" : @(kLIMIT)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"dataDic = %@", dataDic);
        
        // 获取列表数据源
        NSArray *listArr = dataDic[@"data"][@"list"];
        for (NSDictionary *list in listArr) {
            ProductListModel *listModel = [[ProductListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:list];
            [self.listArray addObject:listModel];
        }
        
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

- (void)requestData {
    _start = 0;
    [NetWorkrequestManage requestWithType:POST url:SHOPLIST_URL parameters:@{@"start" : @(_start), @"limit" : @(kLIMIT)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"dataDic = %@", dataDic);
        
        [self.listArray removeAllObjects];
        
        // 获取列表数据源
        NSArray *listArr = dataDic[@"data"][@"list"];
        for (NSDictionary *list in listArr) {
            ProductListModel *listModel = [[ProductListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:list];
            [self.listArray addObject:listModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
        
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createTableView];
    
    [self requestData];
}

- (void)createBackButton
{
    
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestRefreshData)];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProductListModelCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProductListModel class])];
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:_tableView];
}

#pragma mark - Table View Delegate & DataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel *model = self.listArray[indexPath.row];
    BaseTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([model class]) forIndexPath:indexPath];
    [cell setData:model];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ProductListModel *model = self.listArray[indexPath.row];
//    ProductInfoViewController *infoVC = [[ProductInfoViewController alloc] init];
//    infoVC.contentid = model.contentid;
//    [self.navigationController pushViewController:infoVC animated:YES];
//}

@end