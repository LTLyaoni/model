//
//  LSXPropertyTool.swift
//  LSXPropertyTool
//
//  Created by 李莎鑫 on 2017/4/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//  属性代码生成工具 (仅支持swift4.0,版本1.0.2,swift3.+请用0.0.9） 
//### 在其基础进行了修改

import Foundation

open class LTLPropertyTool: NSObject {
    
    ///: plist 文件生成属性 导模型需要在模拟器
    open class func codeMake(withSwiftVersion version:SwiftVersion, withPlist plist:String ,valueKey key:String ,fileName name:String ,filePath path:String) {
        
        PropertyCodeMake.propertyCodeMake(withSwiftVersion: version,withPlist: plist, valueKey: key, fileName: name, filePath: path)
    }
    
    ///: json数组生成属性 导模型需要在模拟器
    open class func codeMake(withSwiftVersion version:SwiftVersion,withDictionaryArray array:Array<Any>,fileName name:String,filePath path:String) {
        
        PropertyCodeMake.propertyCodeMake(withSwiftVersion: version,withDictionaryArray: array, fileName: name, filePath: path)
    }
    
    ///: 字典生成属性 导模型需要在模拟器
    open class func codeMake(withSwiftVersion version:SwiftVersion,withDictionary dictionary:Dictionary<String,Any>,fileName name:String,filePath path:String)  {
        
        PropertyCodeMake.propertyCodeMake(withSwiftVersion: version,withDictionary: dictionary, fileName: name, filePath: path)
    }
}
