//
//  TAlertController.m
//  TLocationPlugin
//
//  Created by TBD on 2019/9/6.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TAlertController.h"
#import "TLocationDefine.h"

@interface TAlertController ()

@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, strong) NSMutableArray<UIAlertAction *> *mutableActions;

@end

@implementation TAlertController

#pragma mark - 构造方法
+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                  confirmTitle:(NSString *)confirmTitle
                  confirmBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))confirmBlock
                   cancelTitle:(NSString *)cancelTitle
                   cancelBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))cancelBlock
                 isDestructive:(BOOL)isDestructive {
    TAlertController *alert = [self alertControllerWithTitle:title
                                                     message:message
                                              preferredStyle:UIAlertControllerStyleAlert];
    @weakify(alert);
    alert.view.tintColor = UIColor.blackColor;
    UIAlertAction *confirmAction = nil;
    UIAlertAction *cancelAction = nil;
    
    if (confirmTitle || confirmBlock) {
        confirmAction = [UIAlertAction actionWithTitle:confirmTitle ?: @"确定"
                                                 style:isDestructive ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
            @strongify(alert);
            if (confirmBlock) {
                confirmBlock(alert, action);
            }
        }];
    }
    if (cancelTitle || cancelBlock || confirmAction == nil) {
        cancelAction = [UIAlertAction actionWithTitle:cancelTitle ?: @"取消"
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * _Nonnull action) {
            @strongify(alert);
            if (cancelBlock) {
                cancelBlock(alert, action);
            }
        }];
    }
    
    if (confirmAction) {
        [alert addAction:confirmAction];
    }
    if (cancelAction) {
        [alert addAction:cancelAction];
    }
    return alert;
}

+ (instancetype)singleActionAlertWithTitle:(NSString *)title
                                   message:(NSString *)message
                               actionTitle:(NSString *)actionTitle
                               actionBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))actionBlock {
    return [self alertWithTitle:title
                        message:message
                   confirmTitle:actionTitle
                   confirmBlock:actionBlock
                    cancelTitle:nil
                    cancelBlock:nil
                  isDestructive:NO];
}

+ (instancetype)confirmAlertWithTitle:(NSString *)title
                              message:(NSString *)message
                          cancelTitle:(NSString *)cancelTitle
                          cancelBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))cancelBlock
                         confirmTitle:(NSString *)confirmTitle
                         confirmBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))confirmBlock {
    return [self alertWithTitle:title
                        message:message
                   confirmTitle:confirmTitle
                   confirmBlock:confirmBlock
                    cancelTitle:cancelTitle
                    cancelBlock:cancelBlock
                  isDestructive:NO];
}

+ (instancetype)destructiveAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                              cancelTitle:(NSString *)cancelTitle
                              cancelBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))cancelBlock
                         destructiveTitle:(NSString *)destructiveTitle
                         destructiveBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))destructiveBlock {
    return [self alertWithTitle:title
                        message:message
                   confirmTitle:destructiveTitle
                   confirmBlock:destructiveBlock
                    cancelTitle:cancelTitle
                    cancelBlock:cancelBlock
                  isDestructive:YES];
}

/// 编辑框
+ (instancetype)editAlertWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                        labelTexts:(nullable NSArray<NSString *> *)labelTexts
                     defaultValues:(nullable NSArray<NSString *> *)defaultValues
                       cancelTitle:(nullable NSString *)cancelTitle
                       cancelBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))cancelBlock
                      confirmTitle:(nullable NSString *)confirmTitle
                      confirmBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))confirmBlock {
    if (labelTexts.count == 0 && defaultValues.count == 0) {
        return [self confirmAlertWithTitle:title
                                   message:message
                               cancelTitle:cancelTitle
                               cancelBlock:cancelBlock
                              confirmTitle:confirmTitle
                              confirmBlock:confirmBlock];
    }
    TAlertController *alert = [TAlertController destructiveAlertWithTitle:title
                                                                  message:message
                                                              cancelTitle:cancelTitle
                                                              cancelBlock:cancelBlock
                                                         destructiveTitle:confirmTitle
                                                         destructiveBlock:confirmBlock];
    [alert reverseActions];
    BOOL isNeedLabel = NO;
    if (labelTexts.count != 0) {
        isNeedLabel = YES;
    }
    for (NSUInteger index=0; index<MAX(labelTexts.count, defaultValues.count); ++index) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            if (isNeedLabel) {
                NSString *text = @"";
                if (index < labelTexts.count) {
                    text = [labelTexts[index] stringByAppendingString:@": "];
                }
                UILabel *label = [[UILabel alloc] init];
                label.text = text;
                label.font = [UIFont systemFontOfSize:14];
                textField.leftView = label;
                textField.leftViewMode = UITextFieldViewModeAlways;
                textField.placeholder = text;
            }
            NSString *defaultValue = @"";
            if (index < defaultValues.count) {
                defaultValue = defaultValues[index];
            }
            textField.text = defaultValue;
        }];
    }
    return alert;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.isLoaded) {
        for (UIAlertAction *action in self.mutableActions) {
            [super addAction:action];
        }
        [super viewDidLoad];
    }
    [super viewWillAppear:animated];
}

#pragma mark - mutableActions Getter
- (NSMutableArray<UIAlertAction *> *)mutableActions {
    if (self->_mutableActions == nil) {
        self->_mutableActions = [NSMutableArray<UIAlertAction *> array];
    }
    return self->_mutableActions;
}

#pragma mark - Functions
- (void)reverseActions {
    // self.mutableActions = [self.mutableActions reverseObjectEnumerator].allObjects.mutableCopy;
    NSUInteger count = self.mutableActions.count;
    for (NSUInteger index=0; index<count/2; ++index) {
        [self.mutableActions exchangeObjectAtIndex:index withObjectAtIndex:count-1-index];
    }
}

- (void)addAction:(UIAlertAction *)action {
    [self.mutableActions addObject:action];
}

- (void)removeAction:(UIAlertAction *)action {
    [self.mutableActions removeObject:action];
}

@end
