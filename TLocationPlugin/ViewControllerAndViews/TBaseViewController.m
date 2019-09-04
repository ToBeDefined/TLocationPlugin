//
//  TBaseViewController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/5.
//
//  Copyright (C) 2011-2019 ShenZhen iBOXCHAIN Information Technology Co.,Ltd. 
//                             All rights reserved.
//
//      This  software  is  the  confidential  and  proprietary  information  of
//  iBOXCHAIN  Company  of  China. ("Confidential Information"). You  shall  not
//  disclose such Confidential Information and shall use it only in accordance
//  with the terms of the contract agreement you entered into with iBOXCHAIN inc.
//

#import "TBaseViewController.h"
#import "NSBundle+TLocation.h"

@interface TBaseViewController ()

@end

@implementation TBaseViewController

- (instancetype)init {
    return [super initWithNibName:NSStringFromClass(self.class) bundle:NSBundle.t_bundle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = UIColor.lightGrayColor;
}

@end
