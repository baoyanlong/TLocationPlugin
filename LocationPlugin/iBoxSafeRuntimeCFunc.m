//
//  CashBoxSafeRuntimeCFunc.m
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

#import "iBoxSafeRuntimeCFunc.h"
#import <objc/runtime.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    void ibox_add_instance_method(Class cls, SEL sel) {
        Method method = class_getInstanceMethod(cls, sel);
        class_addMethod(cls,
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
    }
    
    void ibox_add_class_method(Class cls, SEL sel) {
        Method method = class_getClassMethod(cls, sel);
        class_addMethod(objc_getMetaClass(object_getClassName(cls)),
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
    }
    
    void ibox_exchange_instance_method(Class cls, SEL originalSel, SEL swizzledSel) {
        Method originalMethod = class_getInstanceMethod(cls, originalSel);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSel);
        
        // 交换实现进行添加函数
        BOOL addOriginSELSuccess = class_addMethod(cls,
                                                   originalSel,
                                                   method_getImplementation(swizzledMethod),
                                                   method_getTypeEncoding(swizzledMethod));
        BOOL addSwizzlSELSuccess = class_addMethod(cls,
                                                   swizzledSel,
                                                   method_getImplementation(originalMethod),
                                                   method_getTypeEncoding(originalMethod));
        // 全都添加成功，返回
        if (addOriginSELSuccess && addSwizzlSELSuccess) {
            return;
        }
        // 全都添加失败，已经添加过了方法，交换
        if (!addOriginSELSuccess && !addSwizzlSELSuccess) {
            method_exchangeImplementations(originalMethod,
                                           swizzledMethod);
            return;
        }
        // addOriginSELSuccess 成功，addSwizzlSELSuccess 失败，replace SwizzlSel
        if (addOriginSELSuccess && !addSwizzlSELSuccess) {
            class_replaceMethod(cls,
                                swizzledSel,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
            return;
        }
        // addSwizzlSELSuccess 成功，addOriginSELSuccess 失败，replace originSEL
        if (!addOriginSELSuccess && addSwizzlSELSuccess) {
            class_replaceMethod(cls,
                                originalSel,
                                method_getImplementation(swizzledMethod),
                                method_getTypeEncoding(swizzledMethod));
            return;
        }
    }
    
    void ibox_exchange_class_method(Class cls, SEL originalSel, SEL swizzledSel) {
        ibox_exchange_instance_method(objc_getMetaClass(object_getClassName(cls)),
                                      originalSel,
                                      swizzledSel);
    }
    
#ifdef __cplusplus
} // extern "C"
#endif

