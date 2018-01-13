//
//  ToString+Data.swift
//  xiaoyun
//
//  Created by 123 on 2018/1/9.
//  Copyright © 2018年 李泰良. All rights reserved.
//

import Foundation
extension Data{
    /*!
     utf-8 string
     */
    public func toUTF8String()->String{
        let string = String.init(data: self, encoding: String.Encoding.utf8)
        if string == nil {
            return ""
        }
        return string!
    }
    
}
