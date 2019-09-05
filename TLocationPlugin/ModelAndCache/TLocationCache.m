//
//  TLocationCache.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TLocationCache.h"

@implementation TLocationCache {
    NSArray<TLocationModel *> * _cacheDataArray;
}
@synthesize cacheDataArray = _cacheDataArray;

#pragma mark - Singletion
#pragma mark -

static TLocationCache *_instance;
+ (TLocationCache *)shared {
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

#pragma mark - locationName
static NSString * const _t_locationNameKey = @"_T_CacheKeyTypeLocationName";
- (NSString *)locationName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:_t_locationNameKey];
}
- (void)setLocationName:(NSString *)locationName {
    [[NSUserDefaults standardUserDefaults] setObject:locationName forKey:_t_locationNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - latitude
static NSString * const _t_latitudeKey = @"_T_CacheKeyTypeLatitude";
- (CLLocationDegrees)latitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:_t_latitudeKey];
}
- (void)setLatitude:(CLLocationDegrees)latitude {
    [[NSUserDefaults standardUserDefaults] setDouble:latitude forKey:_t_latitudeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - longitude
static NSString * const _t_longitudeKey = @"_T_CacheKeyTypeLongitude";
- (CLLocationDegrees)longitude {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:_t_longitudeKey];
}
- (void)setLongitude:(CLLocationDegrees)longitude {
    [[NSUserDefaults standardUserDefaults] setDouble:longitude forKey:_t_longitudeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - range
static NSString * const _t_rangeKey = @"_T_CacheKeyTypeRange";
- (NSInteger)range {
    NSInteger range = [[NSUserDefaults standardUserDefaults] integerForKey:_t_rangeKey];
    if (range == 0) {
        return 10;
    }
    return range;
}
- (void)setRange:(NSInteger)range {
    [[NSUserDefaults standardUserDefaults] setInteger:range forKey:_t_rangeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - usingHookLocation
static NSString * const _t_usingHookLocationKey = @"_T_CacheKeyTypeUsingHookLocation";
- (BOOL)usingHookLocation {
    return [[NSUserDefaults standardUserDefaults] boolForKey:_t_usingHookLocationKey];;
}
- (void)setUsingHookLocation:(BOOL)usingHookLocation {
    [[NSUserDefaults standardUserDefaults] setBool:usingHookLocation forKey:_t_usingHookLocationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - cacheDataArray
- (NSString *)cacheDataArrayArchivePath {
    static NSString *_t_cacheDataArrayArchivePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirPath = [paths lastObject];
        _t_cacheDataArrayArchivePath = [documentDirPath stringByAppendingPathComponent:@"_T_CacheKeyTypeDataArray.archiver"];
    });
    return _t_cacheDataArrayArchivePath;
}

- (NSArray<TLocationModel *> *)cacheDataArray {
    if (self->_cacheDataArray == nil) {
        NSString *path = self.cacheDataArrayArchivePath;
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            self->_cacheDataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
    }
    return self->_cacheDataArray;
}

- (void)setCacheDataArray:(NSArray<TLocationModel *> *)cacheDataArray {
    self->_cacheDataArray = cacheDataArray;
    NSString *path = self.cacheDataArrayArchivePath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    if (cacheDataArray != nil) {
        [NSKeyedArchiver archiveRootObject:cacheDataArray toFile:self.cacheDataArrayArchivePath];
    }
}

@end
