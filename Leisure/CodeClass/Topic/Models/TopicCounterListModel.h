//
//  TopicCounterListModel.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseModel.h"

@interface TopicCounterListModel : BaseModel

@property (nonatomic, copy) NSString *comment;  // 评论次数
@property (nonatomic, copy) NSString *like; //喜欢次数
@property (nonatomic, copy) NSString *view; // 查看次数

@end
