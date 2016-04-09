//
//  KeyBoardView.h
//  Leisure
//
//  Created by 左建军 on 15/11/16.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KeyBoardView;
@protocol KeyBoardViewDelegate <NSObject>
//  键盘输入完成的协议方法
-(void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView;
@end

@interface KeyBoardView : UIView

@property (nonatomic,strong) UITextView *textView; // 输入框
@property (nonatomic,assign) id<KeyBoardViewDelegate> delegate;

@end
