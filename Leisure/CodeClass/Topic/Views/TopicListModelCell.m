//
//  TopicListModelCell.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "TopicListModelCell.h"
#import "TopicListModel.h"

@implementation TopicListModelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.hotLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_hotLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        
        self.coverImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverImageView];
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_contentLabel];
        
        self.addtime_fLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_addtime_fLabel];
        
        self.commononButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_commononButton];
        
        self.likecountLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_likecountLabel];
        
    }
    return self;
}

- (void)setData:(TopicListModel *)model
{
    self.ishot = model.ishot;
    if (model.ishot) {
        self.hotLabel.text = @"精";
        self.hotLabel.textColor = [UIColor grayColor];
        self.hotLabel.font = [UIFont boldSystemFontOfSize:17];
        self.hotLabel.textAlignment = NSTextAlignmentCenter;
        self.hotLabel.layer.masksToBounds = YES;
        self.hotLabel.layer.borderWidth = 1;
        self.hotLabel.layer.borderColor = [UIColor grayColor].CGColor;
        self.hotLabel.layer.cornerRadius = 5;
    }
    
    self.titleLabel.text = model.title;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.numberOfLines = 2;
    
    self.hasCoverImage = [model.coverimg length];
    if (_hasCoverImage) {
        NSURL *url = [NSURL URLWithString:model.coverimg];
        [self.coverImageView sd_setImageWithURL:url];
    }
    
    self.contentLabel.text = model.content;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines = 3;
    
    self.addtime_fLabel.text = model.addtime_f;
    self.addtime_fLabel.textColor = [UIColor grayColor];
    
    [self.commononButton setImage:[UIImage imageNamed:@"u40"] forState:UIControlStateNormal];
    
    self.likecountLabel.text = [model.counter.like stringValue];
    self.likecountLabel.textAlignment = NSTextAlignmentRight;
    self.likecountLabel.textColor = [UIColor grayColor];
}

- (void)layoutSubviews
{
    CGFloat ishotX = 20;
    CGFloat ishotY = 25;
    CGFloat ishotWidth = 0;
    if (_ishot) {
        ishotWidth = 30;
        self.hotLabel.frame = CGRectMake(ishotX, ishotY, ishotWidth, ishotWidth);
    }
    
    
    CGFloat titleX = ishotX + ishotWidth + (_ishot ? 10 : 0);
    CGFloat titleY = 25;
    CGFloat titleWidth = ScreenWidth - titleX - 20;
    CGFloat titleHeight = [self autoHeightWithLabel:self.titleLabel labelWidth:titleWidth];
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleWidth, titleHeight);
    
    CGFloat coverX = 20;
    CGFloat coverY = titleY + titleHeight + 20;
    CGFloat coverWidth = 0;
    if (_hasCoverImage) {
        coverX = 20;
        coverWidth = 60;
        self.coverImageView.frame = CGRectMake(coverX, coverY, coverWidth, coverWidth);
    }
    
    CGFloat contentX = coverX + coverWidth + (_hasCoverImage ? 10 : 0);
    CGFloat contentY = coverY;
    CGFloat contentWidth = ScreenWidth - contentX - 20;
    CGFloat contentHeight = 60;
    self.contentLabel.frame = CGRectMake(contentX, contentY, contentWidth, contentHeight);
    
    CGFloat addtime_fX = 20;
    CGFloat addtime_fY = contentY + (coverWidth ? coverWidth : contentHeight) + 20;
    CGFloat addtime_fWidth = 100;
    CGFloat addtime_fHeight = [self autoHeightWithLabel:self.addtime_fLabel labelWidth:addtime_fWidth];
    self.addtime_fLabel.frame = CGRectMake(addtime_fX, addtime_fY, addtime_fWidth, addtime_fHeight);
    
    CGFloat likeWidth = 40;
    CGFloat likeHeight = addtime_fHeight;
    CGFloat likeX = ScreenWidth - likeWidth - 20;
    CGFloat likeY = addtime_fY;
    self.likecountLabel.frame = CGRectMake(likeX, likeY, likeWidth, likeHeight);
    
    CGFloat buttonWidth = 46;
    CGFloat buttonHeight = 38;
    CGFloat buttonX = likeX - 10 - buttonWidth;
    CGFloat buttonY = likeY - 3;
    self.commononButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
}

- (CGFloat)autoHeightWithLabel:(UILabel *)label labelWidth:(CGFloat)labelWidth
{
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    CGFloat height = [label.text boundingRectWithSize:CGSizeMake(labelWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size.height;
    
    return height;
}

@end
