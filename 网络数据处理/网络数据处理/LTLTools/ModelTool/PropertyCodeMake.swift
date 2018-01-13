//
//  PropertyCodeMake.swift
//  LSXPropertyTool
//
//  Created by 李莎鑫 on 2017/4/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//  属性代码生成工具 (仅支持swift4.0,版本1.0.2,swift3.+请用0.0.9）工具使用如有问题，期待打脸QQ:120834064
//### 在其基础进行了修改

import Foundation

class PropertyCodeMake: NSObject {
    
    //: plist 文件生成属性
    open class func propertyCodeMake(withSwiftVersion version:SwiftVersion,withPlist plist:String ,valueKey key:String ,fileName name:String ,filePath path:String) {
        guard let file = Bundle.main.path(forResource: plist, ofType: nil) else {
            return
        }
        
        let data = (NSDictionary(contentsOfFile: file) as! Dictionary<String, Any>)
        
        guard let array = data[key]  else {
            return
        }
        
        propertyCodeMake(withSwiftVersion: version,withDictionaryArray: array as! Array, fileName: name, filePath: path)
    }
    
    
    //: json数组生成属性
    open class func propertyCodeMake(withSwiftVersion version:SwiftVersion,withDictionaryArray array:Array<Any>,fileName name:String,filePath path:String) {
 
        var file = String()
        let oldfile = String()
        var propertys = [String]()
        let outfile = path.appending(PropertyModel.propertyPathAppendingFileName(fileName: name))
       
        if FileManager.default.fileExists(atPath: outfile) {
            do{
                
                file = try String.init(contentsOfFile: outfile)
                
            }catch{
                LTLLog("read File error", .error)
            }
            
            for i in 0..<array.count {
                
                //: 文件展开属性一定是键值对
                if NSObject.propertyClassType(withValue: array[i]) == BaseDictionaryType {
        
                    let dictionary = array[i] as! Dictionary<String,Any>
                    
                    let result = propertyCodeMakeOption(withSwiftVersion: version,withFile: file, withDictionary: dictionary, withPropertys: propertys, withPath: path,update:{ (newfile) in
                        //: 更新文件
                        file = newfile
                    }, process: { (name) in
                        propertys.append(name)
                    })
                    
                    if result == "new" {
                        LTLLog(result, .debug)
                    }
                }
            }
            
            //: 文件管理器更新
            if oldfile.compare(file) == .orderedAscending {
                do{
                    try file.write(toFile: outfile, atomically: true, encoding: .utf8)
                }catch{
                    LTLLog(error, .error)
                    LTLLog("\(name) write to file error!", .error)
                }
            }
            
        }else{
            var code = String()
            
            //: 创建文件
            code.append(creaatePropertyCodeFile(withFileName: name))
            for i in 0..<array.count {
                
                //: 文件展开属性一定是键值对
                if NSObject.propertyClassType(withValue: array[i]) == BaseDictionaryType {
                    let dictionary = array[i] as! Dictionary<String,Any>
                    code.append(propertyCodeMakeOption(withSwiftVersion: version,withFile: file, withDictionary: dictionary, withPropertys: propertys, withPath: path,update: nil, process: { (name) in
                        propertys.append(name)
                    }))
                }
                
            }
            
            code.append(PropertyModel.propertyFileClassExit())
            
            //: 文件管理器,避免重复创建
            do{
                try code.write(toFile: outfile, atomically: true, encoding: .utf8)
            }catch{
                LTLLog(error, .error)
                LTLLog("\(name) write to file error!", .error)
            }
        }
        
    }
    
    //: 字典生成属性
    open class func propertyCodeMake(withSwiftVersion version:SwiftVersion,withDictionary dictionary:Dictionary<String,Any>,fileName name:String,filePath path:String) {
        
        var file = String()
        var oldfile = String()
        var propertys = [String]()
        
        let outfile = path.appending(PropertyModel.propertyPathAppendingFileName(fileName: name))
        
