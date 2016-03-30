//
//  ReadListModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"

@interface ReadListModel : BaseModel

@property (nonatomic, copy)NSString *coverimg; // 图片地址
@property (nonatomic, copy)NSString *name; // 主题
@property (nonatomic, copy)NSString *enname; // 副标题
@property (nonatomic, copy)NSString *type;


@end
