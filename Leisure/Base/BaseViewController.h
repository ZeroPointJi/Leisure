//
//  BaseViewController.h
//  Drawer
//
//  Created by zero on 16/3/28.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, copy) NSString *barButtonTitle;
@property (nonatomic, strong) NSMutableArray *registFirstResponseArray;

- (void)createBackButton;

- (void)back;

@end
