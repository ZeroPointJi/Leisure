//
//  ReadDetailListModel.m
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ReadDetailListModel.h"

@implementation ReadDetailListModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.contentID = value;
    }
}


@end







