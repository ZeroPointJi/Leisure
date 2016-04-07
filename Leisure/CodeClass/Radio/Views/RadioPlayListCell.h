//
//  RadioPlayListCell.h
//  Leisure
//
//  Created by zero on 16/4/7.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface RadioPlayListCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unameLabel;

@end
