//
//  BaseCollectionViewCell.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface BaseCollectionViewCell : UICollectionViewCell

- (void)setDataWithModel:(BaseModel *)model;

@end
