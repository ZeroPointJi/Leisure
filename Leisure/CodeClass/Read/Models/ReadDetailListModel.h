//
//  ReadDetailListModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"

@interface ReadDetailListModel : BaseModel

@property (nonatomic, copy)NSString *content; // 内容简介
@property (nonatomic, copy)NSString *coverimg; // 图片地址
@property (nonatomic, copy)NSString *contentID;  // 文章的id
@property (nonatomic, copy)NSString *name; // 主题
@property (nonatomic, copy)NSString *title; // 文章的标题

@end
