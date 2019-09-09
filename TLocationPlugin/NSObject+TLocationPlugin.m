//
//  NSObject+TLocationPlugin.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "NSObject+TLocationPlugin.h"
#import "TSafeRuntimeCFunc.h"
#import "TLocationManager.h"
#import "UIWindow+TLocationPluginToast.h"

@implementation NSObject (TLocationPlugin)

+ (void)load {
    /// 企业微信的类
    NSArray<NSString *> *classStrings = @[
        @"WWKOpenApiCorpAppDetailController",
        @"WWKLocationRetrieverBaseTask",
        @"WWKLocationRetrieve",
        @"JWeixinPlugin_Beacon",
        @"WWKWXWebViewController",
        @"WWKAttendanceCheckViewController",
        @"JWeixinNativeCodeHandler_getLocation",
        @"WAJSContextPlugin_Beacon",
        @"MMLocationMgr",
        @"QMapView",
    ];
    for (NSString *classString in classStrings) {
        Class cls = NSClassFromString(classString);
        if (cls != Nil) {
            [self replaceCLLocationsFunctionToClass:cls];
        }
    }
}

+ (void)replaceCLLocationsFunctionToClass:(Class)cls {
    if ([cls instancesRespondToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)]) {
        t_exchange_instance_method(cls,
                                   @selector(locationManager:didUpdateToLocation:fromLocation:),
                                   @selector(__t_locationManager:didUpdateToLocation:fromLocation:));
    }
    
    if ([cls instancesRespondToSelector:@selector(locationManager:didUpdateLocations:)]) {
        t_exchange_instance_method(cls,
                                   @selector(locationManager:didUpdateLocations:),
                                   @selector(__t_locationManager:didUpdateLocations:));
    }
}

- (void)__t_locationManager:(CLLocationManager *)manager
        didUpdateToLocation:(CLLocation *)newLocation
               fromLocation:(CLLocation *)oldLocation API_AVAILABLE(macos(10.6)) {
    BOOL useHook = TLocationManager.shared.usingHookLocation && TLocationManager.shared.hasCachedLocation;
    if (!useHook) {
        if (TLocationManager.shared.usingToast) {
            [UIWindow t_showTostForCLLocation:newLocation];
        }
        [self __t_locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
        return;
    }
    
    /// CLLocation 使用WGS84坐标
    CLLocation *t_newLocation = [[CLLocation alloc] initWithCoordinate:TLocationManager.shared.randomWGS84Coordinate
                                                              altitude:newLocation.altitude
                                                    horizontalAccuracy:newLocation.horizontalAccuracy
                                                      verticalAccuracy:newLocation.verticalAccuracy
                                                                course:newLocation.course
                                                                 speed:newLocation.speed
                                                             timestamp:newLocation.timestamp];
    if (TLocationManager.shared.usingToast) {
        [UIWindow t_showTostForCLLocation:t_newLocation];
    }
    [self __t_locationManager:manager didUpdateToLocation:t_newLocation fromLocation:oldLocation];
}

- (void)__t_locationManager:(CLLocationManager *)manager
         didUpdateLocations:(NSArray<CLLocation *> *)locations {
    BOOL useHook = TLocationManager.shared.usingHookLocation && TLocationManager.shared.hasCachedLocation;
    if (!useHook) {
        if (TLocationManager.shared.usingToast) {
            [UIWindow t_showTostForCLLocations:locations];
        }
        [self __t_locationManager:manager didUpdateLocations:locations];
        return;
    }
    NSMutableArray<CLLocation *> *t_locations = [NSMutableArray<CLLocation *> array];
    for (CLLocation *location in locations) {
        /// CLLocation 使用WGS84坐标
        CLLocation *t_location = [[CLLocation alloc] initWithCoordinate:TLocationManager.shared.randomWGS84Coordinate
                                                               altitude:location.altitude
                                                     horizontalAccuracy:location.horizontalAccuracy
                                                       verticalAccuracy:location.verticalAccuracy
                                                                 course:location.course
                                                                  speed:location.speed
                                                              timestamp:location.timestamp];
        [t_locations addObject:t_location];
    }
    
    if (TLocationManager.shared.usingToast) {
        [UIWindow t_showTostForCLLocations:t_locations];
    }
    [self __t_locationManager:manager didUpdateLocations:t_locations];
}

@end

