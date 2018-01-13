//
//  ExchangeMethod+NSObject.swift
//  xiaoyun
//
//  Created by 123 on 2018/1/9.
//  Copyright © 2018年 李泰良. All rights reserved.
//

import Foundation
extension NSObject{
    /*!
     交换实例方法
     */
    public static func exchangeInstanceImplementations(_ func1:Selector , func2:Selector){
        method_exchangeImplementations(class_getInstanceMethod(self, func1)!, class_getInstanceMethod(self, func2)!);
    }
    /*!
     交换类方法
     */
    public static func exchangeClassImplementations(_ func1:Selector , func2:Selector){
        method_exchangeImplementations(class_getClassMethod(self, func1)!, class_getClassMethod(self, func2)!);
    }
    
    public func performBlock(_ block: @escaping () -> Void , afterDelay:Double){
        //Swift 不允许数据在计算中损失,所以需要在计算的时候转换以下类型
        let time = Int64(afterDelay * Double(NSEC_PER_SEC))
        let t:DispatchTime = DispatchTime.now() + Double(time) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        //        DispatchQueue.main.after(when: t, execute: block)
        //        DispatchQueue.main.after(when: t, block: block)
        
    }
}
