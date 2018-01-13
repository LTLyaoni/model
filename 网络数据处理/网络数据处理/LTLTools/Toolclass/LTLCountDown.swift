//
//  LTLCountDown.swift
//  视频播放
//
//  Created by 123 on 2018/1/9.
//  Copyright © 2018年 LTL. All rights reserved.
//

import UIKit

typealias completeBlock = (_ day: NSInteger,_ hour:NSInteger,_ minute:NSInteger,_ second:NSInteger,_ stop:Bool)->Void

class LTLCountDown: NSObject {
    
    var timer:Timer? = Timer()
    
    var timestamp:NSInteger = 0
    
    var complete:completeBlock?
    
    
    ///用NSDate日期倒计时
    func countDownWith(_ stratDate:Date,_ finishDate:Date,completeBlock:completeBlock) {
        
    }
    ///用时间戳倒计时
    func countDownWith(_ stratTimes:NSInteger,completeBlock:@escaping completeBlock)
    {
       
        self.complete = completeBlock
        
        
        let timestamp = stratTimes - Int(round(Date().timeIntervalSince1970))
        LTLLog(timestamp)
       self.timestamp = timestamp
        if timestamp > 0
        {
            if timer != nil
            {
                timer?.invalidate()
                timer = nil
            }
            else
            {
                timer = Timer(timeInterval: 1, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
                RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
            }
        }
        else
        {
            self.complete?(0,0,0,0,false)
        }
        
    }
    
   @objc func timer(_ timer:Timer) {
        self.timestamp -= 1
    
        getDetailTimeWith(self.timestamp)
        if self.timestamp == 0 {
            self.timer?.invalidate()
            self.timer = nil
            self.complete?(0,0,0,0,false)
        }
    
    }
    
    func getDetailTimeWith(_ timestamp:NSInteger) {
        let ms = timestamp
        let ss = 1
        let mi = ss * 60;
        let hh = mi * 60;
        let dd = hh * 24;
        // 剩余的
        let day = ms / dd;// 天
        let hour = (ms - day * dd) / hh;// 时
        let minute = (ms - day * dd - hour * hh) / mi;// 分
        let second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
//        LTLLog("\(day)天:\(hour)时:\(minute)分:\(second)秒");
        self.complete?(day,hour,minute,second,true)
    }

    ///停止倒计时
    func destoryTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }

    deinit {
        destoryTimer()
    }
}
