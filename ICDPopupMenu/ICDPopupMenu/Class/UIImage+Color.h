//
//  UIImage+Color.h
//  cloudoor
//
//  Created by dhf on 7/26/15.
//  Copyright (c) 2015 Cloudoor Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (instancetype)imageWithColor:(UIColor *)color;
+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
