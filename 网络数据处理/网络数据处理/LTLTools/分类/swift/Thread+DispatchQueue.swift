//
//  Thread+DispatchQueue.swift
//  xiaoyun
//
//  Created by 123 on 2018/1/9.
//  Copyright © 2018年 李泰良. All rights reserved.
//

import Foundation
extension DispatchQueue
{
    public static func backgroundQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    }
    public static func utilityQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
    }
    public static func userInitiatedQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
    }
    public static func userInteractiveQueue()->DispatchQueue{
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
    }
    
    public static func globalQueue()->DispatchQueue{
        return DispatchQueue(label: "globalQueue");
    }
    
    ///安全同步到主线程
    public static func safeSyncInMain(execute work: @escaping @convention(block) () -> Swift.Void){
        let main:DispatchQueue = DispatchQueue.main
        if Thread.isMainThread {
            main.async(execute: work)
        }else{
            main.sync(execute: work)
        }
        //        print("425 wt test")
    }
    
    //异步回到主线程
    public static func asyncInMain(execute work: @escaping @convention(block) () -> Swift.Void){
        DispatchQueue.main.async(execute: work)
    }
    
    //到分线程中
    public static func asyncGlobalQueue(execute work: @escaping @convention(block) () -> Swift.Void){
        DispatchQueue.global().async(execute: work)
    }
    
}
