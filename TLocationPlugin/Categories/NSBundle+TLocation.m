//
//  NSBundle+TLocation.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "NSBundle+TLocation.h"

@interface __Temp_Bundle_Class : NSObject
@end
@implementation __Temp_Bundle_Class
@end

@implementation NSBundle (TLocation)

+ (instancetype)t_bundle {
    static NSBundle *_t_bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _t_bundle = [NSBundle bundleForClass:[__Temp_Bundle_Class class]];
        if (_t_bundle == nil) {
            _t_bundle = [NSBundle bundleWithPath:[NSBundle.mainBundle pathForResource:@"Frameworks/TLocationPlugin.framework" ofType:nil]];
        }
    });
    return _t_bundle;
}

@end
