//
//  RadioPlayInfoModel.m
//  Leisure
//
//  Created by zero on 16/4/6.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioPlayInfoModel.h"

@implementation RadioPlayInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"userinfo"]) {
        RadioUserInfoModel *userinfoModel = [[RadioUserInfoModel alloc] init];
        [userinfoModel setValuesForKeysWithDictionary:value];
        self.userinfoModel = userinfoModel;
    }
}

@end
