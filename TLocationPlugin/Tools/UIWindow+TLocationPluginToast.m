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

+ (void)t_showTostForMessage:(NSString *)message
                    fontSize:(CGFloat)fontSize
                bottomMargin:(CGFloat)bottomMargin {
    dispatch_async(dispatch_get_main_queue(), ^{
        _t_cllocationToastView.hidden = YES;
        [_t_cllocationToastView removeFromSuperview];
        UIFont *textFont = [UIFont systemFontOfSize:fontSize];
        CGSize maxSize = CGSizeMake(200, 100);
        CGRect frame = [message boundingRectWithSize:maxSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: textFont}
                                             context:nil];
        frame = CGRectMake(0, 0, frame.size.width+40, frame.size.height+20);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.backgroundColor = UIColor.grayColor;
        bgView.alpha = 0.9;
        [view addSubview:bgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.textColor = UIColor.whiteColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = textFont;
        label.text = message;
        label.contentMode = UIViewContentModeCenter;
        [view addSubview:label];
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(_t_touchToastView:)];
        [view addGestureRecognizer:touch];
        [UIApplication.sharedApplication.keyWindow addSubview:view];
        CGFloat toastWidth = view.frame.size.width;
        CGFloat toastHeight = view.frame.size.height;
        CGFloat toastX = (SCREEN_WIDTH - toastWidth) / 2;
        CGFloat toastY = SCREEN_HEIGHT - toastHeight - bottomMargin;
        view.frame = CGRectMake(toastX, toastY, toastWidth, toastHeight);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                view.alpha = 0.0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                _t_cllocationToastView = nil;
            }];
        });
        _t_cllocationToastView = view;
    });
}

+ (void)t_showTostForMessage:(NSString *)message {
    [self t_showTostForMessage:message fontSize:12];
}

+ (void)t_showTostForMessage:(NSString *)message
                    fontSize:(CGFloat)fontSize {
    [self t_showTostForMessage:message
                      fontSize:fontSize
                  bottomMargin:100];
}

+ (void)t_showTostForCLLocation:(CLLocation *)location {
    if (location == nil) {
        return;
    }
    [self t_showTostForCLLocations:@[location]];
}

+ (void)t_showTostForCLLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count == 0) {
        return;
    }
    NSMutableString *text = [NSMutableString string];
    for (NSUInteger idx = 0; idx < locations.count; ++idx) {
        CLLocation *location = locations[idx];
        if (idx == 0) [text appendString:@"定位数据"];
        [text appendString:@"\n\n"];
        [text appendString:@"纬度"];
        [text appendString:@(location.coordinate.latitude).stringValue];
        [text appendString:@"\n"];
        [text appendString:@"经度"];
        [text appendString:@(location.coordinate.longitude).stringValue];
    }
    [self t_showTostForMessage:text fontSize:10 bottomMargin:40];
}

+ (void)_t_touchToastView:(UIGestureRecognizer*)gestureRecognizer {
    [_t_cllocationToastView removeFromSuperview];
    _t_cllocationToastView = nil;
}

@end
