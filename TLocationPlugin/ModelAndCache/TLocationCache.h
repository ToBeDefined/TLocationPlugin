//
//  TLocationCache.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLocationCache : NSObject

@property (class, nonatomic, assign, readonly) TLocationCache *shared;

@property (nonatomic, assign) BOOL usingHookLocation;
@property (nonatomic, copy  ) NSString *locationName;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
// default 10
@property (nonatomic, assign) NSInteger range;

@property (nonatomic, copy, nullable) NSArray<TLocationModel *> *cacheDataArray;

@end

NS_ASSUME_NONNULL_END
