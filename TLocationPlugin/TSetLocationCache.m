//
//  TSetLocationCache.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
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

//- (NSString *)cacheKeyForType:(CacheKeyType)type {
//    switch (type) {
//        case CacheKeyTypeUsingHookLocation:
//            return @"_T_CacheKeyTypeUsingHookLocation";
//        case CacheKeyTypeLatitude:
//            return @"_T_CacheKeyTypeLatitude";
//        case CacheKeyTypeLongitude:
//            return @"_T_CacheKeyTypeLongitude";
//        case CacheKeyTypeBackupLatitude:
//            return @"_T_CacheKeyTypeBackupLatitude";
//        case CacheKeyTypeBackupLongitude:
//            return @"_T_CacheKeyTypeBackupLongitude";
//        case CacheKeyTypeRange:
//            return @"_T_CacheKeyTypeRange";
//        default:
//            return nil;
//    }
//}

static NSString * const _t_latitudeKey = @"_T_CacheKeyTypeLatitude";
- (CLLocationDegrees)latitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:_t_latitudeKey];
}
- (void)setLatitude:(CLLocationDegrees)latitude {
    [[NSUserDefaults standardUserDefaults] setDouble:latitude
                                              forKey:_t_latitudeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

static NSString * const _t_longitudeKey = @"_T_CacheKeyTypeLongitude";
- (CLLocationDegrees)longitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:_t_longitudeKey];
}
- (void)setLongitude:(CLLocationDegrees)longitude {
    [[NSUserDefaults standardUserDefaults] setDouble:longitude
                                              forKey:_t_longitudeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


static NSString * const _t_backupLatitudeKey = @"_T_CacheKeyTypeBackupLatitude";
- (CLLocationDegrees)backupLatitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:_t_backupLatitudeKey];
}
- (void)setBackupLatitude:(CLLocationDegrees)backupLatitude {
    [[NSUserDefaults standardUserDefaults] setDouble:backupLatitude
                                              forKey:_t_backupLatitudeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

static NSString * const _t_backupLongitudeKey = @"_T_CacheKeyTypeBackupLongitude";
- (CLLocationDegrees)backupLongitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:_t_backupLongitudeKey];
}
- (void)setBackupLongitude:(CLLocationDegrees)backupLongitude {
    [[NSUserDefaults standardUserDefaults] setDouble:backupLongitude
                                              forKey:_t_backupLongitudeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

static NSString * const _t_rangeKey = @"_T_CacheKeyTypeRange";
- (NSInteger)range {
    return [[NSUserDefaults standardUserDefaults] integerForKey:_t_rangeKey];
}
- (void)setRange:(NSInteger)range {
    [[NSUserDefaults standardUserDefaults] setInteger:range
                                               forKey:_t_rangeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
