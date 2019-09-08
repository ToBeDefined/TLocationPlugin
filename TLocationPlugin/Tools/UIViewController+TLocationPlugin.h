//
//  UIViewController+TLocationPlugin.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/8.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TLocationPlugin)

/// 获取当前 viewController 的顶层 controller
@property (nonatomic, readonly) UIViewController *t_topViewController;

/// 获取 viewController 的顶层 controller
+ (UIViewController *)t_findTopViewControllerFromViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
