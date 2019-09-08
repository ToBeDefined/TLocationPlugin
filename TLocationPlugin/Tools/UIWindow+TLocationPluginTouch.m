//
//  UIWindow+TLocationPluginTouch.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "UIWindow+TLocationPluginTouch.h"
#import "TSelectLocationDataViewController.h"
#import "TLocationNavigationController.h"

@implementation UIWindow (TLocationPluginTouch)

static NSInteger _t_windowTouchedTimes = 0;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (TLocationNavigationController.isShowing) {
        return;
    }
    if (_t_windowTouchedTimes == 0) {
        // 开始触摸, 5秒后清零
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _t_windowTouchedTimes = 0;
        });
    }
    ++_t_windowTouchedTimes;
    if (_t_windowTouchedTimes < 5) {
        return;
    }
    // 5秒内触摸5次
    TLocationNavigationController.isShowing = YES;
    _t_windowTouchedTimes = 0;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    TSelectLocationDataViewController *vc = [[TSelectLocationDataViewController alloc] init];
    TLocationNavigationController *nav = [[TLocationNavigationController alloc] initWithRootViewController:vc];
    [rootVC presentViewController:nav animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
}
@end
