//
//  UIImage+TLocationPlugin.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "UIImage+TLocationPlugin.h"
#import "NSBundle+TLocationPlugin.h"

@implementation UIImage (TLocationPlugin)

+ (nullable instancetype)t_imageNamed:(NSString *)name {
    static NSBundle *imageBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageBundle = [NSBundle bundleWithPath:[NSBundle.t_bundle pathForResource:@"TLocationPluginImages" ofType:@"bundle"]];
    });
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

+ (instancetype)t_imageWithColor:(UIColor *)color {
    return [self t_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (instancetype)t_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
