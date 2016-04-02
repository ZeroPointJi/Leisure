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

@interface ReadDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger requestSort; // 请求数据的类型 0 最新 1 热门

@property (nonatomic, assign) NSInteger start; // 请求开始的位置
@property (nonatomic, assign) NSInteger limit; // 每次请求的数据条数

@property (nonatomic, strong) NSMutableArray *hotListArray; // 热门数据源
@property (nonatomic, strong) NSMutableArray *addtimeListArray; // 最新数据源

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


-(void)requestDataWithSort:(NSString *)sort {
    [NetWorkrequestManage requestWithType:POST url:READDETAILLIST_URL parameters:@{@"typeid" : _typeID, @"start" : @(_start), @"limit" : @(_limit), @"sort" : sort} finish:^(NSData *data) {
        
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
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    [self createNaButton];
    
    _requestSort = 0;
    [self requestDataWithSort:@"addtime"];
}

- (void)createNaButton
{
    UIBarButtonItem *addtimeItem = [[UIBarButtonItem alloc] initWithTitle:@"最新" style:UIBarButtonItemStyleDone target:self action:@selector(addtime)];
    UIBarButtonItem *hotItem = [[UIBarButtonItem alloc] initWithTitle:@"热门" style:UIBarButtonItemStyleDone target:self action:@selector(hot)];
    self.navigationItem.rightBarButtonItems = @[hotItem, addtimeItem];
}

- (void)addtime
{
    _requestSort = 0;
    if (self.addtimeListArray.count == 0) {
        [self requestDataWithSort:@"addtime"];
    } else {
        [self.tableView reloadData];
    }
}

- (void)hot
{
    _requestSort = 1;
    [self.tableView reloadData];
    if (self.hotListArray.count == 0) {
        [self requestDataWithSort:@"hot"];
    } else {
        [self.tableView reloadData];
    }
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadDetailListModelCell class]) bundle:nil]  forCellReuseIdentifier:NSStringFromClass([ReadDetailListModel class])];
    
    [self.view addSubview:_tableView];
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

@end
