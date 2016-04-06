//
//  RadioPlayView.h
//  Leisure
//
//  Created by zero on 16/4/6.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioPlayInfoModel.h"

@interface RadioPlayView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *programeSlider;

- (void)setData:(RadioPlayInfoModel *)model;

@end
