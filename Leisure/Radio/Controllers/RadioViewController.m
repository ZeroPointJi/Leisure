//
//  RadioViewController.m
//  Drawer
//
//  Created by zero on 16/3/28.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioAllListModel.h"
#import "RadioHotListModel.h"
#import "RadioCarouselModel.h"
#import "RadioDetailViewController.h"

@interface RadioViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *allListTableView;
@property (nonatomic, strong) NSMutableArray *allListArray;
@property (nonatomic, strong) NSMutableArray *carouselArray;
@property (nonatomic, strong) NSMutableArray *hotListArray;

@end

@implementation RadioViewController

- (NSMutableArray *)allListArray
{
    if (_allListArray == nil) {
        self.allListArray = [NSMutableArray array];
    }
    return _allListArray;
}

- (NSMutableArray *)carouselArray
{
    if (_allListArray == nil) {
        self.carouselArray = [NSMutableArray array];
    }
    return _allListArray;
}

- (NSMutableArray *)hotListArray
{
    if (_hotListArray == nil) {
        self.hotListArray = [NSMutableArray array];
    }
    return _hotListArray;
}

- (void)createData
{
    [NetWorkRequestManager requestWithType:POST urlString:RADIOLIST_URL parDic:@{} requestFinish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@", dic);
        
        NSArray *allListArr = [[dic objectForKey:@"data"] objectForKey:@"alllist"];
        for (NSDictionary *dicModel in allListArr) {
            RadioAllListModel *allListModel = [[RadioAllListModel alloc] init];
            [allListModel setValuesForKeysWithDictionary:dicModel];
            [self.allListArray addObject:allListModel];
        }
        //NSLog(@"%@", self.allListArray);
        
        NSArray *carouselArr = [[dic objectForKey:@"data"] objectForKey:@"carsousel"];
        for (NSDictionary *dicModel in carouselArr) {
            RadioCarouselModel *carouselModel = [[RadioCarouselModel alloc] init];
            [carouselModel setValuesForKeysWithDictionary:dicModel];
            [self.carouselArray addObject:carouselModel];
        }
        //NSLog(@"%@", self.carouselArray);
        
        NSArray *hotListArr = [[dic objectForKey:@"data"] objectForKey:@"hotlist"];
        for (NSDictionary *dicModel in hotListArr) {
            RadioHotListModel *hotListModel = [[RadioHotListModel alloc] init];
            [hotListModel setValuesForKeysWithDictionary:dicModel];
            [self.hotListArray addObject:hotListModel];
        }
        //NSLog(@"%@", self.hotListArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.allListTableView reloadData];
        });
        
    } requestError:^(NSError *error) {
        NSLog(@"请求失败");
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
    
    [self createTableView];
    
    [self createData];
}

- (void)createTableView
{
    self.allListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 164, ScreenWidth, ScreenHeight - 164) style:UITableViewStyleGrouped];
    _allListTableView.delegate = self;
    _allListTableView.dataSource = self;
    _allListTableView.backgroundColor = [UIColor clearColor];
    _allListTableView.rowHeight = 120;
    
    [self.view addSubview:_allListTableView];
}

#pragma mark - Table View Delegate & Datasouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.allListTableView dequeueReusableCellWithIdentifier:@"testCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"testCell"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        label.text = [self.allListArray[indexPath.row] title];
        [cell.contentView addSubview:label];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadioDetailViewController *detailVC = [[RadioDetailViewController alloc] init];
    detailVC.radioid = [self.allListArray[indexPath.row] radioid];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
