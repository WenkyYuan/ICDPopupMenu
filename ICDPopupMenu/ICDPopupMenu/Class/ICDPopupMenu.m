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
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    
    CGFloat selfCenterX = 0;
    CGFloat selfCenterY = 0;
    CGRect itemContainerViewFrame = CGRectZero;
    
    if (position == ICDPopupMenuArrowPositionTopLeft) {
        selfCenterX = startPoint.x - kArrowWidth / 2 - kArrowTrailingSuperSpacing + selfWidth / 2;
        selfCenterY = startPoint.y + selfHeight / 2;
        itemContainerViewFrame = CGRectMake(0, kArrowHeight, selfWidth, selfHeight - kArrowHeight);
    }
    if (position == ICDPopupMenuArrowPositionTopCenter) {
        selfCenterX = startPoint.x;
        selfCenterY = startPoint.y + selfHeight / 2;
        itemContainerViewFrame = CGRectMake(0, kArrowHeight, selfWidth, selfHeight - kArrowHeight);
    }
    if (position == ICDPopupMenuArrowPositionTopRight) {
        selfCenterX = startPoint.x + kArrowWidth / 2 + kArrowTrailingSuperSpacing - selfWidth / 2;
        selfCenterY = startPoint.y + selfHeight / 2;
        itemContainerViewFrame = CGRectMake(0, kArrowHeight, selfWidth, selfHeight - kArrowHeight);
    }
    
    if (position == ICDPopupMenuArrowPositionBottomLeft) {
        selfCenterX = startPoint.x - kArrowWidth / 2 - kArrowTrailingSuperSpacing + selfWidth / 2;
        selfCenterY = startPoint.y - selfHeight / 2;
        itemContainerViewFrame = CGRectMake(0, 0, selfWidth, selfHeight - kArrowHeight);
    }
    if (position == ICDPopupMenuArrowPositionBottomCenter) {
        selfCenterX = startPoint.x;
        selfCenterY = startPoint.y - selfHeight / 2;
        itemContainerViewFrame = CGRectMake(0, 0, selfWidth, selfHeight - kArrowHeight);
    }
    if (position == ICDPopupMenuArrowPositionBottomRight) {
        selfCenterX = startPoint.x + kArrowWidth / 2 + kArrowTrailingSuperSpacing - selfWidth / 2;
        selfCenterY = startPoint.y - selfHeight / 2;
        itemContainerViewFrame = CGRectMake(0, 0, selfWidth, selfHeight - kArrowHeight);
    }
    
    if (position == ICDPopupMenuArrowPositionLeftTop) {
        selfCenterX = startPoint.x + selfWidth / 2;
        selfCenterY = startPoint.y - kArrowWidth / 2 - kArrowTrailingSuperSpacing + selfHeight / 2;
        itemContainerViewFrame = CGRectMake(kArrowHeight, 0, selfWidth - kArrowHeight, selfHeight);
    }
    if (position == ICDPopupMenuArrowPositionLeftCenter) {
        selfCenterX = startPoint.x + selfWidth / 2;
        selfCenterY = startPoint.y;
        itemContainerViewFrame = CGRectMake(kArrowHeight, 0, selfWidth - kArrowHeight, selfHeight);
    }
    if (position == ICDPopupMenuArrowPositionLeftBottom) {
        selfCenterX = startPoint.x + selfWidth / 2;
        selfCenterY = startPoint.y + kArrowWidth / 2 + kArrowTrailingSuperSpacing - selfHeight / 2;
        itemContainerViewFrame = CGRectMake(kArrowHeight, 0, selfWidth - kArrowHeight, selfHeight);
    }
    
    if (position == ICDPopupMenuArrowPositionRightTop) {
        selfCenterX = startPoint.x - selfWidth / 2;
        selfCenterY = startPoint.y - kArrowWidth / 2 - kArrowTrailingSuperSpacing + selfHeight / 2;
        itemContainerViewFrame = CGRectMake(0, 0, selfWidth - kArrowHeight, selfHeight);
    }
    if (position == ICDPopupMenuArrowPositionRightCenter) {
        selfCenterX = startPoint.x - selfWidth / 2;
        selfCenterY = startPoint.y;
        itemContainerViewFrame = CGRectMake(0, 0, selfWidth - kArrowHeight, selfHeight);
    }
    if (position == ICDPopupMenuArrowPositionRightBottom) {
        selfCenterX = startPoint.x - selfWidth / 2;
        selfCenterY = startPoint.y + kArrowWidth / 2 + kArrowTrailingSuperSpacing - selfHeight / 2;
        itemContainerViewFrame = CGRectMake(0, 0, selfWidth - kArrowHeight, selfHeight);
    }
    
    //layerBgView
    self.arrowLayerBgView.frame = CGRectMake(0, 0, selfWidth, selfHeight);
    //itemContainerView
    self.itemContainerView.frame = itemContainerViewFrame;
    //items
    CGFloat itemWidth = CGRectGetWidth(itemContainerViewFrame);
    CGFloat itemHeight = CGRectGetHeight(itemContainerViewFrame) / self.btnItemArray.count;
    for (NSUInteger i = 0; i < self.btnItemArray.count; i ++ ) {
        UIButton *item = self.btnItemArray[i];
        item.frame = CGRectMake(0, i * itemHeight, itemWidth, itemHeight);
    }
    
    CGRect frame = self.frame;
    frame.origin.x = selfCenterX - CGRectGetWidth(self.bounds)/2;
    frame.origin.y = selfCenterY - CGRectGetHeight(self.bounds)/2;
    self.frame = frame;
    
    ICDPopup *popup = [ICDPopup popupWithContentView:self];
    [popup showAtCenter:CGPointMake(selfCenterX, selfCenterY) startPoint:startPoint inView:inView animation:YES];
    
    //需要加入到popup后才能计算出三角形指示箭头的位置，此时才开始画layer
    [self addArrowLayer:startPoint inView:inView position:position];
}

