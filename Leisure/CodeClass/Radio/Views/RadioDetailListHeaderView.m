//
//  RadioDetailListHeaderView.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioDetailListHeaderView.h"

@implementation RadioDetailListHeaderView

- (void)setData:(RadioListModel *)model
{
    NSURL *url = [NSURL URLWithString:model.coverimg];
    [self.coverImageView sd_setImageWithURL:url];
    _coverImageView.layer.cornerRadius = _coverImageView.frame.size.height / 2;
    
    self.titleLabel.text = model.title;
    
    self.descLabel.text = model.desc;
    
    [self.counterButton setTitle:[model.count stringValue]forState:UIControlStateNormal];
    [self.counterButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.counterButton.userInteractionEnabled = NO;
}

@end
