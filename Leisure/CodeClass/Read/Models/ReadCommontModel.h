//
//  ReadCommontModel.h
//  Leisure
//
//  Created by zero on 16/4/8.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"
#import "ReadUserInfoModel.h"

@interface ReadCommontModel : BaseModel

@property (nonatomic, copy) NSString *addtime_f;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *contentid;
@property (nonatomic, assign) BOOL isdel;
@property (nonatomic, strong) NSDictionary *reuserinfo;
@property (nonatomic, strong) ReadUserInfoModel *userinfoModel;

@end
