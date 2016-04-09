//
//  ReadCommontModelCell.m
//  Leisure
//
//  Created by zero on 16/4/8.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadCommontModelCell.h"

@implementation ReadCommontModelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
        
        self.unameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_unameLabel];
        
        self.addtime_fLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_addtime_fLabel];
        
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_contentLabel];
    }
    
    return self;
}

- (void)setData:(ReadCommontModel *)model
{
    NSURL *url = [NSURL URLWithString:model.userinfoModel.icon];
    [_iconImageView sd_setImageWithURL:url];
    _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
    _iconImageView.layer.masksToBounds = YES;
    
    _unameLabel.text = model.userinfoModel.uname;
    
    _addtime_fLabel.text = model.addtime_f;
    _addtime_fLabel.font = [UIFont systemFontOfSize:13];
    _addtime_fLabel.textColor = [UIColor grayColor];
    
    _contentLabel.text = model.content;
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:17];
}

    
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    CGFloat iconX = 20;
    CGFloat iconY = 15;
    CGFloat iconW = 50;
    _iconImageView.frame = CGRectMake(iconX, iconY, iconW, iconW);
    
    CGFloat unameX = iconX + iconW + 10;
    CGFloat unameY = iconY;
    CGFloat unameW = ScreenWidth - unameX - 20;
    CGFloat unameH = 20;
    _unameLabel.frame = CGRectMake(unameX, unameY, unameW, unameY);
    
    CGFloat timeX = unameX;
    CGFloat timeY = unameY + unameH + 10;
    CGFloat timeW = unameW;
    CGFloat timeH = unameH;
    _addtime_fLabel.frame = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat contentX = iconX;
    CGFloat contentY = iconY + iconW + 20;
    CGFloat contentW = ScreenWidth - contentX - 20;
    CGFloat contentH = [ReadCommontModelCell autoHeightWithFont:_contentLabel.font text:_contentLabel.text labelWidth:contentW];
    _contentLabel.frame = CGRectMake(contentX, contentY, contentW, contentH);
}

+ (CGFloat)getHeightWithModel:(ReadCommontModel *)model
{
    CGFloat iconX = 20;
    CGFloat iconY = 15;
    CGFloat iconW = 50;
    
    CGFloat contentX = iconX;
    CGFloat contentY = iconY + iconW + 20;
    CGFloat contentW = ScreenWidth - contentX - 20;
    CGFloat contentH = [ReadCommontModelCell autoHeightWithFont:[UIFont systemFontOfSize:17] text:model.content    labelWidth:contentW];
    
    return contentY + contentH + 10;
}

+ (CGFloat)autoHeightWithFont:(UIFont *)font text:(NSString *)text labelWidth:(CGFloat)labelWidth
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(labelWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size.height;
    
    return height;
}

@end
