//
//  TLocationNavigationController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TLocationNavigationController.h"
#import "UIImage+TLocation.h"

@implementation TLocationNavigationController

- (void)dealloc {
    self.class.isShowing = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationBar setBackgroundImage:[UIImage t_imageWithColor:UIColor.lightGrayColor]
//                             forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[UIImage t_imageWithColor:UIColor.lightGrayColor]];
//    self.navigationBar.tintColor = UIColor.whiteColor;
    self.navigationBar.tintColor = UIColor.blackColor;
}


#pragma mark - Setter/Getter
static BOOL _t_isShowing = NO;
+ (BOOL)isShowing {
    return _t_isShowing;
}

+ (void)setIsShowing:(BOOL)isShowing {
    _t_isShowing = isShowing;
}


//- (UIModalPresentationStyle)modalPresentationStyle {
//#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
//    if (@available(iOS 13, *)) {
//        return UIModalPresentationAutomatic;
//    }
//#endif
//    return UIModalPresentationFullScreen;
//}

@end
