//
//  RadioListModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"
#import "RadioUserInfoModel.h"

@interface RadioListModel : BaseModel

@property (nonatomic, copy) NSString *count; // 收听次数
@property (nonatomic, copy) NSString *coverimg; // 图片地址
@property (nonatomic, copy) NSString *desc; // 内容简介
@property (nonatomic, assign) BOOL isNew; // 标记是否是最新
@property (nonatomic, copy) NSString *radioid; // 电台的id
@property (nonatomic, copy) NSString *title; // 标题

@property (nonatomic, strong) RadioUserInfoModel *userInfo; // 用户信息


@end
