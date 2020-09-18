//
//  TLocationNavigationController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TLocationNavigationController.h"
#import "UIImage+TLocationPlugin.h"
#import "TLocationManager.h"

@interface TLocationNavigationController ()

@property (nonatomic, assign) UIStatusBarStyle currentStatusBarStyle;

@end

@implementation TLocationNavigationController

- (void)dealloc {
    TLocationNavigationController.isShowing = NO;
    [UIApplication sharedApplication].statusBarStyle = self.currentStatusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [self.navigationBar setBackgroundImage:[UIImage t_imageWithColor:UIColor.whiteColor]
                             forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:nil];
    self.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationBar.tintColor = UIColor.blackColor;
    self.navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName:UIColor.blackColor,
        NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
    };
}

#pragma mark - Setter/Getter
static BOOL _t_isShowing = NO;
+ (BOOL)isShowing {
    return _t_isShowing;
}

+ (void)setIsShowing:(BOOL)isShowing {
    _t_isShowing = isShowing;
    TLocationManager.shared.suspend = isShowing;
}


- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return nil;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return nil;
}

@end
