//
//  ReadDetailViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadDetailViewController.h"
#import "ReadDetailListModel.h"
#import "ReadDetailListModelCell.h"
#import "ReadInfoViewController.h"

#define kLIMIT 10

@interface ReadDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger requestSort; // 请求数据的类型 0 最新 1 热门

@property (nonatomic, assign) NSInteger start; // 请求开始的位置

@property (nonatomic, strong) NSMutableArray *hotListArray; // 热门数据源
@property (nonatomic, strong) NSMutableArray *addtimeListArray; // 最新数据源

@property (nonatomic, strong) UIButton *addtimeButton;
@property (nonatomic, strong) UIButton *hotButton;

@end

@implementation ReadDetailViewController

-(NSMutableArray *)hotListArray {
    if (!_hotListArray) {
        self.hotListArray = [NSMutableArray array];
    }
    return _hotListArray;
}
-(NSMutableArray *)addtimeListArray {
    if (!_addtimeListArray) {
        self.addtimeListArray = [NSMutableArray array];
    }
    return _addtimeListArray;
}

- (void)requestRefreshDattWithSort
{
    _start += kLIMIT;
    NSString *sort = nil;
    if (_requestSort) {
        sort = @"hot";
    } else {
        sort = @"addtime";
    }
    [NetWorkrequestManage requestWithType:POST url:READDETAILLIST_URL parameters:@{@"typeid" : _typeID, @"start" : @(_start), @"limit" : @(kLIMIT), @"sort" : sort} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        //NSLog(@"dataDic = %@", dataDic);
        
        // 获取详情列表的数据源
        NSArray *listArr = dataDic[@"data"][@"list"];
        for (NSDictionary *list in listArr) {
            
            // 创建listmodel
            ReadDetailListModel *detailListModel = [[ReadDetailListModel alloc] init];
            [detailListModel setValuesForKeysWithDictionary:list];
            
            // 判断添加热门还是最新
            if ([sort isEqualToString:@"hot"]) {
                [self.hotListArray addObject:detailListModel];
            } else {
                [self.addtimeListArray addObject:detailListModel];
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

-(void)requestDataWithSort
{
    NSString *sort = nil;
    sort = _requestSort ? @"hot" : @"addtime";
    _start = 0;
    [NetWorkrequestManage requestWithType:POST url:READDETAILLIST_URL parameters:@{@"typeid" : _typeID, @"start" : @(_start), @"limit" : @(kLIMIT), @"sort" : sort} finish:^(NSData *data) {
        
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        //NSLog(@"dataDic = %@", dataDic);
        
        _requestSort ? [self.hotListArray removeAllObjects] : [self.addtimeListArray removeAllObjects];
        
        // 获取详情列表的数据源
        NSArray *listArr = dataDic[@"data"][@"list"];
        for (NSDictionary *list in listArr) {
            
            // 创建listmodel
            ReadDetailListModel *detailListModel = [[ReadDetailListModel alloc] init];
            [detailListModel setValuesForKeysWithDictionary:list];
            
            // 判断添加热门还是最新
            if ([sort isEqualToString:@"hot"]) {
                [self.hotListArray addObject:detailListModel];
            } else {
                [self.addtimeListArray addObject:detailListModel];
            }
        }
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (listArr.count != kLIMIT) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
            }
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    [self createNaButton];
    
    _requestSort = 0;
    
    [self requestDataWithSort];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)createNaButton
{
    
    self.addtimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addtimeButton.frame = CGRectMake(0, 0, 25, 40);
    [_addtimeButton setImage:[UIImage imageNamed:@"NEW2"] forState:UIControlStateNormal];
    [_addtimeButton setImage:[UIImage imageNamed:@"NEW1"] forState:UIControlStateSelected];
    [_addtimeButton addTarget:self action:@selector(addtime) forControlEvents:UIControlEventTouchUpInside];
    _addtimeButton.adjustsImageWhenHighlighted = NO;
    self.addtimeButton.selected = YES;
    UIBarButtonItem *addtimeItem = [[UIBarButtonItem alloc] initWithCustomView:_addtimeButton];
    
    self.hotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hotButton.frame = CGRectMake(0, 0, 25, 40);
    [_hotButton setImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    [_hotButton setImage:[UIImage imageNamed:@"HOT1"] forState:UIControlStateSelected];
    [_hotButton addTarget:self action:@selector(hot) forControlEvents:UIControlEventTouchUpInside];
    _hotButton.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *hotItem = [[UIBarButtonItem alloc] initWithCustomView:_hotButton];
    
    self.navigationItem.rightBarButtonItems = @[hotItem, addtimeItem];
}

- (void)addtime
{
    _requestSort = 0;
    self.hotButton.selected = NO;
    self.addtimeButton.selected = YES;
    [self requestDataWithSort];
}

- (void)hot
{
    _requestSort = 1;
    self.hotButton.selected = YES;
    self.addtimeButton.selected = NO;
    [self requestDataWithSort];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestRefreshDattWithSort)];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDataWithSort)];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadDetailListModelCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([ReadDetailListModel class])];
    
    [self.view addSubview:_tableView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Table View Delegate & DataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _requestSort ==  0 ? self.addtimeListArray.count : self.hotListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseModel *model =  nil;
    model = _requestSort == 0 ? self.addtimeListArray[indexPath.row] : self.hotListArray[indexPath.row];
    BaseTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([model class]) forIndexPath:indexPath];
    [cell setData:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadDetailListModel *model = _requestSort == 0 ? self.addtimeListArray[indexPath.row] : self.hotListArray[indexPath.row];
    ReadInfoViewController *infoVC = [[ReadInfoViewController alloc] init];
    infoVC.contentid = model.contentID;
    infoVC.barButtonTitle = model.title;
    
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
