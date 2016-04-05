//
//  RadioDetailListHeaderView.h
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioListModel.h"

@interface RadioDetailListHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *counterButton;

- (void)setData:(RadioListModel *)model;

@end
