//
//  UIWindow+TLocationPluginShake.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "UIWindow+TLocationPluginShake.h"
#import "TSetLocationViewController.h"
#import "TLocationNavigationController.h"

@implementation UIWindow (TLocationPluginShake)

static NSInteger _t_window_sharkedTimes = 0;
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        if (_t_window_sharkedTimes < 2) {
            if (_t_window_sharkedTimes == 0) {
                // 开始摇晃, 5秒内摇晃三次, 5秒后清零
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _t_window_sharkedTimes = 0;
                });
            }
            ++_t_window_sharkedTimes;
            return;
        }
        // 5秒内摇晃三次
        if (TLocationNavigationController.isShowing) {
            // @"TLocationNavigationController is showing"
            return;
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        TLocationNavigationController.isShowing = YES;
        TSetLocationViewController *vc = [[TSetLocationViewController alloc] init];
        TLocationNavigationController *nav = [[TLocationNavigationController alloc] initWithRootViewController:vc];
        [rootVC presentViewController:nav animated:YES completion:nil];
    } else {
        // Unknown Event
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {}

@end
