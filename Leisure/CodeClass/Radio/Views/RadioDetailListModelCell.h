//
//  RadioDetailListModelCell.h
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface RadioDetailListModelCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicVisitLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
