//
//  TLocationChangeAppICONViewController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/9.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TLocationChangeAppICONViewController.h"
#import "UIWindow+TLocationPluginToast.h"

@interface TLocationChangeAppICONViewController ()

@property (strong, nonatomic) IBOutlet UIButton *weWork;
@property (strong, nonatomic) IBOutlet UIButton *dingDing;
@property (strong, nonatomic) IBOutlet UIButton *lark;
@property (strong, nonatomic) IBOutlet UIButton *neiXin;
@property (strong, nonatomic) IBOutlet UIButton *qq;
@property (strong, nonatomic) IBOutlet UIButton *tim;
@property (strong, nonatomic) IBOutlet UIButton *weChat;

@end

@implementation TLocationChangeAppICONViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改图标";
}

- (IBAction)changeIconButtonClicked:(UIButton *)sender {
    if (@available(iOS 10.3, *)) {
        if (!UIApplication.sharedApplication.supportsAlternateIcons) {
            [UIWindow t_showTostForMessage:@"App不支持切换图标"];
            return;
        }
        
        NSString *iconName;
        if (sender == self.weWork) {
            iconName = @"WeWork";
        }
        if (sender == self.dingDing) {
            iconName = @"DingDing";
        }
        if (sender == self.lark) {
            iconName = @"Lark";
        }
        if (sender == self.neiXin) {
            iconName = @"NeiXin";
        }
        if (sender == self.qq) {
            iconName = @"QQ";
        }
        if (sender == self.tim) {
            iconName = @"Tim";
        }
        if (sender == self.weChat) {
            iconName = @"WeChat";
        }
        [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSString *toastMessage = [NSString stringWithFormat:@"App切换图标错误:\n%@", error];
                [UIWindow t_showTostForMessage:toastMessage];
            }
        }];
    } else {
        [UIWindow t_showTostForMessage:@"10.3以下系统不支持切换图标"];
    }
}

@end
