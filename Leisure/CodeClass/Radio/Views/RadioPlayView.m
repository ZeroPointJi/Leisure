//
//  RadioPlayView.m
//  Leisure
//
//  Created by zero on 16/4/6.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioPlayView.h"

@implementation RadioPlayView

- (void)setData:(RadioPlayInfoModel *)model
{
    NSURL *url = [NSURL URLWithString:model.imgUrl];
    _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;
    [self.imageView sd_setImageWithURL:url];
    
    self.titleLabel.text = model.title;
}

@end
