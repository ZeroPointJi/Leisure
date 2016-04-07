//
//  RadioPlayListCell.m
//  Leisure
//
//  Created by zero on 16/4/7.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioPlayListCell.h"
#import "RadioDetailListModel.h"

@implementation RadioPlayListCell

- (void)setData:(RadioDetailListModel *)model
{
    self.titleLabel.text = model.title;
    
    NSString *uname = model.playinfoModel.userinfoModel.uname;
    self.unameLabel.text = [NSString stringWithFormat:@"by: %@", uname];
    
    if (self.selected) {
        _maskView.backgroundColor = [UIColor grayColor];
    } else {
        _maskView.backgroundColor = [UIColor whiteColor];
    }
}

@end
