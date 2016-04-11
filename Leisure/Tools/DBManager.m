//
//  DBManager.m
//  Leisure
//
//  Created by zero on 16/4/11.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "DBManager.h"

static DBManager *dbManager;

@implementation DBManager

+ (instancetype)defaultDBManager
{
    @synchronized (self) {
        if (!dbManager) {
            dbManager = [[DBManager alloc] init];
        }
    }
    return dbManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [docPath stringByAppendingPathComponent:DATABASENAME];
        
        [self openDB:dbPath];
    }
    
    return self;
}

- (void)openDB:(NSString *)dbPath
{
    if (!_db) {
        _db = [FMDatabase databaseWithPath:dbPath];
    }
    if (![_db open]) {
        NSLog(@"打开数据库失败");
    }
}

- (void)dealloc
{
    [_db close];
    _db = nil;
}

@end