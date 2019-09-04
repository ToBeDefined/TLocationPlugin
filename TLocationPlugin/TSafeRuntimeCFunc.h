//
//  TSafeRuntimeCFunc.h
//  CashBox
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

void t_exchange_instance_method(Class cls,
                                SEL originalSel,
                                SEL swizzledSel);

void t_exchange_class_method(Class cls,
                             SEL originalSel,
                             SEL swizzledSel);

#ifdef __cplusplus
} // extern "C"
#endif

NS_ASSUME_NONNULL_END
