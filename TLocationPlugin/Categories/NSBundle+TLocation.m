//
//  NSBundle+TLocation.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//
//  Copyright (C) 2011-2019 ShenZhen iBOXCHAIN Information Technology Co.,Ltd. 
//                             All rights reserved.
//
//      This  software  is  the  confidential  and  proprietary  information  of
//  iBOXCHAIN  Company  of  China. ("Confidential Information"). You  shall  not
//  disclose such Confidential Information and shall use it only in accordance
//  with the terms of the contract agreement you entered into with iBOXCHAIN inc.
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
