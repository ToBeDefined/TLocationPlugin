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

#import "NSObject+LocationPlugin.h"
#import "Defines.h"
#import "iBoxSafeRuntimeCFunc.h"
#import <CoreLocation/CoreLocation.h>

// CLLocationManagerDelegate

@implementation NSObject (LocationPlugin)

+ (void)load {
    Class JWeixinNativeCodeHandler_getLocation_Class = CLASS(JWeixinNativeCodeHandler_getLocation);
    if (JWeixinNativeCodeHandler_getLocation_Class != Nil) {
        [self replaceCLLocationsFunctionToClass:JWeixinNativeCodeHandler_getLocation_Class];
    }
    Class QMapView_Class = CLASS(JWeixinNativeCodeHandler_getLocation);
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
    [self __t_locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
}

- (void)__t_locationManager:(CLLocationManager *)manager
         didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self __t_locationManager:manager didUpdateLocations:locations];
}

@end

