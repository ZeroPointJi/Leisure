//
//  RadioListModelCell.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioListModelCell.h"
#import "RadioListModel.h"

@implementation RadioListModelCell

- (void)setData:(RadioListModel *)model
{
    NSURL *url = [NSURL URLWithString:model.coverimg];
    [self.coverImageView sd_setImageWithURL:url];
    
    self.titleLabel.text = model.title;
    
    self.userInfoLabel.text = [NSString stringWithFormat:@"by: %@", model.userInfo.uname];
    
    self.descLabel.text = model.desc;
    
    [self.countButton setTitle:[model.count stringValue] forState:UIControlStateNormal];
    [self.countButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}


@end
