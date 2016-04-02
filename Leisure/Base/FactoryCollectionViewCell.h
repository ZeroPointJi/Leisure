//
//  FactoryCollectionViewCell.h
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCollectionViewCell.h"
#import "BaseModel.h"

@interface FactoryCollectionViewCell : NSObject

+ (BaseCollectionViewCell *)createCollectionViewCell:(BaseModel *)model andCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath;

@end
