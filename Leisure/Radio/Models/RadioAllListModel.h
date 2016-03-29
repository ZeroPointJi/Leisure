//
//  RadioAllListModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"

@interface RadioAllListModel : BaseModel

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, copy) NSString *coverimg;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) BOOL isnew;
@property (nonatomic, copy) NSString *radioid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSDictionary *userinfo;

@end