- (void)addArrowLayer:(CGPoint)startPoint inView:(UIView *)inView position:(ICDPopupMenuArrowPosition)position {
    startPoint = [self convertPoint:startPoint fromView:inView];
    
    CGPoint arrowTopPoint = startPoint;
    CGPoint arrowPointA = CGPointMake(arrowTopPoint.x - kArrowWidth/2, kArrowHeight);
    CGPoint arrowPointB = CGPointMake(arrowTopPoint.x + kArrowWidth/2, kArrowHeight);

    if (position == ICDPopupMenuArrowPositionTopLeft || position == ICDPopupMenuArrowPositionTopCenter || position == ICDPopupMenuArrowPositionTopRight) {
        arrowPointA = CGPointMake(arrowTopPoint.x - kArrowWidth/2, arrowTopPoint.y + kArrowHeight);
        arrowPointB = CGPointMake(arrowTopPoint.x + kArrowWidth/2, arrowTopPoint.y + kArrowHeight);
    }
    
    if (position == ICDPopupMenuArrowPositionBottomLeft || position == ICDPopupMenuArrowPositionBottomCenter || position == ICDPopupMenuArrowPositionBottomRight) {
        arrowPointA = CGPointMake(arrowTopPoint.x + kArrowWidth/2, arrowTopPoint.y - kArrowHeight);
        arrowPointB = CGPointMake(arrowTopPoint.x - kArrowWidth/2, arrowTopPoint.y - kArrowHeight);
    }
    
    if (position == ICDPopupMenuArrowPositionLeftTop || position == ICDPopupMenuArrowPositionLeftCenter || position == ICDPopupMenuArrowPositionLeftBottom) {
        arrowPointA = CGPointMake(arrowTopPoint.x + kArrowHeight, arrowTopPoint.y + kArrowWidth / 2);
        arrowPointB = CGPointMake(arrowTopPoint.x + kArrowHeight, arrowTopPoint.y - kArrowWidth / 2);
    }
    
    if (position == ICDPopupMenuArrowPositionRightTop || position == ICDPopupMenuArrowPositionRightCenter || position == ICDPopupMenuArrowPositionRightBottom) {
        arrowPointA = CGPointMake(arrowTopPoint.x - kArrowHeight, arrowTopPoint.y - kArrowWidth / 2);
        arrowPointB = CGPointMake(arrowTopPoint.x - kArrowHeight, arrowTopPoint.y + kArrowWidth / 2);
        
    }
    CAShapeLayer *layer = [self createArrowLayerWithArrowPointT:arrowTopPoint pointA:arrowPointA pointB:arrowPointB];
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

- (CAShapeLayer *)createArrowLayerWithArrowPointT:(CGPoint)pointT pointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.itemContainerView.frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointT];
    [path addLineToPoint:pointB];
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
