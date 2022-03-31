//
//  TSafeRuntimeCFunc.h
//  TLocationPlugin
//
//  Created by TBD on 2018/4/19.
//  Copyright © 2019 TBD. All rights reserved.
//

#import "TSafeRuntimeCFunc.h"
#import <objc/runtime.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    void t_add_instance_method(Class cls, SEL sel) {
        Method method = class_getInstanceMethod(cls, sel);
        class_addMethod(cls,
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
    }
    
    void t_add_class_method(Class cls, SEL sel) {
        Method method = class_getClassMethod(cls, sel);
        class_addMethod(objc_getMetaClass(object_getClassName(cls)),
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
    }
    
    void t_exchange_instance_method(Class cls, SEL sel1, SEL sel2) {
        Method method1 = class_getInstanceMethod(cls, sel1);
        Method method2 = class_getInstanceMethod(cls, sel2);
        if (method1 == NULL || method2 == NULL) {
            NSLog(@"class: %@, no method for sel1: %@, or sel2: %@", cls, NSStringFromSelector(sel1), NSStringFromSelector(sel2));
        }
        
        IMP imp1 = method_getImplementation(method1);
        IMP imp2 = method_getImplementation(method2);
        
        const char *encode1 = method_getTypeEncoding(method1);
        const char *encode2 = method_getTypeEncoding(method2);
        if (strcmp(encode1, encode2) != 0) {
            NSLog(@"type encoding not same for: %@, sel1: %@, sel2: %@", cls, NSStringFromSelector(sel1), NSStringFromSelector(sel2));
            NSLog(@"sel1 type encoding: %s", encode1);
            NSLog(@"sel2 type encoding: %s", encode2);
        }
        
        // 交换实现进行添加函数
        class_replaceMethod(cls, sel1, imp2, encode2);
        class_replaceMethod(cls, sel2, imp1, encode1);
    }
    
    void t_exchange_class_method(Class cls, SEL sel1, SEL sel2) {
        t_exchange_instance_method(object_getClass(cls), sel1, sel2);
    }
    
#ifdef __cplusplus
} // extern "C"
#endif


