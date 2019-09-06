//
//  TLocationManager.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TLocationManager : NSObject

@property (class, nonatomic, assign, readonly) TLocationManager *shared;

/// 当前使用的名称
@property (nonatomic, copy  ) NSString *locationName;
/// 当前使用的纬度
@property (nonatomic, assign) CLLocationDegrees latitude;
/// 当前使用的经度
@property (nonatomic, assign) CLLocationDegrees longitude;
/// 扩散范围, 默认为 10
@property (nonatomic, assign) NSInteger range;
/// 是否使用
@property (nonatomic, assign) BOOL usingHookLocation;
/// 是否开启 toast 提示
@property (nonatomic, assign) BOOL usingToast;

/// 缓存的所有位置数据
@property (nonatomic, copy, nullable) NSArray<TLocationModel *> *cacheDataArray;


/// 是否有缓存数据, 都为 0 判断为无数据
@property (nonatomic, assign, readonly) BOOL hasCachedLocation;
/// 取随机纬度 (根据当前纬度以及扩散范围生成)
@property (nonatomic, assign, readonly) CLLocationDegrees randomLatitude;
/// 取随机经度 (根据当前经度以及扩散范围生成)
@property (nonatomic, assign, readonly) CLLocationDegrees randomLongitude;
/// 取随机坐标国测局编码 (根据当前经度,纬度以及扩散范围生成)
@property (nonatomic, assign, readonly) CLLocationCoordinate2D randomGCJ02Coordinate;
/// 取随机坐标 (根据当前经度,纬度以及扩散范围生成)
@property (nonatomic, assign, readonly) CLLocationCoordinate2D randomWGS84Coordinate;

@end

NS_ASSUME_NONNULL_END
