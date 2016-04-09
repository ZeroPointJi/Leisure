//
//  ReadCommontModelCell.h
//  Leisure
//
//  Created by zero on 16/4/8.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"
#import "ReadCommontModel.h"

@interface ReadCommontModelCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *unameLabel;
@property (nonatomic, strong) UILabel *addtime_fLabel;
@property (nonatomic, strong) UILabel *contentLabel;

+ (CGFloat)getHeightWithModel:(ReadCommontModel *)model;

@end
