//
//  ICDPopup.h
//  cloudoor
//
//  Created by wenky on 15/11/12.
//  Copyright (c) 2015年 Cloudoor Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICDPopup : UIView

+ (instancetype)popupWithContentView:(UIView *)contentView;

- (void)showAtCenter:(CGPoint)center startPoint:(CGPoint)startPoin inView:(UIView *)inView animation:(BOOL)animation;

- (void)dismiss:(BOOL)animation;

@end

@interface UIView (ICDPopup)

- (void)dismissPresentingICDPopup;

@end