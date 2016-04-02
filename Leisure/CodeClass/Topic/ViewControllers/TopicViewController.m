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

@interface TopicViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL ishot;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;

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

-(void)requestDataWith:(NSString *)sort {
    
    [NetWorkrequestManage requestWithType:POST url:TOPICLIST_URL parameters:@{@"sort" : sort, @"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        //NSLog(@"dataDic = %@", dataDic);
        
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
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ishot = NO;
    
    [self createSegmentedControl];
    
    [self requestDataWith:@"addtime"];
}

- (void)createSegmentedControl
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"New", @"Hot"]];
    _segmentedControl.frame = CGRectMake(0, 0, ScreenWidth, 40);
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(changeState) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
}

- (void)changeState
{
    self.ishot = !self.ishot;
    [self requestDataWith:(_ishot ? @"hot" : @"addtime")];
}

- (void)createTableView
{
    [self.tableView removeFromSuperview];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 104) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Table View Delegate & DataSouce

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
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
