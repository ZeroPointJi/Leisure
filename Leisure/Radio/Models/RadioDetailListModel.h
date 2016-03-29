//
//  RadioDetailListModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"

@interface RadioDetailListModel : BaseModel

@property (nonatomic, copy) NSString *coverimg;
@property (nonatomic, assign) BOOL isnew;
@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, strong) NSNumber *musicVisit;
@property (nonatomic, strong) NSDictionary *playInfo;
@property (nonatomic, copy) NSString *tingid;
@property (nonatomic, copy) NSString *title;

@end
