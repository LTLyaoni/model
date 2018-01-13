//
//  Queue+OperationQueue.swift
//  xiaoyun
//
//  Created by 123 on 2018/1/9.
//  Copyright © 2018年 李泰良. All rights reserved.
//

import Foundation

extension OperationQueue{
    
    
    
    /**
     到默认的全局队列做事情
     优先级是默认的
     */
    public static func globalQueue(execute work: @escaping @convention(block) () -> Swift.Void)->Void{
        globalQueue(qos: .default,execute: work)
    }
    
    
    /**
     优先级:交互级的
     */
    public static func userInteractive(execute work: @escaping @convention(block) () -> Swift.Void)->Void{
        globalQueue(qos: .userInteractive, execute: work)
    }
    
    /**
     后台执行
     */
    public static func background(execute work: @escaping @convention(block) () -> Swift.Void)->Void{
        globalQueue(qos: .background, execute: work)
    }
    
    
    /**
     进入一个全局的队列来做事情,可以设定优先级
     */
    public static func globalQueue(qos:DispatchQoS.QoSClass,execute work: @escaping @convention(block) () -> Swift.Void)->Void{
        
        DispatchQueue.global(qos: qos).async(execute: work);
        //        DispatchQueue.global(qos: qos).async {
        //            work()
        //        }
        //        DispatchQueue.global(attributes: priority).async(execute: block)
    }
    
    /**
     回到主线程做事情
     */
    public static func toMain(execute work: @escaping @convention(block) () -> Swift.Void)->Void{
        DispatchQueue.main.async(execute: work)
        //        OperationQueue.main.addOperation {
        //            block()
        //        }
    }
}
