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

@interface RadioPlayViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) PlayerManager *playerManager;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) RadioPlayView *radioPlayView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIButton *startAndPauseButton; // 开始暂停按钮

@end

@implementation RadioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self preview];
    
    [self playMusic];
    
    [self createScrollView];
    
    [self createRadioPlayView];
}

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

- (void)playing
{
    self.radioPlayView.programeSlider.value++;
    self.radioPlayView.programeSlider.minimumValue = 0;
    self.radioPlayView.programeSlider.maximumValue = [_playerManager totalTime];
    
    CGFloat currentime = _playerManager.totalTime - _playerManager.currentTime - 0.5;
    _radioPlayView.currentimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)currentime / 60, (int)currentime % 60];
    
    if (self.radioPlayView.programeSlider.value == [_playerManager totalTime] && _playerManager.totalTime != 0) {
        [self nextMusic:nil];
    }
}

- (void)preview
{
    _startAndPauseButton.selected = YES;
    
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    [self.view addSubview:_pageControl];
}

- (void)createScrollView
{
    _scrollView.contentSize = CGSizeMake(ScreenWidth * 4, _scrollView.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
}

- (void)createRadioPlayView
{
    if (!_radioPlayView.superview) {
        NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"RadioPlayView" owner:nil options:nil];
        self.radioPlayView = [viewArr lastObject];
    }
    
    self.radioPlayView.programeSlider.value = 0;
    self.radioPlayView.programeSlider.minimumValue = 0;
    self.radioPlayView.programeSlider.maximumValue = [_playerManager totalTime];
    [self.radioPlayView.programeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    RadioDetailListModel *model = _detailListArray[_selectIndex];
    [_radioPlayView setData:model.playinfoModel];
    
    CGFloat currentime = _playerManager.totalTime - _playerManager.currentTime;
    _radioPlayView.currentimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(currentime / 60), (int)currentime % 60];
    
    [self.scrollView addSubview:_radioPlayView];
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
    [_playerManager stop];
    [_playerManager nextMusic];
    _selectIndex = (_selectIndex + 1 == _detailListArray.count) ? 0 : (_selectIndex + 1);
    [self createRadioPlayView];
    self.startAndPauseButton.selected = YES;
}

// 上一首
- (IBAction)preMusic:(UIButton *)sender {
    [_playerManager stop];
    [_playerManager lastMusic];
    _selectIndex = (_selectIndex == 0) ? (_detailListArray.count - 1) : (_selectIndex - 1);
    [self createRadioPlayView];
    self.startAndPauseButton.selected = YES;
}

- (void)sliderValueChanged:(UISlider *)slider
{
    [_playerManager seekToNewTime:slider.value];
}

#pragma mark - Scroll View Delegate -



@end
