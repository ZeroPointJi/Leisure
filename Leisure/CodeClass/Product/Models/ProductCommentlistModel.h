//
//  ProductCommentlistModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"
#import "ProductUserInfoModel.h"

@interface ProductCommentlistModel : BaseModel

@property (nonatomic, copy) NSString *addtime_f; // 评论的时间
@property (nonatomic, copy) NSString *content; // 评论内容
@property (nonatomic, copy) NSString *contentid; // 评论的id

@property (nonatomic, strong) ProductUserInfoModel *userInfo; // 评论的用户信息

@end





