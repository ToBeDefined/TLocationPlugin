//
//  TSetLocationViewController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TSetLocationViewController.h"
#import "TSelectLocationDataViewController.h"
#import "TLocationNavigationController.h"
#import "TLocationManager.h"
#import "UIImage+TLocationPlugin.h"

@interface TSetLocationViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, strong) IBOutlet UITextField *latitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *longitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *rangeTextField;
@property (nonatomic, strong) IBOutlet UISwitch *usingHookSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *usingToastSwitch;

@end

@implementation TSetLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置缓存";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage t_imageNamed:@"close"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(closeSetLocationViewController:)];
    NSString *locationName = TLocationManager.shared.locationName;
    CLLocationDegrees latitude = TLocationManager.shared.latitude;
    CLLocationDegrees longitude = TLocationManager.shared.longitude;
    NSInteger range = TLocationManager.shared.range;
    BOOL isUsingHook = TLocationManager.shared.usingHookLocation;
    BOOL isUsingToast = TLocationManager.shared.usingToast;
    self.locationNameLabel.text = locationName;
    self.latitudeTextField.text = @(latitude).stringValue;
    self.longitudeTextField.text = @(longitude).stringValue;
    self.rangeTextField.text = @(range).stringValue;
    self.usingHookSwitch.on = isUsingHook;
    self.usingToastSwitch.on = isUsingToast;
}

- (void)closeSetLocationViewController:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        TLocationNavigationController.isShowing = NO;
    }];
}

/// 选择数据
- (IBAction)selectLocationData:(UIButton *)sender {
    [self.view endEditing:YES];
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
    [self.view endEditing:YES];
    CLLocationDegrees latitude = [self.latitudeTextField.text doubleValue];
    CLLocationDegrees longitude = [self.longitudeTextField.text doubleValue];
    NSInteger range = [self.rangeTextField.text integerValue];
    
    TLocationManager.shared.locationName = self.locationNameLabel.text;
    TLocationManager.shared.latitude = latitude;
    TLocationManager.shared.longitude = longitude;
    TLocationManager.shared.range = range;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"保存成功"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

/// 开关
- (IBAction)usingHookLocationValueChanged:(UISwitch *)sender {
    [self.view endEditing:YES];
    TLocationManager.shared.usingHookLocation = sender.isOn;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:sender.isOn ? @"已开启" : @"已关闭"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)usingToastValueChanged:(UISwitch *)sender {
    [self.view endEditing:YES];
    TLocationManager.shared.usingToast = sender.isOn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.latitudeTextField) {
        [self.longitudeTextField becomeFirstResponder];
        return NO;
    }
    if (textField == self.longitudeTextField) {
        [self.rangeTextField becomeFirstResponder];
        return NO;
    }
    [self.view endEditing:YES];
    return YES;
}

@end
