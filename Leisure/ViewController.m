//
//  ViewController.m
//  Drawer
//
//  Created by zero on 16/3/28.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "ReadViewController.h"
#import "RadioViewController.h"
#import "TopicViewController.h"
#import "ProductViewController.h"

#define kLeftWidth [UIScreen mainScreen].bounds.size.width * 2 / 3

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UINavigationController *naVC;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (strong, nonatomic) NSMutableArray *rootViewNameArr;
@property (strong, nonatomic) UIView *rootView;
@property (nonatomic, assign) BOOL showLeft;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation ViewController

- (NSMutableArray *)rootViewNameArr
{
    if (_rootViewNameArr == nil) {
        _rootViewNameArr = [[NSMutableArray alloc] init];
        [_rootViewNameArr addObject:@"阅读"];
        [_rootViewNameArr addObject:@"电台"];
        [_rootViewNameArr addObject:@"话题"];
        [_rootViewNameArr addObject:@"良品"];
    }
    return _rootViewNameArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _showLeft = NO;
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    
    [self createViewController:0];
    
    self.tap = [[UITapGestureRecognizer alloc ]initWithTarget:self action:@selector(pushLeft)];
    [self.view addGestureRecognizer:self.tap];
    _tap.enabled = NO;
    self.tap.delegate = self;
}

// 根据传入的数值创建视图控制器
- (void)createViewController:(NSInteger)index
{
    BaseViewController *baseVC = nil;
    
    if (index == 0) {
        baseVC = [[ReadViewController alloc] init];
    } else if (index == 1) {
        baseVC = [[RadioViewController alloc] init];
    } else if (index == 2) {
        baseVC = [[TopicViewController alloc] init];
    } else if (index == 3) {
        baseVC = [[ProductViewController alloc] init];
    }
    
    self.naVC = [[UINavigationController alloc] initWithRootViewController:baseVC];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button setImage:[UIImage imageNamed:@"菜单"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushLeft) forControlEvents:UIControlEventTouchUpInside];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *navigativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    navigativeSpacer.width = -15;
    baseVC.navigationItem.leftBarButtonItems = @[navigativeSpacer, item];
    
    baseVC.barButtonTitle = self.rootViewNameArr[index];
    
    [self.view addSubview:self.naVC.view];
}

// 推出左视图
- (void)pushLeft
{
    if (_showLeft) {
        [UIView animateWithDuration:0.3 animations:^{
            [self changeXTo:0];
        } completion:^(BOOL finished) {
            _showLeft = NO;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self changeXTo:kLeftWidth];
        } completion:^(BOOL finished) {
            _showLeft = YES;
        }];
    }
}

// 改变x轴坐标
- (void)changeXTo:(NSInteger)x
{
    if (x) {
        _tap.enabled = YES;
    } else {
        _tap.enabled = NO;
    }
    
    CGRect frame = self.naVC.view.frame;
    frame.origin.x = x;
    self.naVC.view.frame = frame;
}

#pragma mark - UIGestureRecognizer Delegate -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return CGRectContainsPoint(self.naVC.view.frame, [gestureRecognizer locationInView:self.view]);
}

#pragma mark - Table View Delegate & sourceData -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rootViewNameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.leftTableView dequeueReusableCellWithIdentifier:@"reuse"];
    
    cell.textLabel.text = self.rootViewNameArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.naVC.view removeFromSuperview];
    self.naVC = nil;
    [self createViewController:indexPath.row];
    
    [self changeXTo:kLeftWidth];
    [UIView animateWithDuration:0.3 animations:^{
        [self changeXTo:0];
    } completion:^(BOOL finished) {
        _showLeft = NO;
    }];
}
@end
