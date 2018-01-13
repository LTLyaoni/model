//
//  Common+String.swift
//  xiaoyun
//
//  Created by 123 on 2018/1/9.
//  Copyright © 2018年 李泰良. All rights reserved.
//

import UIKit

extension String{
    
    //TODO MD5
    
    //"$＄¥￥231"
    /*!
     半角的RMB符号，加删除线的时候比较方便,不会和数字看起来不同
     Half-width
     注意:如果是全角的和数字放在一起加删除线不会连接在一起
     
     ¥ 全角 ￥半角
     */
    public static func RMBSymbol()->String{
        return "¥"
    }
    
    /*!
     half-width dollar
     $ 半角   ＄全角
     */
    public static func DollarSymbol()->String{
        return "$"
    }
    
    subscript(range:Range<Int>)->String{
        get{
            let startIndex = self.characters.index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = self.characters.index(self.startIndex, offsetBy: range.upperBound);
            return String(self[Range(startIndex..<endIndex)])
        }
    }
    public var length:Int{
        return self.count
    }
    //将十六进制字符串转换成十进制
    public static func changeToInt(_ num:String) -> Int{
        
        let str = num.uppercased();
        var result = 0
        for i in str.utf8{
            result = result*16 + Int(i) - 48   //0-9   48开始
            if  i >= 65 {     // A-Z   65开始
                result -= 7
            }
        }
        return result;
    }
    
    var floatValue: Float {
        return NSString(string: self).floatValue
    }
    var intValue:Int{

        return NSString(string: self).integerValue
    }
    
    public func toUTF8Data()->Data{
        var data = self.data(using: String.Encoding.utf8)
        if data == nil {
            data = Data()
        }
        return data!
    }
    
    ///编码
    func UTF8EncodedString() ->String {
        var arr = [UInt8]()
        arr += self.utf8
        return String(bytes: arr,encoding: String.Encoding.utf8)!
    }
    
    #if os(iOS)
    /*!
     *  用于计算文字高度
     */
    public func boundingRectWithSize(_ size: CGSize, options: NSStringDrawingOptions, attributes: [NSAttributedStringKey : AnyObject]?, context: NSStringDrawingContext?) -> CGRect{
    let string:NSString = self as NSString
    return string.boundingRect(with: size, options: options, attributes: attributes, context: context)
    }
    #endif
    
    static func toCreateTime(_ createTime:Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(createTime))
        let objDateformat = DateFormatter.init()
        //        objDateformat.date(from: "MM-dd")
        objDateformat.dateFormat = "MM-dd"
        return objDateformat.string(from: date)
    }
    
    func has(_ str:String)->Bool  {
        return self.components(separatedBy: str).count > 1
    }
    
    func toURL() -> URL {
        if isURL()
        {
            return URL(string: self)!
        }
        return URL(string: "http://192.168.3.6/?domain=daxue")!
    }
    static func toTimeStr(_ createTime:Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(createTime))
        let objDateformat = DateFormatter.init()
        //        objDateformat.date(from: "MM-dd")
        objDateformat.dateFormat = "yyyy-MM-dd HH:mm"
        return objDateformat.string(from: date)
    }
}
