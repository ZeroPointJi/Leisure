//
//  ProductListModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"

@interface ProductListModel : BaseModel

@property (nonatomic, copy) NSString *buyurl; // 购买地址
@property (nonatomic, copy) NSString *coverimg; // 图片地址
@property (nonatomic, copy) NSString *contentid; // 商品id
@property (nonatomic, copy) NSString *title; // 标题

@end
