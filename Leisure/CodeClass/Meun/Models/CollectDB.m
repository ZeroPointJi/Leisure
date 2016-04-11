//
//  CollectDB.m
//  Leisure
//
//  Created by zero on 16/4/11.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "CollectDB.h"
#import "DBManager.h"

@implementation CollectDB

- (instancetype)init
{
    if (self = [super init]) {
        self.db = [DBManager defaultDBManager].db;
        [self createTable];
    }
    return self;
}

// 创建表
- (void)createTable
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (readID INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, userID text, title text, contentID text, content text, name text, coverimg text)", COLLECTTABLE];
    BOOL result = [self.db executeUpdate:sql];
    if (result) {
        NSLog(@"创建成功");
    } else {
        NSLog(@"创建失败");
    }
}

// 插入模型
- (void)insertModel:(ReadDetailListModel *)model
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (userID,title,contentid,content, name, coverimg) values (?,?,?,?,?,?)", COLLECTTABLE];
    NSMutableArray *dataArr = [NSMutableArray array];
    [dataArr addObject:[UserInfoManager getUserID]];
    [dataArr addObject:model.title];
    [dataArr addObject:model.contentID];
    [dataArr addObject:model.content];
    [dataArr addObject:model.name];
    [dataArr addObject:model.coverimg];
    
    BOOL result = [self.db executeUpdate:sql values:dataArr error:nil];
    if (result) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
}

// 删除数据
- (void)deleteModel:(ReadDetailListModel *)model
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE title = '%@' AND userID = '%@'", COLLECTTABLE, model.title, [UserInfoManager getUserID]];
    BOOL result = [self.db executeUpdate:sql];
    if (result) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

// 查询所有数据
- (NSArray *)selectAllModel
{
    NSMutableArray *dataArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE userID = '%@'", COLLECTTABLE, [UserInfoManager getUserID]];
    FMResultSet *set = [self.db executeQuery:sql];
    while ([set next]) {
        ReadDetailListModel *model = [[ReadDetailListModel alloc] init];
        model.title = [set stringForColumn:@"title"];
        model.contentID = [set stringForColumn:@"contentid"];
        model.content = [set stringForColumn:@"content"];
        model.name = [set stringForColumn:@"name"];
        model.coverimg = [set stringForColumn:@"coverimg"];
        [dataArr addObject:model];
    }
    
    return dataArr;
}

@end
