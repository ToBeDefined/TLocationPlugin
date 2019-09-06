//
//  NSBundle+TLocationPlugin.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "NSBundle+TLocationPlugin.h"

@interface __TLocationPlugin_Temp_Bundle_Class : NSObject
@end
@implementation __TLocationPlugin_Temp_Bundle_Class
@end

@implementation NSBundle (TLocationPlugin)

+ (instancetype)t_bundle {
    static NSBundle *_t_bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _t_bundle = [NSBundle bundleForClass:[__TLocationPlugin_Temp_Bundle_Class class]];
        if (_t_bundle == nil) {
            _t_bundle = [NSBundle bundleWithPath:[NSBundle.mainBundle pathForResource:@"Frameworks/TLocationPlugin.framework" ofType:nil]];
        }
    });
    return _t_bundle;
}

@end
