//
//  ReadInfoViewController.h
//  Leisure
//
//  Created by zero on 16/3/29.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "BaseViewController.h"
#import "ReadDetailListModel.h"

@interface ReadInfoViewController : BaseViewController

@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, strong) ReadDetailListModel *model;

@end
