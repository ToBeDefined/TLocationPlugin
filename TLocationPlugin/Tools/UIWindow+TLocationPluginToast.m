//
//  UIWindow+TLocationPluginToast.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "UIWindow+TLocationPluginToast.h"

#define SCREEN_HEIGHT   (UIScreen.mainScreen.bounds.size.height)
#define SCREEN_WIDTH    (UIScreen.mainScreen.bounds.size.width)

@implementation UIWindow (TLocationPluginToast)

static UIView *_t_cllocationToastView = nil;

+ (void)t_showTostForCLLocation:(CLLocation *)location {
    [self t_showTostForCLLocations:@[location]];
}

+ (void)t_showTostForCLLocations:(NSArray<CLLocation *> *)locations {
    [_t_cllocationToastView removeFromSuperview];
    NSMutableString *text = [NSMutableString string];
    for (NSUInteger idx = 0; idx < locations.count; ++idx) {
        CLLocation *location = locations[idx];
        if (idx != 0) [text appendString:@"\n\n"];
        [text appendString:@"纬度"];
        [text appendString:@(location.coordinate.latitude).stringValue];
        [text appendString:@"\n"];
        [text appendString:@"经度"];
        [text appendString:@(location.coordinate.longitude).stringValue];
    }
    
    CGFloat width = 150;
    CGFloat height = 37*locations.count;
    CGFloat x = (SCREEN_WIDTH - width)/2;
    CGFloat y = SCREEN_HEIGHT - height - 40; // bottomMargin 40
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    bgView.backgroundColor = UIColor.blackColor;
    bgView.alpha = 0.5;
    [view addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    label.textColor = UIColor.whiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:10];
    label.text = text;
    [view addSubview:label];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(_t_touchToastView:)];
    [view addGestureRecognizer:touch];
    _t_cllocationToastView = view;
    [UIApplication.sharedApplication.keyWindow addSubview:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            _t_cllocationToastView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_t_cllocationToastView removeFromSuperview];
            _t_cllocationToastView = nil;
        }];
    });
}

+ (void)_t_touchToastView:(UIGestureRecognizer*)gestureRecognizer {
    [_t_cllocationToastView removeFromSuperview];
    _t_cllocationToastView = nil;
}

@end
