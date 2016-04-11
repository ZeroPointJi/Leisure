//
//  CollectDB.h
//  Leisure
//
//  Created by zero on 16/4/11.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadDetailListModel.h"

@interface CollectDB : NSObject

@property (nonatomic, strong) FMDatabase *db;

// 插入模型
- (void)insertModel:(ReadDetailListModel *)model;

// 删除模型
- (void)deleteModel:(ReadDetailListModel *)model;

// 查询所有模型
- (NSArray *)selectAllModel;

@end
