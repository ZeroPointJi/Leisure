//
//  RadioInfoModel.h
//  Leisure
//
//  Created by zero on 16/4/6.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"
#import "RadioUserInfoModel.h"

@interface RadioInfoModel : BaseModel

@property (nonatomic, copy) NSString *coverimg;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSNumber *musicvisitnum;
@property (nonatomic, copy) NSString *radioid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) RadioUserInfoModel *userinfo;

@end
