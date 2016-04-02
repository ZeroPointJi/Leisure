//
//  TopicListModelCell.h
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface TopicListModelCell : BaseTableViewCell

@property (nonatomic, assign) BOOL ishot;
@property (nonatomic, assign) BOOL hasCoverImage;

@property (strong, nonatomic) UILabel *hotLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *addtime_fLabel;
@property (strong, nonatomic) UIButton *commononButton;
@property (strong, nonatomic) UILabel *likecountLabel;

@end
