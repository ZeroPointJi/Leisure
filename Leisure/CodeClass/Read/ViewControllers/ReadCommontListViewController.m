//
//  ReadCommontListViewController.m
//  Leisure
//
//  Created by zero on 16/4/8.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadCommontListViewController.h"
#import "ReadCommontModelCell.h"
#import "ReadCommontModel.h"
#import "KeyBoardView.h"

#define kLIMIT 10

@interface ReadCommontListViewController () <UITableViewDelegate, UITableViewDataSource, KeyBoardViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *commontListArray;

@property (nonatomic, assign) NSInteger start;

@property (nonatomic, strong) KeyBoardView *keyboardView;
@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation ReadCommontListViewController

- (NSMutableArray *)commontListArray
{
    if (_commontListArray == nil) {
        self.commontListArray = [NSMutableArray array];
    }
    
    return _commontListArray;
}

- (void)requestRefreshData
{
    _start += kLIMIT;
    [NetWorkrequestManage requestWithType:POST url:READGETCOMMONT_URL parameters:@{@"contentid" : _contentid, @"auth" : [UserInfoManager getUserAuth], @"start" : @(_start), @"limit" : @(kLIMIT)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *dataArr = dataDic[@"data"][@"list"];
        for (NSDictionary *modelDic in dataArr) {
            ReadCommontModel *model = [[ReadCommontModel alloc] init];
            [model setValuesForKeysWithDictionary:modelDic];
            [self.commontListArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (dataArr.count != kLIMIT) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_tableView.mj_footer endRefreshing];
            }
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)requestData
{
    _start = 0;
    [NetWorkrequestManage requestWithType:POST url:READGETCOMMONT_URL parameters:@{@"contentid" : _contentid, @"auth" : [UserInfoManager getUserAuth], @"start" : @(_start), @"limit" : @(kLIMIT)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        [_commontListArray removeAllObjects];
        
        NSArray *dataArr = dataDic[@"data"][@"list"];
        for (NSDictionary *modelDic in dataArr) {
            ReadCommontModel *model = [[ReadCommontModel alloc] init];
            [model setValuesForKeysWithDictionary:modelDic];
            [self.commontListArray addObject:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (dataArr.count != kLIMIT) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_tableView.mj_footer endRefreshing];
                [_tableView.mj_header endRefreshing];
            }
        });
        
    } error:^(NSError *error) {
        
    }];
}

// 发送评论请求
- (void)requestSendCommont
{
    [NetWorkrequestManage requestWithType:POST url:READCOMMONT_URL parameters:@{@"auth" : [UserInfoManager getUserAuth], @"contentid" : _contentid, @"content" : [self.keyboardView.textView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSNumber *result = dataDic[@"result"];
        
        if ([result intValue]) {
            [self requestData];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"评论失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];

    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestRefreshData)];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    [self.view addSubview:_tableView];
}

- (void)createBackButton
{
    [super createBackButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"评论"] style:UIBarButtonItemStyleDone target:self action:@selector(createKeyboardView)];
}

#pragma mark - KeyBoard TextField -

- (void)createKeyboardView
{
    if (!_keyboardView) {
        self.keyboardView = [[KeyBoardView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 44 - 64, ScreenWidth, 44)];
    }
    
    _keyboardView.delegate = self;
    [_keyboardView.textView becomeFirstResponder];
    _keyboardView.textView.returnKeyType = UIReturnKeySend;
    [self.view addSubview:_keyboardView];
}

- (void)keyboardShow:(NSNotification *)no
{
    CGRect keyboardRect = [no.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyboardRect.size.height;
    _keyboardHeight = deltaY;
    [UIView animateWithDuration:[no.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyboardView.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

- (void)keyboardHide:(NSNotification *)no
{
    [UIView animateWithDuration:[no.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyboardView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.keyboardView.textView.text=@"";
        [self.keyboardView removeFromSuperview];
    }];
}

- (void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    [_keyboardView.textView resignFirstResponder];
    
    [self requestSendCommont];
}

#pragma mark - Table View Delegate & DataSource -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadCommontModel *model = self.commontListArray[indexPath.row];
    
    return [ReadCommontModelCell getHeightWithModel:model];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commontListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadCommontModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReadCommontModel"];
    if (cell == nil) {
        cell = [[ReadCommontModelCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"ReadCommontModel"];
    }
    ReadCommontModel *model = self.commontListArray[indexPath.row];
    [cell setData:model];
    
    return cell;
}

@end