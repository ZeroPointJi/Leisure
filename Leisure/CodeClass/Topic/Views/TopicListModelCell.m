//
//  TopicListModelCell.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "TopicListModelCell.h"

@implementation TopicListModelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.hotImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_hotImage];
        
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
        self.hotImage.image = [UIImage imageNamed:@"jing"];
        //self.hotLabel.text = @"精";
        //self.hotLabel.textColor = [UIColor grayColor];
        //self.hotLabel.font = [UIFont boldSystemFontOfSize:17];
        //self.hotLabel.textAlignment = NSTextAlignmentCenter;
        //self.hotLabel.layer.masksToBounds = YES;
        //self.hotLabel.layer.borderWidth = 1;
        //self.hotLabel.layer.borderColor = [UIColor grayColor].CGColor;
        //self.hotLabel.layer.cornerRadius = 5;
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
    self.contentLabel.numberOfLines = 0;
    
    self.addtime_fLabel.text = model.addtime_f;
    self.addtime_fLabel.textColor = [UIColor grayColor];
    
    [self.commononButton setImage:[UIImage imageNamed:@"评论1"] forState:UIControlStateNormal];
    
    self.likecountLabel.text = [model.counter.like stringValue];
    self.likecountLabel.textAlignment = NSTextAlignmentRight;
    self.likecountLabel.textColor = [UIColor grayColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat ishotX = 20;
    CGFloat ishotY = 20;
    CGFloat ishotWidth = 0;
    if (_ishot) {
        ishotWidth = 30;
        self.hotImage.frame = CGRectMake(ishotX, ishotY, ishotWidth, ishotWidth);
    }
    
    CGFloat titleX = ishotX + ishotWidth + (_ishot ? 10 : 0);
    CGFloat titleY = 25;
    CGFloat titleWidth = ScreenWidth - titleX - 20;
    CGFloat titleHeight = [TopicListModelCell autoHeightWithFont:_titleLabel.font text:_titleLabel.text labelWidth:titleWidth];
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
    CGFloat contentHeight = [TopicListModelCell autoHeightWithFont:_contentLabel.font text:_contentLabel.text labelWidth:contentWidth];
    self.contentLabel.frame = CGRectMake(contentX, contentY, contentWidth, contentHeight);
    
    CGFloat addtime_fX = 20;
    CGFloat addtime_fY = contentY + (_hasCoverImage ? (coverWidth > contentHeight ? coverWidth : contentHeight): contentHeight) + 20;
    CGFloat addtime_fWidth = 100;
    CGFloat addtime_fHeight = [TopicListModelCell autoHeightWithFont:_addtime_fLabel.font text:_addtime_fLabel.text labelWidth:addtime_fWidth];
    self.addtime_fLabel.frame = CGRectMake(addtime_fX, addtime_fY, addtime_fWidth, addtime_fHeight);
    
    CGFloat likeWidth = 40;
    CGFloat likeHeight = addtime_fHeight;
    CGFloat likeX = ScreenWidth - likeWidth - 20;
    CGFloat likeY = addtime_fY;
    self.likecountLabel.frame = CGRectMake(likeX, likeY, likeWidth, likeHeight);
    
    CGFloat buttonWidth = 29;
    CGFloat buttonHeight = 28;
    CGFloat buttonX = likeX - 10 - buttonWidth;
    CGFloat buttonY = likeY - 3;
    self.commononButton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
}

+ (CGFloat)autoHeightWithFont:(UIFont *)font text:(NSString *)text labelWidth:(CGFloat)labelWidth
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(labelWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size.height;
    
    return height;
}

+ (CGFloat)getHeight:(TopicListModel *)model
{
    BOOL ishot = model.ishot;
    BOOL hasCoverImg = [model.coverimg length];
    
    CGFloat ishotX = 20;
    CGFloat ishotWidth = 0;
    if (ishot) {
        ishotWidth = 30;
    }
    
    CGFloat titleX = ishotX + ishotWidth + (ishot ? 10 : 0);
    CGFloat titleY = 25;
    CGFloat titleWidth = ScreenWidth - titleX - 20;
    CGFloat titleHeight = [TopicListModelCell autoHeightWithFont:[UIFont boldSystemFontOfSize:20] text:model.title labelWidth:titleWidth];
    
    CGFloat coverX = 20;
    CGFloat coverY = titleY + titleHeight + 20;
    CGFloat coverWidth = 0;
    if ([model.coverimg length]) {
        coverX = 20;
        coverWidth = 60;
    }
    
    CGFloat contentX = coverX + coverWidth + (hasCoverImg ? 10 : 0);
    CGFloat contentY = coverY;
    CGFloat contentWidth = ScreenWidth - contentX - 20;
    CGFloat contentHeight = [TopicListModelCell autoHeightWithFont:[UIFont systemFontOfSize:15] text:model.content labelWidth:contentWidth];
    //< 17.900391 * 3 ? [TopicListModelCell autoHeightWithFont:[UIFont systemFontOfSize:15] text:model.content labelWidth:contentWidth] : 17.900391 * 3;
    
    CGFloat addtime_fY = contentY + (hasCoverImg ? (coverWidth > contentHeight ? coverWidth : contentHeight): contentHeight) + 20;
    
    CGFloat likeY = addtime_fY;
    
    CGFloat buttonHeight = 28;
    CGFloat buttonY = likeY - 3;
    
    return buttonY + buttonHeight + 20;
}

@end
