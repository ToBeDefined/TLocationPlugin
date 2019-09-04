//
//  TSetLocationViewController.m
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

#import "TSetLocationViewController.h"
#import "TSetLocationCache.h"

@interface TSetLocationViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *contentView;
@property (nonatomic, strong) IBOutlet UITextField *latitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *longitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *rangeTextField;
@property (nonatomic, strong) CLLocationManager * manger;

@end

@implementation TSetLocationViewController

- (void)dealloc {
    if (self->_manger) {
        [self->_manger stopUpdatingLocation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0;
//    CLLocationDegrees latitude;
//    CLLocationDegrees longitude;
}

-(CLLocationManager *)manger {
    if (_manger != nil) {
        return _manger;
    }
    _manger = [[CLLocationManager alloc] init];
    _manger.delegate = self;
    _manger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [_manger requestAlwaysAuthorization];             //永久获取定位的权限
    [_manger requestWhenInUseAuthorization];            //使用时获取定位的权限
    return _manger;
}

- (IBAction)closeSetLocationViewController:(UIButton *)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/// 显示真实位置
- (IBAction)showRealLocation:(UIButton *)sender {
    [self.manger startUpdatingLocation];
}

/// 显示缓存的位置
- (IBAction)showCacheLocation:(UIButton *)sender {
    CLLocationDegrees latitude = TSetLocationCache.shared.latitude;
    CLLocationDegrees longitude = TSetLocationCache.shared.longitude;
    self.latitudeTextField.text = @(latitude).stringValue;
    self.longitudeTextField.text = @(longitude).stringValue;
}

/// 显示备份缓存的位置
- (IBAction)showBackupCacheLocation:(UIButton *)sender {
    CLLocationDegrees latitude = TSetLocationCache.shared.backupLatitude;
    CLLocationDegrees longitude = TSetLocationCache.shared.backupLongitude;
    self.latitudeTextField.text = @(latitude).stringValue;
    self.longitudeTextField.text = @(longitude).stringValue;
}

/// 保存到缓存
- (IBAction)storageLocationToCache:(UIButton *)sender {
    CLLocationDegrees latitude = [self.latitudeTextField.text doubleValue];
    CLLocationDegrees longitude = [self.longitudeTextField.text doubleValue];
    NSInteger range = [self.rangeTextField.text integerValue];
    TSetLocationCache.shared.latitude = latitude;
    TSetLocationCache.shared.longitude = longitude;
    TSetLocationCache.shared.range = range;
}

/// 保存到备份缓存
- (IBAction)storageLocationToBackupCache:(UIButton *)sender {
    CLLocationDegrees latitude = [self.latitudeTextField.text doubleValue];
    CLLocationDegrees longitude = [self.longitudeTextField.text doubleValue];
    TSetLocationCache.shared.backupLatitude = latitude;
    TSetLocationCache.shared.backupLongitude = longitude;
}

- (IBAction)usingHookLocationValueChanged:(UISwitch *)sender {
    TSetLocationCache.shared.usingHookLocation = sender.isEnabled;
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    CLLocationCoordinate2D coordinate = location.coordinate;
    self.latitudeTextField.text = @(coordinate.latitude).stringValue;
    self.longitudeTextField.text = @(coordinate.longitude).stringValue;
}

@end
