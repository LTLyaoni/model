//
//  NSObject+Property.swift
//  LSXPropertyTool
//
//  Created by 李莎鑫 on 2017/4/8.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//### 在其基础进行了修改

import Foundation
//import UIKit

extension NSObject {
    
    class func propertyCode(withSwiftVersion version:SwiftVersion,withFile file:String,withDictionary dictionary:[String:Any], update:((_ newData:String) -> Void)?,option: @escaping (_ name:String?,_ type:String?,_ value:Any?) -> Bool ) -> String {
        var code:String = ""
        var temp:String = ""
        let model = PropertyModel()
        
        for (key, value) in dictionary {
            //: 匹配关键字搜索转换
            var keyName = key
            for i in 0..<maskKeyword.count {
                
                //: 如果匹配到为系统关键字转义
                if key.compare(maskKeyword[i]) == .orderedSame {
                    keyName = keyPreffix + key
                }
            }
        
            if option(keyName, propertyType(withValue: value), value) {
                
                model.propertyName = keyName
                model.propertyType = propertyType(withValue: value)
                temp =  propertyTypeCode(withSwiftVersion: version,propertyMode: model,withValue: value)
                code += temp
                //: 新增内容
                if (file != "") && !file.contains(temp) {
                    
                    let index = file.index(file.endIndex, offsetBy: -updateEndIndex)
                    
                    let end = String(file.suffix(from: index))
                    var newfile = String(file.prefix(through: index))
                    
                    
                    newfile.append(temp + end)
                    //: 更新新数据
                    if update != nil {
                        update!(newfile)
                    }
                    
                    return "new"
                }
            }
        
        }
        return code
    }
    
    class func propertyTypeCode(withSwiftVersion version:SwiftVersion,propertyMode model:PropertyModel,withValue value:Any) -> String {
        
        //: 如果属性名加了转义字符，注释中说明
        var extesionNote = "."
        if (model.propertyName?.hasPrefix(keyPreffix))! {
            extesionNote = ".Noteice you are using system keywords,Now the property name [\(model.propertyName!)] is add Preffix [\(keyPreffix)] from origin name [\(String(describing: model.propertyName?.suffix(from: keyPreffix.endIndex)))]."
            
        }
        
        let code = PropertyModel.propertyNote(noteString: "\(String(describing: model.propertyName)),\(String(describing: model.propertyType))" + extesionNote)
        
        switch model.propertyType! {
        //: 处理数组类型
        case    swf3Array:
          
            let data = value as! NSArray
        
            if data.count == 0 {
                return code.appending(PropertyModel.propertyCodeArray(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyType!,subPropertyType:swf3AnyObject))
            }
            
            return propertySpecialArrayType(withSwiftVersion: version,propertyMode: model, withValue: data[0], withNote: extesionNote)
        //: 处理数组字典类型
        case  swf3Dictionary:
          
            return code.appending(PropertyModel.propertyCodeObject(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyName!.capitalized))
        //: 处理通用对象类型
        case swf3String,swf3AnyObject,swf3Any:
            return code.appending(PropertyModel.propertyCodeObject(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyType!))
        //: 处理Bool类型
        case swf3Bool:
            return code.appending(PropertyModel.propertyCodeBool(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyType!))
        default:
            return code.appending(PropertyModel.propertyCode(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyType!))
        }
    }
    
    class func propertyType(withValue value:Any) -> String {
       
        switch propertyClassType(withValue: value) {
        case BaseStringType,String_Type:
            return swf3String
        case BaseNumberType,Number_Type:
            if propertySpecialBoolType(withValue: value) {
                return swf3Bool
            }
            return swf3Number
        case Bool_Type:
            return swf3Bool
        case BaseArrayType,Array_Type:
            return swf3Array
        case BaseDictionaryType,Dictionary_Type:
            return swf3Dictionary
        case BaseNullType:
            return swf3Any
        default:
            return swf3Any
        }
    
    }
    
    //: 推导真实类型
    class func propertyClassType(withValue value:Any) -> String{
        return NSStringFromClass((value as! NSObject).classForCoder)
    }
    
    class func propertySpecialBoolType(withValue value:Any) -> Bool  {
        return (value as! NSObject).isKind(of: NSClassFromString(Bool_Type)!)
    }
    
    class func propertySpecialArrayType(withSwiftVersion version:SwiftVersion,propertyMode model:PropertyModel,withValue value:Any,withNote extesionNote:String) -> String{
        let code = PropertyModel.propertyNote(noteString: "\(String(describing: model.propertyName)),\(String(describing: model.propertyType))" + extesionNote)
        
        
        switch propertyClassType(withValue: value) {
        case BaseArrayType,Array_Type:
            return code.appending(PropertyModel.propertyCodeArray(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyType!,subPropertyType:swf3Array))
        case BaseDictionaryType,Dictionary_Type:
            return  code.appending(PropertyModel.propertyCodeSpecialArray(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyType!))
        case BaseStringType,String_Type:
            return code.appending(PropertyModel.propertyCodeArray(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyType!,subPropertyType:swf3String))
        case BaseNumberType,Number_Type:
            if propertySpecialBoolType(withValue: value) {
                return code.appending(PropertyModel.propertyCodeArray(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyType!,subPropertyType:swf3Bool))
            }
            
            return code.appending(PropertyModel.propertyCodeArray(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyType!,subPropertyType:swf3Number))
        default:
            return code.appending(PropertyModel.propertyCodeArray(withSwiftVersion: version,propertyName: model.propertyName!, popertyType: model.propertyType!,subPropertyType:swf3AnyObject))
        }
    }
}
