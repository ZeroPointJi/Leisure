//
//  CollectViewController.m
//  Leisure
//
//  Created by zero on 16/4/11.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectDB.h"
#import "ReadDetailListModel.h"
#import "ReadDetailListModelCell.h"
#import "ReadInfoViewController.h"

@interface CollectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *collectListArray;

@end

@implementation CollectViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self update];
}

- (void)update
{
    CollectDB *collectDB = [[CollectDB alloc] init];
    self.collectListArray = [collectDB selectAllModel];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ReadDetailListModelCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Delegate & DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadDetailListModel *model = [self.collectListArray objectAtIndex:indexPath.row];
    ReadDetailListModelCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"reuse"];
    [cell setData:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadDetailListModel *model = self.collectListArray[indexPath.row];
    ReadInfoViewController *infoVC = [[ReadInfoViewController alloc] init];
    infoVC.barButtonTitle = model.title;
    infoVC.model = model;
    infoVC.isCollect = YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
