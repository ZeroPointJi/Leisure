//
//  BaseTableViewCell.h
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface BaseTableViewCell : UITableViewCell

- (void)setData:(BaseModel *)model;

@end
