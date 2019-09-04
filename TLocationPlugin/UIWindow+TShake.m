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

@implementation UIWindow (TShake)

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
