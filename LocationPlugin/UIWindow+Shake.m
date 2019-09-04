//
//  UIWindow+Shake.m
//  LocationPlugin
//
//  Created by TBD on 2019/9/4.
//
//  Copyright (C) 2011-2019 ShenZhen iBOXCHAIN Information Technology Co.,Ltd. 
//                             All rights reserved.
//
//      This  software  is  the  confidential  and  proprietary  information  of
//  iBOXCHAIN  Company  of  China. ("Confidential Information"). You  shall  not
//  disclose such Confidential Information and shall use it only in accordance
//  with the terms of the contract agreement you entered into with iBOXCHAIN inc.
//

#import <AudioToolbox/AudioToolbox.h>
#import "UIWindow+Shake.h"
#import "TSetLocationViewController.h"

@implementation UIWindow (Shake)

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"Shark Begin");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake && TSetLocationViewController.isShowing == NO) {
        NSLog(@"Sharked");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        TSetLocationViewController.isShowing = YES;
        [vc presentViewController:[[TSetLocationViewController alloc] init]
                         animated:YES
                       completion:nil];
    } else {
        NSLog(@"Some Unknown Event");
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"Shark Cancelled");
}

@end
