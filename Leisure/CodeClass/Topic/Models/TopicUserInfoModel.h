//
//  TopicUserInfoModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"

@interface TopicUserInfoModel : BaseModel

@property (nonatomic, copy) NSString *icon; // 用户图标
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *uname;

@end
