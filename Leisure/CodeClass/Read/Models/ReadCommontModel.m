//
//  ReadCommontModel.m
//  Leisure
//
//  Created by zero on 16/4/8.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadCommontModel.h"

@implementation ReadCommontModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"userinfo"]) {
        ReadUserInfoModel *model = [[ReadUserInfoModel alloc] init];
        [model setValuesForKeysWithDictionary:value];
        self.userinfoModel = model;
    }
}

@end
