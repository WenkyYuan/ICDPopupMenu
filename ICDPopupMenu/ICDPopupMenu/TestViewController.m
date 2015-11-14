//
//  TestViewController.m
//  cloudoor
//
//  Created by wenky on 15/11/13.
//  Copyright (c) 2015年 Cloudoor Technology Co.,Ltd. All rights reserved.
//

#import "TestViewController.h"
#import "ICDPopupMenu.h"

@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic, assign) ICDPopupMenuArrowPosition arrowPosition;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ICDPopupMenu";
    self.arrowPosition = ICDPopupMenuArrowPositionTopLeft;
}

- (IBAction)didShowMenu:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    //不需要origin
    ICDPopupMenu *menu = [[ICDPopupMenu alloc] initWithFrame:CGRectMake(0, 0, 140, 143)];
    NSMutableArray *itemArray = [NSMutableArray new];
    for (NSDictionary *menuDic in [self menuDicArray]) {
        ICDPopupMenuItem *item = [[ICDPopupMenuItem alloc] initWithTitle:menuDic[@"title"] imageName:menuDic[@"image"]];
        [itemArray addObject:item];
    }
    menu.itemArray = itemArray;
    menu.tintColor = UIColorFromRGBA(0x000000, 0.5);
    __weak typeof(self) weakSelf = self;
    menu.actionHandler = ^(ICDPopupMenu *view, NSUInteger index) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor blueColor];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    CGPoint startPoint = button.center;
    [menu showFromPoint:startPoint inView:self.view arrowPositon:self.arrowPosition];
}

- (NSArray *)menuDicArray {
    return @[@{@"title":@"扫一扫",
               @"image":@"interaction_scan"
               },
             @{@"title":@"添加好友",
               @"image":@"interaction_addfriend"
               },
             @{@"title":@"通讯录",
               @"image":@"interaction_contacts"
               }];
}

- (IBAction)selectArrowPosition:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 11:
            self.arrowPosition = ICDPopupMenuArrowPositionTopLeft;
            break;
        case 12:
            self.arrowPosition = ICDPopupMenuArrowPositionTopCenter;
            break;
        case 13:
            self.arrowPosition = ICDPopupMenuArrowPositionTopRight;
            break;
        case 21:
            self.arrowPosition = ICDPopupMenuArrowPositionRightTop;
            break;
        case 22:
            self.arrowPosition = ICDPopupMenuArrowPositionRightCenter;
            break;
        case 23:
            self.arrowPosition = ICDPopupMenuArrowPositionRightBottom;
            break;
        case 31:
            self.arrowPosition = ICDPopupMenuArrowPositionBottomLeft;
            break;
        case 32:
            self.arrowPosition = ICDPopupMenuArrowPositionBottomCenter;
            break;
        case 33:
            self.arrowPosition = ICDPopupMenuArrowPositionBottomRight;
            break;
        case 41:
            self.arrowPosition = ICDPopupMenuArrowPositionLeftTop;
            break;
        case 42:
            self.arrowPosition = ICDPopupMenuArrowPositionLeftCenter;
            break;
        case 43:
            self.arrowPosition = ICDPopupMenuArrowPositionLeftBottom;
            break;
        default:
            break;
    }
    self.tipLabel.text = [NSString stringWithFormat:@"当前箭头方向为：%@", button.titleLabel.text];
}

@end
