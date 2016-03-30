//
//  ReadDetailViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadDetailViewController.h"
#import "ReadDetailListModel.h"

@interface ReadDetailViewController ()

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
        NSLog(@"dataDic = %@", dataDic);
        
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
            
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self requestDataWithSort:@"addtime"];
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
