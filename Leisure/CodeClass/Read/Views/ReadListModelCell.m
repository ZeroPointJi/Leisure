//
//  ReadListModelCell.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadListModelCell.h"
#import "ReadListModel.h"

@implementation ReadListModelCell

- (void)setDataWithModel:(ReadListModel *)model
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", model.name, model.enname];
    self.nameLabel.textColor = [UIColor whiteColor];
    
    NSURL *url = [NSURL URLWithString:model.coverimg];
    [self.coverImageView sd_setImageWithURL:url];
}

@end
