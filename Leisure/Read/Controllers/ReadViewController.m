//
//  ReadViewController.m
//  Drawer
//
//  Created by zero on 16/3/28.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadCarouselModel.h"
#import "ReadListModel.h"

@interface ReadViewController () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *carouselArray;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ReadViewController

- (NSMutableArray *)carouselArray
{
    if (_carouselArray == nil) {
        _carouselArray = [[NSMutableArray alloc] init];
    }
    return _carouselArray;
}

- (NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

- (void)createData
{
    [NetWorkRequestManager requestWithType:POST urlString:READLIST_URL parDic:@{} requestFinish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@", dic);
        
        NSArray *carouselArr = [[dic objectForKey:@"data"] objectForKey:@"carousel"];
        for (NSDictionary *dicModel in carouselArr) {
            ReadCarouselModel *carouselModel = [[ReadCarouselModel alloc] init];
            [carouselModel setValuesForKeysWithDictionary:dicModel];
            [self.carouselArray addObject:carouselModel];
        }
        //NSLog(@"%@", self.carouselArray);
        
        NSArray *listArr = [[dic objectForKey:@"data"] objectForKey:@"list"];
        for (NSDictionary *dicModel in listArr) {
            ReadListModel *listModel = [[ReadListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:dicModel];
            [self.listArray addObject:listModel];
        }
        //NSLog(@"%@", self.listArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    } requestError:^(NSError *error) {
        NSLog(@"出错了!");
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createCollectionView];
    
    [self createData];
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.itemSize = CGSizeMake(ScreenWidth / 3 - 10,  ScreenWidth / 3);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 164, ScreenWidth, ScreenHeight - 164) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor redColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"testCell"];
    
    [self.view addSubview:_collectionView];
}

#pragma mark - Collection View Delegate & DataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"testCell" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    label.text = [self.listArray[indexPath.row] name];
    [cell.contentView addSubview:label];
    //cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

/*
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
*/
@end
