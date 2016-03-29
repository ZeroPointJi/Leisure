//
//  ReadListModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"

@interface ReadListModel : BaseModel

@property (nonatomic, copy) NSString *coverimg;
@property (nonatomic, copy) NSString *enname;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *type;

@end
