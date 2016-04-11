//
//  DBManager.h
//  Leisure
//
//  Created by zero on 16/4/11.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)defaultDBManager;

@end
