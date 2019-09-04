//
//  TSetLocationCache.m
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

#import "TSetLocationCache.h"


typedef NS_ENUM(NSUInteger, CacheKeyType) {
    CacheKeyTypeUsingHookLocation   = 1,
    CacheKeyTypeLatitude            = 2,
    CacheKeyTypeLongitude           = 3,
    CacheKeyTypeBackupLatitude      = 4,
    CacheKeyTypeBackupLongitude     = 5,
    CacheKeyTypeRange               = 6,
};

@implementation TSetLocationCache


#pragma mark - Singletion
#pragma mark -

static TSetLocationCache *_instance;
+ (TSetLocationCache *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if __has_feature(objc_arc)
        _instance = [[self alloc] init];
#else
        _instance = [[[self alloc] init] autorelease];
#endif
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self) {}
    });
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

#if !__has_feature(objc_arc)
- (instancetype)retain { return self; }
- (NSUInteger)retainCount { return NSUIntegerMax; }
- (oneway void)release {}
- (instancetype)autorelease{ return self; }
#endif

#pragma mark - Function
#pragma mark -

- (NSString *)cacheKeyForType:(CacheKeyType)type {
    switch (type) {
        case CacheKeyTypeUsingHookLocation:
            return @"_T_CacheKeyTypeUsingHookLocation";
        case CacheKeyTypeLatitude:
            return @"_T_CacheKeyTypeLatitude";
        case CacheKeyTypeLongitude:
            return @"_T_CacheKeyTypeLongitude";
        case CacheKeyTypeBackupLatitude:
            return @"_T_CacheKeyTypeBackupLatitude";
        case CacheKeyTypeBackupLongitude:
            return @"_T_CacheKeyTypeBackupLongitude";
        case CacheKeyTypeRange:
            return @"_T_CacheKeyTypeRange";
        default:
            return nil;
    }
}

- (BOOL)usingHookLocation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[self cacheKeyForType:CacheKeyTypeUsingHookLocation]];
}
- (void)setUsingHookLocation:(BOOL)usingHookLocation {
    NSString *key = [self cacheKeyForType:CacheKeyTypeUsingHookLocation];
    [[NSUserDefaults standardUserDefaults] setBool:usingHookLocation
                                            forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (CLLocationDegrees)latitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:[self cacheKeyForType:CacheKeyTypeLatitude]];
}
- (void)setLatitude:(CLLocationDegrees)latitude {
    NSString *key = [self cacheKeyForType:CacheKeyTypeLatitude];
    [[NSUserDefaults standardUserDefaults] setDouble:latitude
                                              forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (CLLocationDegrees)longitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:[self cacheKeyForType:CacheKeyTypeLongitude]];
}
- (void)setLongitude:(CLLocationDegrees)longitude {
    NSString *key = [self cacheKeyForType:CacheKeyTypeLongitude];
    [[NSUserDefaults standardUserDefaults] setDouble:longitude
                                              forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (CLLocationDegrees)backupLatitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:[self cacheKeyForType:CacheKeyTypeBackupLatitude]];
}
- (void)setBackupLatitude:(CLLocationDegrees)backupLatitude {
    NSString *key = [self cacheKeyForType:CacheKeyTypeBackupLatitude];
    [[NSUserDefaults standardUserDefaults] setDouble:backupLatitude
                                              forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (CLLocationDegrees)backupLongitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:[self cacheKeyForType:CacheKeyTypeBackupLongitude]];
}
- (void)setBackupLongitude:(CLLocationDegrees)backupLongitude {
    NSString *key = [self cacheKeyForType:CacheKeyTypeBackupLongitude];
    [[NSUserDefaults standardUserDefaults] setDouble:backupLongitude
                                              forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (double)range {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:[self cacheKeyForType:CacheKeyTypeRange]];
}
- (void)setRange:(double)range {
    NSString *key = [self cacheKeyForType:CacheKeyTypeRange];
    [[NSUserDefaults standardUserDefaults] setDouble:range
                                              forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
