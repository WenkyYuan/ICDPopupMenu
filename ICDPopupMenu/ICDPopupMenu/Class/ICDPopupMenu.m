//
//  ICDPopupMenu.m
//  cloudoor
//
//  Created by wenky on 15/11/7.
//  Copyright (c) 2015年 Cloudoor Technology Co.,Ltd. All rights reserved.
//

#import "ICDPopupMenu.h"
#import "ICDPopup.h"
#import "UIImage+Color.h"

static const CGFloat kArrowWidth = 12;
static const CGFloat kArrowHeight = 8;
static const CGFloat kArrowTrailingSuperSpacing = 12;
static const NSUInteger kButtonTagOffset = 1000;

@interface ICDPopupMenu ()
@property (nonatomic, strong) UIView *arrowLayerBgView;
@property (nonatomic, strong) UIView *itemContainerView;
@property (nonatomic, copy) NSArray *btnItemArray; //array of btn
@property (nonatomic, strong) UIView *inView;

@end

@implementation ICDPopupMenu

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    //layerBgView
    self.arrowLayerBgView.frame = CGRectMake(0, 0, width, height);
    //itemContainerView
    self.itemContainerView.frame = CGRectMake(0, kArrowHeight, width, height - kArrowHeight);
    //items
    CGFloat itemHeight = (height - kArrowHeight) / self.btnItemArray.count;
    for (NSUInteger i = 0; i < self.btnItemArray.count; i ++ ) {
        UIButton *item = self.btnItemArray[i];
        item.frame = CGRectMake(0, i * itemHeight, width, itemHeight);
    }
}

#pragma mark - event method 
- (void)didTapButton:(UIButton *)sender {
    NSUInteger tag = sender.tag - kButtonTagOffset;
    [self hide];
    if (self.actionHandler) {
        self.actionHandler(self, tag);
    }
}

#pragma mark - public methods
- (void)showFromNavigationBarButtonItem:(UIBarButtonItem *)barButtonItem {
    UIView *itemView = [barButtonItem valueForKey:@"view"];
    CGPoint itemViewCenter = itemView.center;
    
    CGPoint startPoint = CGPointMake(itemViewCenter.x, 64);
    
    ICDPopupMenuArrowPosition arrowPositon;
    if (itemViewCenter.x < CGRectGetWidth([UIScreen mainScreen].bounds)/2) {
        //LeftBarButtonItem
        arrowPositon = ICDPopupMenuArrowPositionTopLeft;
    } else {
        //RightBarButtonItem
        arrowPositon = ICDPopupMenuArrowPositionTopRight;
    }
    
    [self showInView:itemView.window.rootViewController.view startPoint:startPoint arrowPositon:arrowPositon];
}


- (void)showInView:(UIView *)inView startPoint:(CGPoint)startPoint arrowPositon:(ICDPopupMenuArrowPosition)position {
    self.inView = inView;
    
    //默认Center&Top
    CGFloat selfCenterX = startPoint.x;
    CGFloat selfCenterY = startPoint.y + CGRectGetHeight(self.bounds) / 2;
    if (position == ICDPopupMenuArrowPositionTopLeft) {
        selfCenterX = startPoint.x - kArrowWidth/2-kArrowTrailingSuperSpacing + CGRectGetWidth(self.bounds) / 2;
        selfCenterY = startPoint.y + CGRectGetHeight(self.bounds) / 2;
    }
    if (position == ICDPopupMenuArrowPositionTopRight) {
        selfCenterX = startPoint.x + kArrowWidth/2+kArrowTrailingSuperSpacing - CGRectGetWidth(self.bounds) / 2;
        selfCenterY = startPoint.y + CGRectGetHeight(self.bounds) / 2;
    }
    
    CGRect frame = self.frame;
    frame.origin.x = selfCenterX - CGRectGetWidth(self.bounds)/2;
    frame.origin.y = selfCenterY - CGRectGetHeight(self.bounds)/2;
    self.frame = frame;
    
    ICDPopup *popup = [ICDPopup popupWithContentView:self];
    [popup showAtCenter:CGPointMake(selfCenterX, selfCenterY) startPoint:startPoint inView:inView animation:YES];
    
    //需要加入到popup后才能计算出三角形指示箭头的位置，此时才开始画layer
    CAShapeLayer *layer = [self createArrowLayerInSuperStartPoint:startPoint];
    [_arrowLayerBgView.layer addSublayer:layer];
}

#pragma mark - private methods
- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    
    _arrowLayerBgView = [[UIView alloc] init];
    _arrowLayerBgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_arrowLayerBgView];
    
    _itemContainerView = [[UIView alloc] init];
    _itemContainerView.backgroundColor = [UIColor clearColor];
    _itemContainerView.layer.cornerRadius = 5;
    _itemContainerView.layer.masksToBounds = YES;
    [self addSubview:_itemContainerView];
}

- (void)hide {
    [self dismissPresentingICDPopup];
}

- (UIButton *)createItemWithTitle:(NSString *)title imageName:(NSString *)imageName tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBA(0x000000, 0.3)] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 24, 0, 0)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.tag = tag;
    return button;
}

- (CAShapeLayer *)createArrowLayerInSuperStartPoint:(CGPoint)superStartPoint {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    CGFloat width = kArrowWidth;
    CGFloat height = kArrowHeight;
    
    CGPoint startPoint = [self convertPoint:superStartPoint fromView:self.inView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, kArrowHeight, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kArrowHeight) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CGPoint arrowTopPoint = startPoint;
    CGPoint arrowLeftPoint = CGPointMake(arrowTopPoint.x - width/2, height);
    CGPoint arrowRightPoint = CGPointMake(arrowTopPoint.x + width/2, height);
    [path moveToPoint:arrowLeftPoint];
    [path addLineToPoint:arrowTopPoint];
    [path addLineToPoint:arrowRightPoint];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = self.tintColor.CGColor;
    layer.frame = self.bounds;
    return layer;
}

#pragma mark - setters
- (void)setItemArray:(NSArray *)itemArray {
    _itemArray = [itemArray copy];
    
    NSMutableArray *array = [NSMutableArray new];
    NSUInteger tag = kButtonTagOffset;
    for (ICDPopupMenuItem *item in _itemArray) {
        UIButton *btnItem = [self createItemWithTitle:item.title imageName:item.imageName tag:tag];
        UIView *view = [self.itemContainerView viewWithTag:tag];
        if (view) {
            [view removeFromSuperview];
        }
        [self.itemContainerView addSubview:btnItem];
        [array addObject:btnItem];
        tag ++;
    }
    self.btnItemArray = [array copy];
}

@end

@implementation ICDPopupMenuItem

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        _title = [title copy];
        _imageName = [imageName copy];
    }
    return self;
}

@end
