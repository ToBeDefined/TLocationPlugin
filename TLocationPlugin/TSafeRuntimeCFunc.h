//
//  TSafeRuntimeCFunc.h
//  TLocationPlugin
//
//  Created by TBD on 2018/4/19.
//  Copyright © 2019 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif

void t_add_instance_method(Class cls,
                           SEL sel);

void t_add_class_method(Class cls,
                        SEL sel);

/// 先添加 后替换, 防止父类函数指针重复替换
void t_exchange_instance_method(Class cls,
                                SEL originalSel,
                                SEL swizzledSel);
/// 先添加 后替换, 防止父类函数指针重复替换
void t_exchange_class_method(Class cls,
                             SEL originalSel,
                             SEL swizzledSel);

#ifdef __cplusplus
} // extern "C"
#endif

NS_ASSUME_NONNULL_END
