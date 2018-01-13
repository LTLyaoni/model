//
//  LTLDataEncoding.swift
//  appTemplates
//
//  Created by 李泰良 on 2017/11/13.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//

import UIKit

let AESkey = "DrCOsLZhhIFypKGR"
let AESiv = "5m5JwhD0AWEUHTvz"
let MD5salt = "ECDmdMQaHdAQBnxZ"

//class LTLDataEncoding: NSObject
extension String
{
//    static let key = "hYYvesbdjcdlcVUp"
//    static let iv = ""
//    static let salt = "DEgdrgadfsfasdbadrggasdfgosnt"

    //MARK: AES-ECB128加密
    public func Endcode_AES_ECB()->String {
        // 从String 转成data
        let data = self.data(using: String.Encoding.utf8)
        
        // byte 数组
        var encrypted: [UInt8] = []
        do {
//            encrypted = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7.Padding).encrypt(data!.bytes)
            encrypted = try AES(key: AESkey, iv: AESiv, padding: Padding.pkcs7).encrypt((data?.bytes)!)
            
        } catch {
            LTLLog(error ,.error)
        }
        
        let encoded =  Data(encrypted)
        //加密结果要用Base64转码
        return encoded.base64EncodedString()
    }
    
    //  MARK:  AES-ECB128解密
    public func Decode_AES_ECB()->String {
        //decode base64
        let data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        
        // byte 数组
        var encrypted: [UInt8] = []
        let count = data?.length
        
        // 把data 转成byte数组
        for i in 0..<count! {
            var temp:UInt8 = 0
            data?.getBytes(&temp, range: NSRange(location: i,length:1 ))
            encrypted.append(temp)
        }
        
        // decode AES
        var decrypted: [UInt8] = []
        do {
//            decrypted = try AES(key: key, iv: iv, blockMode:.CBC, padding: PKCS7.Padding).decrypt(encrypted)
            decrypted = try AES(key: AESkey.bytes, blockMode: .CBC(iv: AESiv.bytes), padding: Padding.pkcs7).decrypt(encrypted)
        } catch {
        }
        
        // byte 转换成NSData
        let encoded = Data(decrypted)
        var str = ""
        //解密结果从data转成string
        str = String(bytes: encoded.bytes, encoding: .utf8)!
        return str
    }
    
    //MARK: MD5 加密
    public func MD5(codeString: String) -> String {
        // 加盐加密
        let md5String =  (codeString + MD5salt).md5()
        return md5String
    }
    
}
