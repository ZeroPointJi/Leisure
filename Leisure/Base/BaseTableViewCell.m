//
//  BaseTableViewCell.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseTableViewCell.h"

static BOOL isDouble;

@implementation BaseTableViewCell

- (void)setData:(BaseModel *)model
{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    if (isDouble) {
        isDouble = NO;
    } else {
        isDouble = YES;
        self.backgroundColor = [UIColor colorWithRed:5 green:5 blue:5 alpha:5];
    }
}

@end
