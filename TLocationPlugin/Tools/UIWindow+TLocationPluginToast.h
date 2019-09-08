//
//  UIWindow+TLocationPluginToast.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (TLocationPluginToast)

+ (UIView *)t_showTostForMessage:(NSString *)message;
+ (UIView *)t_showTostForMessage:(NSString *)message fontSize:(CGFloat)fontSize;

+ (nullable UIView *)t_showTostForCLLocation:(CLLocation *)location;
+ (nullable UIView *)t_showTostForCLLocations:(NSArray<CLLocation *> *)locations;

@end

NS_ASSUME_NONNULL_END
