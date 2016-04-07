//
//  RadioPlayViewController.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "PlayerManager.h"

#import "RadioPlayViewController.h"
#import "RadioPlayView.h"
#import "RadioDetailListModel.h"
#import "BaseTableViewCell.h"
#import "RadioPlayListCell.h"

@interface RadioPlayViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PlayerManager *playerManager;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; // 滚动视图
@property (nonatomic, strong) RadioPlayView *radioPlayView; // 播放器页面
@property (nonatomic, strong) UITableView *radioPlayListView; // 播放列表
@property (nonatomic, strong) UIWebView *radioWebView; // 网络视图

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *startAndPauseButton;

@end

@implementation RadioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createScrollView];
    
    [self createPageControl];
    
    [self createRadioPlayView];
    
    [self createRadioPlayListView];
    
    [self createRadioWebView];
    
    [self playMusic];
    
    [self updateView];
}

// 创建滚动视图
- (void)createScrollView
{
    _scrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    
    [self.view addSubview:_scrollView];
}

// 创建页面控制器
- (void)createPageControl
{
    _startAndPauseButton.selected = YES;
    
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 1;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.userInteractionEnabled = NO;
    
    [self.view addSubview:_pageControl];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
}


// 计时器方法
- (void)playing
{
    self.radioPlayView.programeSlider.value++;
    self.radioPlayView.programeSlider.minimumValue = 0;
    self.radioPlayView.programeSlider.maximumValue = [_playerManager totalTime];
    
    CGFloat currentime = _playerManager.totalTime - _playerManager.currentTime - 0.5;
    _radioPlayView.currentimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)currentime / 60, (int)currentime % 60];
    
    if (_playerManager.currentTime == [_playerManager totalTime] && _playerManager.totalTime != 0) {
        [self nextMusic:nil];
    }
}

// 创建播放界面
- (void)createRadioPlayView
{
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"RadioPlayView" owner:nil options:nil];
    self.radioPlayView = [viewArr lastObject];
    self.radioPlayView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 2 * 64);
    
    _radioPlayView.currentimeLabel.text = @"00:00";
    
    [self.scrollView addSubview:_radioPlayView];
}

// 创建播放列表
- (void)createRadioPlayListView
{
    self.radioPlayListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight - 2 * 64 - 45) style:UITableViewStylePlain];
    _radioPlayListView.delegate = self;
    _radioPlayListView.dataSource = self;
    
    [_radioPlayListView registerNib:[UINib nibWithNibName:@"RadioPlayListCell" bundle:nil] forCellReuseIdentifier:@"RadioPlayListCell"];
    
    
    [_scrollView addSubview:_radioPlayListView];
}

// 创建网络页面
- (void)createRadioWebView
{
    self.radioWebView = [[UIWebView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 45, ScreenWidth, ScreenHeight - 2 * 64 - 45)];
    _radioWebView.scrollView.bounces = NO;
    
    [self.scrollView addSubview:_radioWebView];
}

// 播放音乐
- (void)playMusic
{
    _playerManager = [PlayerManager defaultManager];
    
    _playerManager.playIndex = _selectIndex;
    
    NSMutableArray *musicArray = [NSMutableArray array];
    for (RadioDetailListModel *detailListModel in _detailListArray) {
        [musicArray addObject: detailListModel.musicUrl];
    }
    _playerManager.musicArray = musicArray;
    
    [_playerManager play];
    
    // 创建计时器对象，在计时器方法中获取播放的时长
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(playing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

// 更新视图
- (void)updateView
{
    self.radioPlayView.programeSlider.value = 0;
    self.radioPlayView.programeSlider.minimumValue = 0;
    self.radioPlayView.programeSlider.maximumValue = [_playerManager totalTime];
    
    RadioDetailListModel *model = _detailListArray[_selectIndex];
    [_radioPlayView setData:model.playinfoModel];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectIndex inSection:0];
    [_radioPlayListView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
    RadioPlayListCell *cell = [_radioPlayListView cellForRowAtIndexPath:indexPath];
    cell.maskView.backgroundColor = [UIColor grayColor];
    
    NSString *urlString = model.playinfoModel.webview_url;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_radioWebView loadRequest:request];
}

// 暂停或继续
- (IBAction)startAndPause:(UIButton *)sender {
    if ([_playerManager playerState] == playerStatePlay) {
        [_playerManager pause];
        self.startAndPauseButton.selected = NO;
    } else {
        [_playerManager play];
        self.startAndPauseButton.selected = YES;
    }
}

// 下一首
- (IBAction)nextMusic:(UIButton *)sender {
    _selectIndex = (_selectIndex + 1 == _detailListArray.count) ? 0 : (_selectIndex + 1);
    [self ChangeMusic];
}

// 上一首
- (IBAction)preMusic:(UIButton *)sender {
    _selectIndex = (_selectIndex == 0) ? (_detailListArray.count - 1) : (_selectIndex - 1);
    [self ChangeMusic];
}

- (void)ChangeMusic
{
    [self updateView];
    [_playerManager changeMusicWithIndex:_selectIndex];
    self.startAndPauseButton.selected = YES;
}

#pragma mark - Scroll View Delegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = offsetX / ScreenWidth + 0.5;
    _pageControl.currentPage = page;
}

#pragma mark - Table View Delegate & Datasource -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell *cell = [_radioPlayListView dequeueReusableCellWithIdentifier:@"RadioPlayListCell" forIndexPath:indexPath];
    BaseModel *model = _detailListArray[indexPath.row];
    
    [cell setData:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    [self ChangeMusic];
}

@end
