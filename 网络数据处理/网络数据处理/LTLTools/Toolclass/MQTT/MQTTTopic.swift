////
////  MQTTTopic.swift
////  appTemplates
////
////  Created by 123 on 2017/12/9.
////  Copyright © 2017年 LiTaiLiang. All rights reserved.
////
//
//import UIKit
//
//class MQTTTopic: NSObject {
//
//   static let single = MQTTTopic()
//    
//    ///一般
//    var subTopic:String =  ""
//    ///自定义消息
//    var subTopic_C:String =  ""
//    ///发送进入聊天室的信息
//    var __present__subTopic:String =  ""
//    ///鼠标移动的消息
//    var subTopic_P:String =  ""
//    ///上下线
//    let __tis_on_off_check__:String = "__tis_on_off_check__"
//    
//    
//    ///订阅主题
//    static func setTopic(_ topic:String)
//    {
//        self.single.subTopic = topic
//        self.single.subTopic_C = topic+"_C"
//        self.single.subTopic_P = topic+"_P"
//        self.single.__present__subTopic = "__present1__" + topic
//        
//        
//        
//    }
//    
//   static func Subscribe() {
//    MQTTSwift.MQTTClient.subscribe(topicDict: [ self.single.subTopic+"/#":0,
//                                                self.single.subTopic_C+"/#":0,
//                                                self.single.subTopic_P+"/#":0,
//                                                self.single.__present__subTopic+"/#":0
//        ])
//    }
//    
//    
//   /// 退订主题
//   static func Unsubscribe()
//   {
//            MQTTSwift.MQTTClient.unsubscribe([ self.single.subTopic+"/#",
//                                               self.single.subTopic_C+"/#",
//                                               self.single.subTopic_P+"/#",
//                                               self.single.__present__subTopic+"/#"
//                ])
//
//    }
//}

