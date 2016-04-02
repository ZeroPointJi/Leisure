//
//  ReadListModelCell.h
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@interface ReadListModelCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
