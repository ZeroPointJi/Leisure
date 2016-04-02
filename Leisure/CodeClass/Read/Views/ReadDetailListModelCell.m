//
//  ReadDetailListModelCell.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadDetailListModelCell.h"
#import "ReadDetailListModel.h"
#import "UIImageView+WebCache.h"

@implementation ReadDetailListModelCell

- (void)setData:(ReadDetailListModel *)model
{
    _titleLabel.text = model.title;
    
    NSURL *url = [NSURL URLWithString:model.coverimg];
    [_coverImageView sd_setImageWithURL:url];
    
    _contentLabel.text = model.content;
}

@end
