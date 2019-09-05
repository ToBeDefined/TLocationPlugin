//
//  CALayer+TLocationPlugin.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/6.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "CALayer+TLocationPlugin.h"

@implementation CALayer (TLocationPlugin)

- (UIColor *)t_borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

- (void)setT_borderUIColor:(UIColor *)t_borderUIColor {
    self.borderColor = t_borderUIColor.CGColor;
}

@end
