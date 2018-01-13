//
//  LTLToolclass.swift
//  xiaoyun
//
//  Created by 123 on 2018/1/9.
//  Copyright © 2018年 李泰良. All rights reserved.
//

import UIKit

class LTLToolclass: NSObject {

}
// MARK: - DEBUG执行的方法
public func DEBUGBlock(_ block:() -> Void){
    #if DEBUG
        block()
    #else
    #endif
}
// MARK: - 延时执行的代码块
/*!
 延时执行的代码块
 */
public func performOperation(with block:@escaping ()->Void, afterDelay:TimeInterval){
    //Swift 不允许数据在计算中损失,所以需要在计算的时候转换以下类型
    let time = Int64(afterDelay * Double(NSEC_PER_SEC))
    let t = DispatchTime.now() + Double(time) / Double(NSEC_PER_SEC)
    //    DispatchQueue.main.after(when: t, execute: block)
    DispatchQueue.main.asyncAfter(deadline: t, execute: block)
}
