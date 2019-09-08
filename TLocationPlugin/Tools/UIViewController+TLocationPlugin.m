//
//  UIViewController+TLocationPlugin.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/8.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "UIViewController+TLocationPlugin.h"

@implementation UIViewController (TLocationPlugin)

- (UIViewController *)t_topViewController {
    return [UIViewController t_findTopViewControllerFromViewController:self];
}

+ (UIViewController *)t_findTopViewControllerFromViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *svc = (UISplitViewController*)viewController;
        if (svc.viewControllers.count > 0) {
            return [self t_findTopViewControllerFromViewController:svc.viewControllers.lastObject];
        } else {
            return viewController;
        }
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        if (nav.viewControllers.count > 0) {
            return [self t_findTopViewControllerFromViewController:nav.topViewController];
        } else {
            return viewController;
        }
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (UITabBarController*)viewController;
        if (tbc.viewControllers.count > 0) {
            return [self t_findTopViewControllerFromViewController:tbc.selectedViewController];
        } else {
            return viewController;
        }
    } else if (viewController.childViewControllers.count > 0) {
        UIViewController *childVC = [viewController childViewControllerForStatusBarStyle];
        
        if (childVC != nil) {
            return [self t_findTopViewControllerFromViewController:childVC];
        } else {
            return viewController;
        }
    } else if (viewController.presentedViewController) {
        if (@available(iOS 8.0, *)) {
            if ([viewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
                return viewController;
            }
        }
        return [self t_findTopViewControllerFromViewController:viewController.presentedViewController];
    } else {
        return viewController;
    }
}

@end
