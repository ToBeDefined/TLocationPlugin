//
//  TLocationSettingViewController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/4.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TLocationSettingViewController.h"
#import "TSelectLocationDataViewController.h"
#import "TLocationManager.h"
#import "UIImage+TLocationPlugin.h"
#import "TAlertController.h"
#import "UIWindow+TLocationPluginToast.h"

@interface TLocationSettingViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, strong) IBOutlet UITextField *latitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *longitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *rangeTextField;
@property (nonatomic, strong) IBOutlet UISwitch *usingHookSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *usingToastSwitch;

@end

@implementation TLocationSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(tapScrollView)];
    [self.contentScrollView addGestureRecognizer:sigleTap];
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

- (void)tapScrollView {
    [self.view endEditing:YES];
}

/// 开关
- (IBAction)usingHookLocationValueChanged:(UISwitch *)sender {
    [self.view endEditing:YES];
    TLocationManager.shared.usingHookLocation = sender.isOn;
    [UIWindow t_showTostForMessage:sender.isOn ? @"已开启位置拦截" : @"已关闭位置拦截"];
}

- (IBAction)usingToastValueChanged:(UISwitch *)sender {
    [self.view endEditing:YES];
    TLocationManager.shared.usingToast = sender.isOn;
    [UIWindow t_showTostForMessage:sender.isOn ? @"已开启定位提示" : @"已关闭定位提速"];
}

- (IBAction)cleanCacheData:(UIButton *)sender {
    TAlertController *alert = [TAlertController destructiveAlertWithTitle:@"确定清空已保存数据?"
                                                                  message:nil
                                                              cancelTitle:@"取消"
                                                              cancelBlock:nil
                                                         destructiveTitle:@"确定"
                                                         destructiveBlock:^(TAlertController * _Nonnull alert, UIAlertAction * _Nonnull action) {
        TLocationManager.shared.cacheDataArray = nil;
        [TLocationManager.shared saveCacheDataArray];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.rangeTextField) {
        NSInteger range = [self.rangeTextField.text integerValue];
        if (TLocationManager.shared.range != range) {
            TLocationManager.shared.range = range;
            NSString *tostText = [NSString stringWithFormat:@"已保存范围: %ld", range];
            [UIWindow t_showTostForMessage:tostText];
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
