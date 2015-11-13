//
//  UIImage+Color.m
//  cloudoor
//
//  Created by dhf on 7/26/15.
//  Copyright (c) 2015 Cloudoor Technology Co.,Ltd. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (instancetype)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(0.5, 0.5)];
}

+ (instancetype)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
