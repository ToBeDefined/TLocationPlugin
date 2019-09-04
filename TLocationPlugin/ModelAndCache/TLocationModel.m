//
//  TLocationModel.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TLocationModel.h"

@implementation TLocationModel

+ (instancetype)modelWithSubLocality:(nullable NSString *)subLocality
                                name:(NSString *)name
                            latitude:(CLLocationDegrees)latitude
                           longitude:(CLLocationDegrees)longitude {
    return [[self alloc] initWithSubLocality:subLocality
                                        name:name
                                    latitude:latitude
                                   longitude:longitude];
}

- (instancetype)initWithSubLocality:(nullable NSString *)subLocality
                               name:(NSString *)name
                           latitude:(CLLocationDegrees)latitude
                          longitude:(CLLocationDegrees)longitude {
    self = [super init];
    if (self) {
        if (subLocality) {
            self.name = [NSString stringWithFormat:@"%@ %@", subLocality, name];
        } else {
            self.name = name;
        }
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

- (NSString *)locationText {
    return [NSString stringWithFormat:@"latitude : %@\nlongitude: %@", @(self.latitude).stringValue, @(self.longitude).stringValue];
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        self.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
    }
    return self;
}

@end
