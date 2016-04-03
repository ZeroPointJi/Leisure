//
//  ReadViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadCarouselModel.h"
#import "ReadListModel.h"
#import "ReadListModelCell.h"
#import "ReadDetailViewController.h"
#import "FactoryCollectionViewCell.h"

@interface ReadViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *carouselArray; // 轮播图的数据源
@property (nonatomic, strong) NSMutableArray *listArray; // 列表数据源

@end

@implementation ReadViewController

-(NSMutableArray *)listArray {
    if (!_listArray) {
        self.listArray = [NSMutableArray array];
    }
    return _listArray;
}

-(NSMutableArray *)carouselArray {
    if (!_carouselArray) {
        self.carouselArray = [NSMutableArray array];
    }
    return _carouselArray;
}


-(void)requestData {
    [NetWorkrequestManage requestWithType:POST url:READHOMELIST_URL parameters:nil finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"dataDic = %@", dataDic);
        
        // 获取轮播图数据
        NSArray *carouselArr = [[dataDic objectForKey:@"data"] objectForKey:@"carousel"];
        for (NSDictionary *carousel in carouselArr) {
            // 创建model
            ReadCarouselModel *carouselModel = [[ReadCarouselModel alloc] init];
            [carouselModel setValuesForKeysWithDictionary:carousel];
            
            [self.carouselArray addObject:carouselModel];
        }
        
        // 获取列表数据源
        NSArray *listArray = dataDic[@"data"][@"list"];
        for (NSDictionary *list in listArray) {
            // 创建列表数据model
            ReadListModel *listModel = [[ReadListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:list];
            
            [self.listArray addObject:listModel];
        }
        
        // 回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createCycleScrollView];
            // 刷新 collectionView
            [self createCollectionView];
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 请求数据
    [self requestData];
}

- (void)createCycleScrollView
{
    NSMutableArray *imageUrlArr = [NSMutableArray array];
    for (ReadCarouselModel *model in self.carouselArray) {
        [imageUrlArr addObject:model.img];
    }
    SDCycleScrollView *cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - ScreenWidth - 64) imageURLStringsGroup:imageUrlArr];
    cycle.autoScrollTimeInterval = 5;
    [self.view addSubview:cycle];
}

- (void)createCollectionView
{
    //创建flowlayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置行之间的最小间隔
    layout.minimumLineSpacing = 2;
    //设置列之间的最小间隔
    layout.minimumInteritemSpacing = 2;
    //设置item（cell）的大小
    layout.itemSize = CGSizeMake(ScreenWidth / 3 - 10 ,ScreenWidth / 3 - 10 );
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //创建collectionview对象，设置代理，设置数据源
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ScreenWidth - 64, ScreenWidth, ScreenWidth) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadListModelCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ReadListModel class])];
    
    [self.view addSubview:_collectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BaseModel *model = self.listArray[indexPath.row];
    BaseCollectionViewCell *cell = [FactoryCollectionViewCell createCollectionViewCell:_listArray[indexPath.row] andCollectionView:collectionView andIndexPath:indexPath];
    
    [cell setDataWithModel:model];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 测试跳转到详情列表
    ReadDetailViewController *detailVC = [[ReadDetailViewController alloc] init];
   
    ReadListModel *model = self.listArray[indexPath.row];
    detailVC.typeID = model.type;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


@end