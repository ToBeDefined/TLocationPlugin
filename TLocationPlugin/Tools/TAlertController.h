//
//  TAlertController.h
//  TLocationPlugin
//
//  Created by TBD on 2019/9/6.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAlertController: UIAlertController

/// 一个取消按钮
+ (instancetype)singleActionAlertWithTitle:(nullable NSString *)title
                                   message:(nullable NSString *)message
                               actionTitle:(nullable NSString *)actionTitle
                               actionBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))actionBlock;


/// confirmTitle 在左, cancelTitle 在右
+ (instancetype)confirmAlertWithTitle:(nullable NSString *)title
                              message:(nullable NSString *)message
                          cancelTitle:(nullable NSString *)cancelTitle
                          cancelBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))cancelBlock
                         confirmTitle:(nullable NSString *)confirmTitle
                         confirmBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))confirmBlock;

/// destructiveTitle 在左, cancelTitle 在右
+ (instancetype)destructiveAlertWithTitle:(nullable NSString *)title
                                  message:(nullable NSString *)message
                              cancelTitle:(nullable NSString *)cancelTitle
                              cancelBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))cancelBlock
                         destructiveTitle:(nullable NSString *)destructiveTitle
                         destructiveBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))destructiveBlock;

/// 编辑框
+ (instancetype)editAlertWithTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                        labelTexts:(nullable NSArray<NSString *> *)labelTexts
                     defaultValues:(nullable NSArray<NSString *> *)defaultValues
                       cancelTitle:(nullable NSString *)cancelTitle
                       cancelBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))cancelBlock
                      confirmTitle:(nullable NSString *)confirmTitle
                      confirmBlock:(void (^ __nullable)(TAlertController *alert, UIAlertAction *action))confirmBlock;
/// 翻转 Actions 顺序
- (void)reverseActions;
/// 添加 Action
- (void)addAction:(UIAlertAction *)action;
/// 删除 Action
- (void)removeAction:(UIAlertAction *)action;

@end

NS_ASSUME_NONNULL_END
