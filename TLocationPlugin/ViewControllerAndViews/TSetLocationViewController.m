//
//  TSetLocationViewController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TSetLocationViewController.h"
#import "TSelectLocationDataViewController.h"
#import "TLocationCache.h"
#import "UIImage+TLocation.h"

@interface TSetLocationViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, strong) IBOutlet UITextField *latitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *longitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *rangeTextField;
@property (nonatomic, strong) IBOutlet UISwitch *usingSwitch;

@end

@implementation TSetLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage t_imageNamed:@"close"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(closeSetLocationViewController:)];
    NSString *locationName = TLocationCache.shared.locationName;
    CLLocationDegrees latitude = TLocationCache.shared.latitude;
    CLLocationDegrees longitude = TLocationCache.shared.longitude;
    NSInteger range = TLocationCache.shared.range;
    BOOL isUsing = TLocationCache.shared.usingHookLocation;
    
    self.locationNameLabel.text = locationName;
    self.latitudeTextField.text = @(latitude).stringValue;
    self.longitudeTextField.text = @(longitude).stringValue;
    self.rangeTextField.text = @(range).stringValue;
    self.usingSwitch.on = isUsing;
}

- (void)closeSetLocationViewController:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 选择数据
- (IBAction)selectLocationData:(UIButton *)sender {
    TSelectLocationDataViewController *vc = [[TSelectLocationDataViewController alloc] init];
    vc.selectLocationBlock = ^(TLocationModel * _Nonnull model) {
        self.locationNameLabel.text = model.name;
        self.latitudeTextField.text = @(model.latitude).stringValue;
        self.longitudeTextField.text = @(model.longitude).stringValue;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/// 保存到缓存
- (IBAction)storageLocationToCache:(UIButton *)sender {
    CLLocationDegrees latitude = [self.latitudeTextField.text doubleValue];
    CLLocationDegrees longitude = [self.longitudeTextField.text doubleValue];
    NSInteger range = [self.rangeTextField.text integerValue];
    
    TLocationCache.shared.locationName = self.locationNameLabel.text;
    TLocationCache.shared.latitude = latitude;
    TLocationCache.shared.longitude = longitude;
    TLocationCache.shared.range = range;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"保存成功"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

/// 开关
- (IBAction)usingHookLocationValueChanged:(UISwitch *)sender {
    TLocationCache.shared.usingHookLocation = sender.isOn;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:sender.isOn ? @"已开启" : @"已关闭"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
