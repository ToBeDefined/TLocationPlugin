//
//  UIImage+TLocation.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//
//  Copyright (C) 2011-2019 ShenZhen iBOXCHAIN Information Technology Co.,Ltd. 
//                             All rights reserved.
//
//      This  software  is  the  confidential  and  proprietary  information  of
//  iBOXCHAIN  Company  of  China. ("Confidential Information"). You  shall  not
//  disclose such Confidential Information and shall use it only in accordance
//  with the terms of the contract agreement you entered into with iBOXCHAIN inc.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TLocation)

+ (nullable instancetype)t_imageNamed:(NSString *)name;

+ (instancetype)t_imageWithColor:(UIColor *)color;
+ (instancetype)t_imageWithColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