        //: 判断文件是否存在
        if FileManager.default.fileExists(atPath: outfile) {
            do{
                //: 读取文件
                file = try String.init(contentsOfFile: outfile)
                oldfile = file
                
            }catch{
                LTLLog("read File error", .error)
            }
            
            let result = propertyCodeMakeOption(withSwiftVersion: version,withFile: file, withDictionary: dictionary, withPropertys: propertys, withPath: path,update:{ (newfile) in
                file = newfile
            }, process: { (name) in
                propertys.append(name)
            })
            
            if result == "new" {
                LTLLog(result, .debug)
            }
            //: 文件管理器更新
            if oldfile.compare(file) == .orderedAscending {
                do{
                    try file.write(toFile: outfile, atomically: true, encoding: .utf8)
                }catch{
                    LTLLog(error, .error)
                    LTLLog("\(name) write to file error!", .error)
                }
            }
        }else{
            var code = String()
            //: 创建文件
            code.append(creaatePropertyCodeFile(withFileName: name))
            
            code.append(propertyCodeMakeOption(withSwiftVersion: version,withFile: file, withDictionary: dictionary, withPropertys: propertys, withPath: path,update: nil,process: { (name) in
                propertys.append(name)
            }))
            
            code.append(PropertyModel.propertyFileClassExit())
            
            //: 文件管理器写入
            do{
                try code.write(toFile: outfile, atomically: true, encoding: .utf8)
            }catch{
                LTLLog(error, .error)
                LTLLog("\(name) write to file error!", .error)
            }
        }
    }
    
    //: 属性检查
    fileprivate class func properyCodeMakeCheck(withSwiftVersion version:SwiftVersion,propertyName name:String,propertyType type:String,propertyValue value:Any,subfilePath path:String) -> Bool {
        
        //: 内嵌数组类型
        if type == swf3Array {
           
            let data = value as! NSArray
              //: 如果下面有内容继续转换生成
            if data.count != 0 {
                if propertyClassType(withValue: data[0]) == BaseDictionaryType {
                    propertyCodeMake(withSwiftVersion: version,withDictionaryArray: data as! Array<Any>, fileName: name.capitalized, filePath: path)
                }
            }
            
        }
        //: 内嵌字典类型
        else if type == swf3Dictionary {
            let data = value as! NSDictionary
            //: 如果下面有内容继续转换生成
            if data.count != 0 {
                propertyCodeMake(withSwiftVersion: version,withDictionary: value as! Dictionary<String,Any>, fileName: name.capitalized, filePath: path)
            }
        }
        
        return true
    }
    
    fileprivate class func propertyCodeMakeOption(withSwiftVersion version:SwiftVersion,withFile file:String,withDictionary dictionary:Dictionary<String,Any>,withPropertys propertys:Array<String>,withPath path:String,update:((_ newData:String) ->Void)?,process: @escaping (_ propertyName:String)-> Void) ->String {
        
       return NSObject.propertyCode(withSwiftVersion: version,withFile: file,withDictionary: dictionary,update: update, option: { (name, type, value) -> Bool in
            guard name != "" else{
                return false
            }
            
            guard type != "" else{
                return false
            }
            
            guard value != nil else{
                return false
            }
            
            
            for i in 0..<propertys.count {
                let str = propertys[i]
                if str == name {
                    return false
                }
            }
            
            process(name!)
            
            return properyCodeMakeCheck(withSwiftVersion: version,propertyName: name!, propertyType: type!, propertyValue: value!, subfilePath: path)
        })
    }
    
    //: 创建文件
    fileprivate class func creaatePropertyCodeFile(withFileName name:String) -> String{
        
        var code = String()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let project = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
        
        //: 文件头
        code.append(PropertyModel.propertyHeadFile(fileName: name, projectName: project, authorName: "LiTaiLiang", systemTime: formatter.string(from: Date()), DateYear: String(formatter.string(from: Date()).prefix(through:"yyyy".endIndex))))
        
      
        
        code.append(PropertyModel.propertyFileImport(fileName: "UIKit"))
        code.append(PropertyModel.propertyFileClassEntery(className: name))
        
        
        return code
    }
}
