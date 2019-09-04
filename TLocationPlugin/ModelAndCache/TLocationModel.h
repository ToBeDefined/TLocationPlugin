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

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;

+ (instancetype)modelWithSubLocality:(nullable NSString *)subLocality
                                name:(NSString *)name
                            latitude:(CLLocationDegrees)latitude
                           longitude:(CLLocationDegrees)longitude;

- (NSString *)locationText;

@end

NS_ASSUME_NONNULL_END
