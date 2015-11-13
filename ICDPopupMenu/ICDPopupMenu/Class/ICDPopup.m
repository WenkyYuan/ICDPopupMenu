//
//  ICDPopup.m
//  cloudoor
//
//  Created by wenky on 15/11/12.
//  Copyright (c) 2015年 Cloudoor Technology Co.,Ltd. All rights reserved.
//

#import "ICDPopup.h"

@interface ICDPopup ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) BOOL dismissing;

@end
@implementation ICDPopup

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.userInteractionEnabled = YES;
        [self addSubview:_containerView];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self) {
        [self dismiss:YES];
    }
    return hitView;
}

+ (instancetype)popupWithContentView:(UIView *)contentView {
    ICDPopup *popup = [[[self class] alloc] init];
    popup.contentView = contentView;
    return popup;
}

- (void)showAtCenter:(CGPoint)center startPoint:(CGPoint)startPoint inView:(UIView *)inView animation:(BOOL)animation{
    self.startPoint = startPoint;
    
    if(!self.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self];
                break;
            }
        }
    }
    
    self.frame = self.window.bounds;
    
    if (self.contentView.superview) {
        [self.contentView removeFromSuperview];
    }
    [self.containerView addSubview:self.contentView];
    
    CGFloat width = CGRectGetWidth(self.contentView.frame);
    CGFloat height = CGRectGetHeight(self.contentView.frame);
    self.contentView.frame = CGRectMake(0, 0, width, height);
    
    CGPoint containerCenter = [self convertPoint:center fromView:inView];
    
    self.containerView.frame = CGRectMake(containerCenter.x - width / 2, containerCenter.y - height / 2, width, height);
    
    if (animation) {
        self.containerView.alpha = 0.0;
        CGRect finalContainerFrame = self.containerView.frame;
        self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.containerView.center = self.startPoint;
        
        [UIView animateWithDuration:0.6
                              delay:0.0
             usingSpringWithDamping:0.8
              initialSpringVelocity:15.0
                            options:0
                         animations:^{
                             self.containerView.alpha = 1.0;
                             self.containerView.transform = CGAffineTransformIdentity;
                             self.containerView.frame = finalContainerFrame;
                         }
                         completion:nil];
    }
}

- (void)dismiss:(BOOL)animation {
    if (self.dismissing) {
        return;
    }
    self.dismissing = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^completionBlock)(BOOL) = ^(BOOL finished) {
            if (finished) {
                self.dismissing = NO;
                [self removeFromSuperview];
            }
        };
        
        CGPoint finalContainerCenter = self.startPoint;
        if (animation) {
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^(void){
                                 self.containerView.alpha = 0.0;
                                 self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                 self.containerView.center = finalContainerCenter;
                             }
                             completion:completionBlock];
        } else {
            self.containerView.alpha = 0.0;
            completionBlock(YES);
        }
    });
}

@end

@implementation UIView (ICDPopup)

- (void)dismissPresentingICDPopup {
    
    // Iterate over superviews until you find a ICDPopup and dismiss it, then gtfo
    UIView* view = self;
    while (view != nil) {
        if ([view isKindOfClass:[ICDPopup class]]) {
            [(ICDPopup*)view dismiss:NO];
            break;
        }
        view = [view superview];
    }
}

@end