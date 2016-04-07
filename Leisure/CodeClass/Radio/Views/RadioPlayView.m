//
//  RadioPlayView.m
//  Leisure
//
//  Created by zero on 16/4/6.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioPlayView.h"
#import "PlayerManager.h"

@implementation RadioPlayView

- (void)setData:(RadioPlayInfoModel *)model
{
    NSURL *url = [NSURL URLWithString:model.imgUrl];
    [self.imageView sd_setImageWithURL:url];
    
    self.titleLabel.text = model.title;
    
    [_programeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    [[PlayerManager defaultManager] seekToNewTime:slider.value];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;
    _imageView.layer.masksToBounds = YES;
}

@end
