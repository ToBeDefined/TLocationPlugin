//
//  NSObject+LocationPlugin.m
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

#import <CoreLocation/CoreLocation.h>
#import "NSObject+LocationPlugin.h"
#import "iBoxSafeRuntimeCFunc.h"
#import "TSetLocationCache.h"


#define CLASS(_cls) NSClassFromString(@#_cls)

// CLLocationManagerDelegate

@implementation NSObject (LocationPlugin)

+ (void)load {
    Class JWeixinNativeCodeHandler_getLocation_Class = CLASS(JWeixinNativeCodeHandler_getLocation);
    if (JWeixinNativeCodeHandler_getLocation_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:JWeixinNativeCodeHandler_getLocation_Class];
    }
    Class QMapView_Class = CLASS(QMapView);
    if (QMapView_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:QMapView_Class];
    }
}

+ (void)replaceCLLocationsFunctionToClass:(Class)cls {
    
    if ([cls instancesRespondToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)]) {
        ibox_exchange_instance_method(cls,
                                      @selector(locationManager:didUpdateToLocation:fromLocation:),
                                      @selector(__t_locationManager:didUpdateToLocation:fromLocation:));
    }
    
    if ([cls instancesRespondToSelector:@selector(locationManager:didUpdateLocations:)]) {
        ibox_exchange_instance_method(cls,
                                      @selector(locationManager:didUpdateLocations:),
                                      @selector(__t_locationManager:didUpdateLocations:));
    }
}

- (void)__t_locationManager:(CLLocationManager *)manager
        didUpdateToLocation:(CLLocation *)newLocation
               fromLocation:(CLLocation *)oldLocation API_AVAILABLE(macos(10.6)) {
    if (!TSetLocationCache.shared.usingHookLocation) {
        [self __t_locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
        return;
    }
    
    CLLocationDegrees latitude = TSetLocationCache.shared.latitude + [self rangeDegress];
    CLLocationDegrees longitude = TSetLocationCache.shared.longitude + [self rangeDegress];
    CLLocation *t_newLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    [self __t_locationManager:manager didUpdateToLocation:t_newLocation fromLocation:oldLocation];
}

- (void)__t_locationManager:(CLLocationManager *)manager
         didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!TSetLocationCache.shared.usingHookLocation) {
        [self __t_locationManager:manager didUpdateLocations:locations];
        return;
    }
    
    CLLocationDegrees latitude1 = TSetLocationCache.shared.latitude + [self rangeDegress];
    CLLocationDegrees longitude1 = TSetLocationCache.shared.longitude + [self rangeDegress];
    CLLocation *t_newLocation1 = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
    
    CLLocationDegrees latitude2 = TSetLocationCache.shared.latitude + [self rangeDegress];
    CLLocationDegrees longitude2 = TSetLocationCache.shared.longitude + [self rangeDegress];
    CLLocation *t_newLocation2 = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];
    
    CLLocationDegrees latitude3 = TSetLocationCache.shared.latitude + [self rangeDegress];
    CLLocationDegrees longitude3 = TSetLocationCache.shared.longitude + [self rangeDegress];
    CLLocation *t_newLocation3 = [[CLLocation alloc] initWithLatitude:latitude3 longitude:longitude3];
    [self __t_locationManager:manager didUpdateLocations:@[t_newLocation1, t_newLocation2, t_newLocation3]];
}

- (CLLocationDegrees)rangeDegress {
    NSInteger range = arc4random() % TSetLocationCache.shared.range;
    CLLocationDegrees degress = 1.0/100000.0 * range + (arc4random() % 1000) * 1.0/100000000.0;
    if (arc4random() % 2 == 0) return -degress;
    return degress;
}

@end

