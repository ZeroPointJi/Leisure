//
//  TopicListModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"
#import "TopicCounterListModel.h"
#import "TopicUserInfoModel.h"

@interface TopicListModel : BaseModel

@property (nonatomic, copy) NSString *addtime; // 时间戳
@property (nonatomic, copy) NSString *addtime_f; // 时间间隔
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, copy) NSString *contentid; // 话题的id
@property (nonatomic, copy) NSString *coverimg; // 图片地址
@property (nonatomic, copy) NSString *title; // 标题

@property (nonatomic, assign) BOOL ishot;

@property (nonatomic, strong) TopicCounterListModel *counter; // 计数对象
@property (nonatomic, strong) TopicUserInfoModel *userInfo; // 用户信息




@end



