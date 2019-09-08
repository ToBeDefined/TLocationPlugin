//
//  UIApplication+TLocationPlugin.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/8.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "UIApplication+TLocationPlugin.h"
#import "UIViewController+TLocationPlugin.h"

@implementation UIApplication (TLocationPlugin)

- (UIViewController *)t_topViewController {
    UIViewController *viewController = self.keyWindow.rootViewController;
    if (viewController) {
        return [UIViewController t_findTopViewControllerFromViewController:viewController];
    }
    return nil;
}

@end
