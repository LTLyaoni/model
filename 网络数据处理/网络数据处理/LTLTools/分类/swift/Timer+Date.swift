//
//  Timer+Date.swift
//  xiaoyun
//
//  Created by 123 on 2018/1/9.
//  Copyright © 2018年 李泰良. All rights reserved.
//

import Foundation
extension Date
{
    /// 时间格式化为几分钟前 等
    ///
    /// - Parameter : 时间戳
    /// - Returns: 几分钟前 等
    static func convertCreatedText(_ time: Int) -> String{
        let CommonDateFormatter = DateFormatter.init()
        //        let date = Date(timeIntervalSince1970:TimeInterval(timeStr.intValue))
        //设置格式
        CommonDateFormatter.dateFormat = "EEE MMM dd HH:mm:ss z yyyy"
        CommonDateFormatter.locale = Locale(identifier: "en_US")
        //1.转化为 NSDate
        //        let date = CommonDateFormatter.date(from: timeStr)!
        let timeDate = Date(timeIntervalSince1970:TimeInterval(time))
        let datetimeStr = CommonDateFormatter.string(from: timeDate)
        let date = CommonDateFormatter.date(from: datetimeStr)!
        
        
        if isThisYear(date: date){
            //如果是今年
            let calendar = Calendar.current
            
            if calendar.isDateInToday(date) {
                //如果是今天CommonDateFormatter
                let interval:Int = abs(Int(date.timeIntervalSinceNow))
                
                if interval < 60{
                    return "刚刚"
                } else if interval < 60 * 60{
                    return "\(interval/60)分钟前"
                } else if interval < 60 * 60 * 24{
                    return "\(interval/60/24)小时前"
                }
                
            }else if calendar.isDateInYesterday(date){
                
                CommonDateFormatter.dateFormat = "HH:mm"
                //不是今天
                return "昨天 \(CommonDateFormatter.string(from: date))"
            } else{
                //今年的某一天
                CommonDateFormatter.dateFormat = "MM-dd"
                return CommonDateFormatter.string(from: date)
            }
            
            
        }else{
            //如果不是今年
            CommonDateFormatter.dateFormat = "yyyy-MM-dd"
            
            return CommonDateFormatter.string(from: date)
        }
        return ""
    }
    
    static func isThisYear(date:Date) -> Bool{
        let CommonDateFormatter = DateFormatter.init()
        CommonDateFormatter.dateFormat = "yyyy"
        //1.获取当前年份字符串
        let currentYearStr = CommonDateFormatter.string(from:Date.init())
        //2.获取微博年份字符串
        let statusYearStr = CommonDateFormatter.string(from: date)
        return currentYearStr == statusYearStr
    }
}
