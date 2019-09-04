//
//  CashBoxSafeRuntimeCFunc.h
//  CashBox
//
//  Created by TBD on 2018/4/19.
//  Copyright (C) 2011-2019 ShenZhen iBOXCHAIN Information Technology Co.,Ltd.
//                           All right reserved.
//
//  This  software  is  the  confidential  and  proprietary  information  of
//  iBOXCHAIN  Company  of  China. ("Confidential Information").  You  shall  not
//  disclose such Confidential Information and shall use it only in accordance
//  with the terms of the contract agreement you entered into with iBOXCHAIN inc.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif
    
    void ibox_add_instance_method(Class cls,
                                  SEL sel);
    
    void ibox_add_class_method(Class cls,
                               SEL sel);
    
    void ibox_exchange_instance_method(Class cls,
                                       SEL originalSel,
                                       SEL swizzledSel);
    
    void ibox_exchange_class_method(Class cls,
                                    SEL originalSel,
                                    SEL swizzledSel);
    
#ifdef __cplusplus
} // extern "C"
#endif

NS_ASSUME_NONNULL_END
