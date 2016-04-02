//
//  RadioDetailListModel.h
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"

@interface RadioDetailListModel : BaseModel

@property (nonatomic, copy) NSString *coverimg; // 图片
@property (nonatomic, assign) BOOL isnew; // 是否为新
@property (nonatomic, copy) NSString *musicUrl; // 音乐链接
@property (nonatomic, copy) NSString *musicVisit; // 音乐播放次数
@property (nonatomic, strong) NSDictionary *playInfo;
@property (nonatomic, copy) NSString *tingid;
@property (nonatomic, copy) NSString *title; // 标题

@end
