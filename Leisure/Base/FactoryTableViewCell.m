//
//  FactoryTableViewCell.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "FactoryTableViewCell.h"

@implementation FactoryTableViewCell

+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)model
{
    // 1.将 model 类名转成字符串
    NSString *modelClassName = NSStringFromClass([model class]);
    // 2.获取要创建的 cell 的类名
    NSString *cellClassName = [modelClassName stringByAppendingString:@"Cell"];
    // 3.获取 cell 类
    Class cellClass = NSClassFromString(cellClassName);
    // 4.创建 cell 对象
    BaseTableViewCell *cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
    
    return cell;
}

+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)model withTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    // 1.将 model 类名转成字符串
    NSString *modelClassName = NSStringFromClass([model class]);
    // 2.从 TableView 中获取 Cell
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:modelClassName forIndexPath:indexPath];
    
    return cell;
}

@end
