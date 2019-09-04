//
//  UIWindow+TShake.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "UIWindow+TShake.h"
#import "TSetLocationViewController.h"
#import "TLocationNavigationController.h"

@implementation UIWindow (TShake)

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"Shark Begin");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"Sharked");
        if (TLocationNavigationController.isShowing) {
            NSLog(@"TLocationNavigationController is showing");
            return;
        }
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        TLocationNavigationController.isShowing = YES;
        TSetLocationViewController *vc = [[TSetLocationViewController alloc] init];
        TLocationNavigationController *nav = [[TLocationNavigationController alloc] initWithRootViewController:vc];
        [rootVC presentViewController:nav animated:YES completion:nil];
    } else {
        NSLog(@"Some Unknown Event");
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"Shark Cancelled");
}

@end
