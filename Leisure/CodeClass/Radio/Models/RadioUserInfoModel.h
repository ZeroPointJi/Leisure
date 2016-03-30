//
//  RadioUserInfoModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"

@interface RadioUserInfoModel : BaseModel

@property (nonatomic, copy) NSString *icon; //头像地址
@property (nonatomic, copy) NSString *uid; // 用户id
@property (nonatomic, copy) NSString *uname; // 用户名

@end
