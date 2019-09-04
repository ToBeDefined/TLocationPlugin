//
//  TSetLocationCache.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@interface TSetLocationCache : NSObject

@property (class, nonatomic, assign, readonly) TSetLocationCache *shared;

@property (nonatomic, assign) BOOL usingHookLocation;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;

@property (nonatomic, assign) CLLocationDegrees backupLatitude;
@property (nonatomic, assign) CLLocationDegrees backupLongitude;
@property (nonatomic, assign) double range;

@end

NS_ASSUME_NONNULL_END
