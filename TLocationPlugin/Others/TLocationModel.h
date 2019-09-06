//
//  TLocationModel.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLocationModel : NSObject <NSCoding>

/// 名称
@property (nonatomic, copy) NSString *name;

/// 纬度
@property (nonatomic, assign) CLLocationDegrees latitude;

/// 经度
@property (nonatomic, assign) CLLocationDegrees longitude;

+ (instancetype)modelWithName:(NSString *)name
                     latitude:(CLLocationDegrees)latitude
                    longitude:(CLLocationDegrees)longitude;

+ (instancetype)modelWithSubLocality:(nullable NSString *)subLocality
                                name:(NSString *)name
                            latitude:(CLLocationDegrees)latitude
                           longitude:(CLLocationDegrees)longitude;

- (NSString *)locationText;

@end

NS_ASSUME_NONNULL_END
