//
//  UIApplication+TLocationPlugin.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/8.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (TLocationPlugin)

/// 获取 App 的顶层 controller
@property (nonatomic, readonly, nullable) UIViewController *t_topViewController;

@end

NS_ASSUME_NONNULL_END
