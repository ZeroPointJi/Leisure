//
//  FactoryCollectionViewCell.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "FactoryCollectionViewCell.h"

@implementation FactoryCollectionViewCell

+ (BaseCollectionViewCell *)createCollectionViewCell:(BaseModel *)model andCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath
{
    NSString *modelClassName = NSStringFromClass([model class]);
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:modelClassName forIndexPath:indexPath];
    
    return cell;
}

@end
