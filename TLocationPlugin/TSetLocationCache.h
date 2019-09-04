//
//  TSetLocationCache.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSetLocationCache : NSObject

@property(class, nonatomic, assign, readonly) TSetLocationCache *shared;

@property(nonatomic, assign) BOOL usingHookLocation;
@property(nonatomic, assign) CLLocationDegrees latitude;
@property(nonatomic, assign) CLLocationDegrees longitude;

@property(nonatomic, assign) CLLocationDegrees backupLatitude;
@property(nonatomic, assign) CLLocationDegrees backupLongitude;
@property(nonatomic, assign) NSInteger range;

@end

NS_ASSUME_NONNULL_END
