//
//  RadioDetailListModelCell.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioDetailListModelCell.h"
#import "RadioDetailListModel.h"

@implementation RadioDetailListModelCell

- (void)setData:(RadioDetailListModel *)model
{
    NSURL *url = [NSURL URLWithString:model.coverimg];
    [self.coverImageView sd_setImageWithURL:url];
    
    self.titleLabel.text = model.title;
    
    self.musicVisitLabel.text = model.musicVisit;
}

@end
