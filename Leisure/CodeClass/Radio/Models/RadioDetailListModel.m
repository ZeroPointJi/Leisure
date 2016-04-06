//
//  RadioDetailListModel.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "RadioDetailListModel.h"

@implementation RadioDetailListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"playInfo"]) {
        RadioPlayInfoModel *playinfoModel = [[RadioPlayInfoModel alloc] init];
        [playinfoModel setValuesForKeysWithDictionary:value];
        self.playinfoModel = playinfoModel;
    }
}

@end
