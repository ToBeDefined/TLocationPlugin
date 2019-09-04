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

@interface TSetLocationViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *contentView;

@property (nonatomic, strong) IBOutlet UITextField *latitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *longitudeTextField;
@property (nonatomic, strong) IBOutlet UITextField *rangeTextField;

@end

@implementation TSetLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0;
//    CLLocationDegrees latitude;
//    CLLocationDegrees longitude;
}

- (IBAction)closeSetLocationViewController:(UIButton *)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)showRealLocation:(UIButton *)sender {
}

- (IBAction)showCacheLocation:(UIButton *)sender {
}

- (IBAction)showBackupCacheLocation:(UIButton *)sender {
}

- (IBAction)storageLocationToCache:(UIButton *)sender {
}

- (IBAction)storageLocationToBackupCache:(UIButton *)sender {
}

- (IBAction)usingHookLocationValueChanged:(UISwitch *)sender {
    if (sender.isEnabled) {
        
    }
}


@end
