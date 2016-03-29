//
//  RadioDetailViewController.m
//  Drawer
//
//  Created by zero on 16/3/28.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "RadioDetailListModel.h"

@interface RadioDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *detailTableview;
@property (nonatomic, strong) NSMutableArray *detailListArray;

@end

@implementation RadioDetailViewController

- (NSMutableArray *)detailListArray
{
    if (_detailListArray == nil) {
        self.detailListArray = [NSMutableArray array];
    }
    return _detailListArray;
}

- (void)createData
{
    [NetWorkRequestManager requestWithType:POST urlString:RADIODETAIL_URL parDic:@{@"radioid" : self.radioid} requestFinish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingAllowFragments error:nil];
        //NSLog(@"%@", dic);
        
        NSArray *listArr = [[dic objectForKey:@"data"] objectForKey:@"list"];
        for (NSDictionary *listModel in listArr) {
            RadioDetailListModel *detailListModel = [[RadioDetailListModel alloc] init];
            [detailListModel setValuesForKeysWithDictionary:listModel];
            [self.detailListArray addObject:detailListModel];
        }
        //NSLog(@"%@", self.detailListArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.detailTableview reloadData];
        });
        
    } requestError:^(NSError *error) {
        NSLog(@"加载失败");
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self createTableView];
    
    [self createData];
}

- (void)createTableView
{
    self.detailTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 164, ScreenWidth, ScreenHeight - 164) style:UITableViewStylePlain];
    self.detailTableview.delegate = self;
    self.detailTableview.dataSource = self;
    self.detailTableview.backgroundColor = [UIColor darkGrayColor];
    
    [self.view addSubview:self.detailTableview];
}

#pragma mark - Table View Delegate & DataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.detailTableview dequeueReusableCellWithIdentifier:@"testCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"testcell"];
    }
    cell.textLabel.text = [self.detailListArray[indexPath.row] title];
    
    return cell;
}

@end
