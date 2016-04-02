//
//  FactoryTableViewCell.h
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTableViewCell.h"

@interface FactoryTableViewCell : NSObject

+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)model;

+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)model withTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
