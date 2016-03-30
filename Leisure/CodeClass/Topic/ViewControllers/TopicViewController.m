//
//  TopicViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicListModel.h"

@interface TopicViewController ()

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSMutableArray *listArray; // 列表数据源

@end

@implementation TopicViewController

-(NSMutableArray *)listArray {
    if (!_listArray) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}

-(void)requestDataWith:(NSString *)sort {
    
    [NetWorkrequestManage requestWithType:POST url:TOPICLIST_URL parameters:@{@"sort" : sort, @"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSLog(@"dataDic = %@", dataDic);
        
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
            
            [self.listArray addObject:listModel];
        }
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor redColor];
    [self requestDataWith:@"hot"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
