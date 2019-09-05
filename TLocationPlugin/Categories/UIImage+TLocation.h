//
//  UIImage+TLocation.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TLocation)

+ (nullable instancetype)t_imageNamed:(NSString *)name;

+ (instancetype)t_imageWithColor:(UIColor *)color;
+ (instancetype)t_imageWithColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
