//
//  UIWindow+TLocationPluginTouch.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "UIWindow+TLocationPluginTouch.h"
#import "TSetLocationViewController.h"
#import "TLocationNavigationController.h"

@implementation UIWindow (TLocationPluginTouch)

static NSInteger _t_window_sharkedTimes = 0;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ++_t_window_sharkedTimes;
    if (_t_window_sharkedTimes <= 3) {
        if (_t_window_sharkedTimes == 0) {
            // 开始摇晃, 5秒内触摸四次, 5秒后清零
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _t_window_sharkedTimes = 0;
            });
        }
        return;
    }
    // 5秒内触摸四次
    if (TLocationNavigationController.isShowing) {
        return;
    }
    _t_window_sharkedTimes = 0;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    TLocationNavigationController.isShowing = YES;
    TSetLocationViewController *vc = [[TSetLocationViewController alloc] init];
    TLocationNavigationController *nav = [[TLocationNavigationController alloc] initWithRootViewController:vc];
    [rootVC presentViewController:nav animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
}
@end
