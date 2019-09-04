//
//  TSetLocationViewController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
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


#pragma mark - Setter/Getter
static BOOL _t_isShowing = NO;
+ (BOOL)isShowing {
    return _t_isShowing;
}

+ (void)setIsShowing:(BOOL)isShowing {
    _t_isShowing = isShowing;
}

#pragma mark - Life Cycle
- (void)dealloc {
    if (self->_manger) {
        [self->_manger stopUpdatingLocation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0;
}

- (CLLocationManager *)manger {
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
    TSetLocationViewController.isShowing = NO;
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"保存到缓存后, hook 将使用配置的数据"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CLLocationDegrees latitude = [self.latitudeTextField.text doubleValue];
        CLLocationDegrees longitude = [self.longitudeTextField.text doubleValue];
        NSInteger range = [self.rangeTextField.text integerValue];
        TSetLocationCache.shared.latitude = latitude;
        TSetLocationCache.shared.longitude = longitude;
        TSetLocationCache.shared.range = range;
    }]];
}

/// 保存到备份缓存
- (IBAction)storageLocationToBackupCache:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"保存到备份缓存, 仅供数据备份, hook 函数中并不使用备份的数据"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CLLocationDegrees latitude = [self.latitudeTextField.text doubleValue];
        CLLocationDegrees longitude = [self.longitudeTextField.text doubleValue];
        TSetLocationCache.shared.backupLatitude = latitude;
        TSetLocationCache.shared.backupLongitude = longitude;
    }]];
}

- (IBAction)usingHookLocationValueChanged:(UISwitch *)sender {
    TSetLocationCache.shared.usingHookLocation = sender.isEnabled;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:sender.isEnabled ? @"已开启" : @"已关闭"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    CLLocationCoordinate2D coordinate = location.coordinate;
    self.latitudeTextField.text = @(coordinate.latitude).stringValue;
    self.longitudeTextField.text = @(coordinate.longitude).stringValue;
}

@end
