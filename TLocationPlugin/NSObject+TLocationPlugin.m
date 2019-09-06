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

#define CLASS(_cls) NSClassFromString(@#_cls)

@implementation NSObject (TLocationPlugin)

+ (void)load {
    /// 企业微信的类
    Class WWKOpenApiCorpAppDetailController_Class = CLASS(WWKOpenApiCorpAppDetailController);
    if (WWKOpenApiCorpAppDetailController_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:WWKOpenApiCorpAppDetailController_Class];
    }
    Class WWKLocationRetrieverBaseTask_Class = CLASS(WWKLocationRetrieverBaseTask);
    if (WWKLocationRetrieverBaseTask_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:WWKLocationRetrieverBaseTask_Class];
    }
    Class WWKLocationRetrieve_Class = CLASS(WWKLocationRetrieve);
    if (WWKLocationRetrieve_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:WWKLocationRetrieve_Class];
    }
    Class JWeixinPlugin_Beacon_Class = CLASS(JWeixinPlugin_Beacon);
    if (JWeixinPlugin_Beacon_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:JWeixinPlugin_Beacon_Class];
    }
    Class WWKWXWebViewController_Class = CLASS(WWKWXWebViewController);
    if (WWKWXWebViewController_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:WWKWXWebViewController_Class];
    }
    Class WWKAttendanceCheckViewController_Class = CLASS(WWKAttendanceCheckViewController);
    if (WWKAttendanceCheckViewController_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:WWKAttendanceCheckViewController_Class];
    }
    
    Class JWeixinNativeCodeHandler_getLocation_Class = CLASS(JWeixinNativeCodeHandler_getLocation);
    if (JWeixinNativeCodeHandler_getLocation_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:JWeixinNativeCodeHandler_getLocation_Class];
    }
    Class WAJSContextPlugin_Beacon_Class = CLASS(WAJSContextPlugin_Beacon);
    if (WAJSContextPlugin_Beacon_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:WAJSContextPlugin_Beacon_Class];
    }
    Class MMLocationMgr_Class = CLASS(MMLocationMgr);
    if (MMLocationMgr_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:MMLocationMgr_Class];
    }
    Class QMapView_Class = CLASS(QMapView);
    if (QMapView_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:QMapView_Class];
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

