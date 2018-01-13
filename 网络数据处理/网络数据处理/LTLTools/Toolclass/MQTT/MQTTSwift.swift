////
////  MQTTSwift.swift
////  MQTTSwift
////
////  Created by Christoph Krey on 23.05.16.
////  Copyright © 2016 OwnTracks. All rights reserved.
////
//import MQTTClient
//import Foundation
//
//public let MQTTlinkMsg:String = "MQTTlinkMsg"
//
//class MQTTSwift: NSObject   {
//
//    var sessionConnected = false
//    var sessionError = false
//    var sessionReceived = false
//    var sessionSubAcked = false
//    var session: MQTTSession?
//    var clientId = ""
//    var userName = ""
//    var password = ""
//    var topic = ""
//    var Host = "139.199.62.124"
//    var port:UInt32 = 1883
//    
//    ///离开
////    var off:String = "off==\(MQTTTopic.single.subTopic)==\(MQTTClient.clientId)"
//    private(set) var off:String = ""
//    ///进入
////    var on:String = "on==\(MQTTTopic.single.subTopic)==\(MQTTClient.clientId)"
//    private(set) var on:String =  ""
//    ///单例
//    static let MQTTClient:MQTTSwift  = MQTTSwift()
//    
//    func Open(_ connection:@escaping (Bool)->Void)
//    {
//        
//        off = "off==\(MQTTTopic.single.subTopic)==\(clientId)"
//        on  = "on==\(MQTTTopic.single.subTopic)==\(clientId)"
//        
//        guard let newSession = MQTTSession.init() else {
//            fatalError("Could not create MQTTSession")
//        }
//        
////        guard let transport = MQTTCFSocketTransport.init() else {
////            fatalError("Could not create MQTTCFSocketTransport")
////        }
//        
////        let transport = MQTTCFSocketTransport.init()
////        transport.host = Host
////        transport.port = UInt32(self.port)
////
////        newSession.transport = transport
//        session = newSession
//        newSession.clientId = clientId
//        newSession.delegate = self
//        newSession.userName = userName
//        newSession.password = password
//        
//        newSession.willFlag = true
//        newSession.willTopic = MQTTTopic.single.__tis_on_off_check__
//        
//        LTLLog(off)
//        
//        newSession.willMsg = off.toUTF8Data()
//        
//        //FIXME:========================================MQTT推荐的方法不管用========================================
////        newSession.connectAndWa` itTimeout(3)
////        newSession.connect(toHost: Host, port: UInt32(port), usingSSL: false)
//        //MARK:========================================用久的========================================
//        OperationQueue.background
//            {
//            let success = newSession.connectAndWait(toHost: self.Host, port: self.port, usingSSL: false, timeout: 3)
//            if !success
//            {
//                let success = newSession.connectAndWait(toHost: self.Host, port: UInt32(self.port), usingSSL: false, timeout: 3)
//                if !success {
//                    WTTipView.showTip("直播室进入失败!")
//                    
//                }
//                else
//                {
//                    self.senMsg(self.on, topic: MQTTTopic.single.__tis_on_off_check__)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: MQTTlinkMsg), object: self, userInfo: [MQTTlinkMsg:success])
//                    connection(success)
//                }
//            }else
//            {
//                self.senMsg(self.on, topic: MQTTTopic.single.__tis_on_off_check__)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: MQTTlinkMsg), object: self, userInfo: [MQTTlinkMsg:success])
//                connection(success)
//            }
//            
//        }
//        
//    }
//    ///关闭
//    func Close()  {
//        LTLLog("要先退订主题再断开", .warning)
//        session?.delegate = nil
//        session?.disconnect()
//        session?.close()
//        session = nil
//        sessionConnected = false
//    }
//    /** subscribes a number of topics
//     
//     MQTTSession *session = [[MQTTSession alloc] init];
//     ...
//     [session connect];
//     
//     [session subscribeToTopics:@{
//     @"example/#": @(0),
//     @"example/status": @(2),
//     @"other/#": @(1)
//     }];
//     
//     @endcode
//     */
//    func subscribe(topicDict:[String : NSNumber] )
//    {
//        LTLLog("订阅主题", .warning)
//        OperationQueue.toMain {
//            
//            self.session?.subscribe(toTopics:topicDict, subscribeHandler: { (error, gQoss) in
//                if (error != nil) {
//                    LTLLog("Subscription failed: \(String(describing: error))",.error );
//                } else {
//                    LTLLog("subTopic:Subscription sucessfull! Granted Qos:\(String(describing: gQoss))",.debug);
//                }
//            })
//        
//        }
//    }
//    /// 订阅主题
//    ///
//    /// - Parameter topic: 主题
//    func subscribe(_ topic:String ) {
//        LTLLog("订阅主题", .warning)
//        OperationQueue.toMain {
//            self.session?.subscribe(toTopic: topic, at: .atMostOnce, subscribeHandler: { (error, gQoss) in
//                if (error != nil) {
//                    LTLLog("Subscription failed: \(String(describing: error))",.error );
//                } else {
//                    LTLLog("subTopic:Subscription sucessfull! Granted Qos:\(String(describing: gQoss))",.debug);
//                }
//            })
//           
//        }
//        
//    }
//    
//    ///退订主题
//    func unsubscribe(_ topic:String) {
//        LTLLog("退订主题", .warning)
//        self.session?.unsubscribeTopic(topic)
//    }
//
//    ///退订主题
//    func unsubscribe(_ topics:[String]) {
//        LTLLog("退订主题", .warning)
//        self.session?.unsubscribeTopics(topics)
//    }
//    ///MQTT工具销毁
//    deinit
//    {
//        LTLLog("deinit要先退订主题再断开", .warning)
//        session?.disconnect()
//        session?.close()
//        sessionConnected = false
//    }
//
//    func senMsg(_ msg:String, topic:String)  {
//        let msgData = msg.toUTF8Data()
//        session?.publishData(atLeastOnce: msgData, onTopic: topic)
//    }
//    
//    
//}
//extension MQTTSwift: MQTTSessionDelegate
//{   
//    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
//       
//        if eventCode == .connectionClosed && sessionConnected
//        {
//            LTLLog("重新连接", .warning)
//            session.connect()
//        }
//        
//    }
//    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32)
//    {
//        LTLLog("Received \(data) on:\(topic) q\(qos) r\(retained) m\(mid)")
//        
//        var JSONStr = data.toUTF8String()
//        LTLLog(JSONStr)
//        JSONStr = JSONStr.replacingOccurrences(of:"'", with: "\"")
//        
//        let message = NSString(string:JSONStr).decode()
//        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: topic), object: self, userInfo: message?.getDictionaryFromJSONString() )
//    }
//}
////extension String
////{
////    //使用正则表达式替换
////    func pregReplace(pattern: String, with: String,
////                     options: NSRegularExpression.Options = []) -> String {
////        let regex = try! NSRegularExpression(pattern: pattern, options: options)
////        return regex.stringByReplacingMatches(in: self, options: [],
////                                              range: NSMakeRange(0, self.count),
////                                              withTemplate: with)
////    }
////}
//
