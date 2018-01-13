//
//  NSObject+Model.swift
//  LSXPropertyTool
//
//  Created by 李莎鑫 on 2017/4/9.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//  字典，字典数组转模型底层处理。(仅支持swift4.0,版本1.0.4,swift3.+请用0.0.9）
//### 在其基础进行了修改

import Foundation
public var debugModel:Bool = false
extension NSObject {
    
    ///  通过类名称创建控制器
    ///
    /// - Parameter name: 类名
    /// - Returns: 对象
    public  class func objectInstatnce(_ name:String?) -> NSObject? {
        
        //: 获取命名空间
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            LTLLog("获取命名空间失败", .error)
            return nil
        }
        
        
        guard let className = NSClassFromString(nameSpace + "." + (name ?? ""))  else {
            LTLLog("\(nameSpace):下\(String(describing: name))找不到!", .error)
            return nil
        }
        
        //: 获取类型
        guard let classType = className as? NSObject.Type  else {
            LTLLog("获取类型失败，不能创建对象", .error)
            return nil
        }
        
        return classType.init()
    }
    /// 字典转换成模型
    ///
    /// - Parameters:
    ///   - modelClass: 模型名称
    ///   - dictionary: 字典
    /// - Returns: 转换好的模型
    @objc public class func toModel(_ dictionary:Dictionary<String,Any>) -> Self{
        let model = PropertyModel()
        
        //        guard let object = objectInstatnce(withClassName: modelClass) else {
        //            return nil
        //        }
        let object = self.init()
        
        let objectMirror = Mirror(reflecting: object)
        
        //: 获取所有属性
        for case let(label? , _) in objectMirror.children{
            var key = label
            var isUsingKeyWord:Bool = false
            
            //: 判断属性是否为系统关键字特征前缀名词
            if (key.hasPrefix(keyPreffix)) {
                if debugModel
                {
                    LTLLog("\(object) 的属性\(String(describing: key)) 是系统关键字前缀名词，进行前缀剥离处理.", .debug)
                }
                key = String(describing: key.suffix(from: keyPreffix.endIndex))
                
                isUsingKeyWord = true
            }else{
                isUsingKeyWord = false
            }
            
            model.propertyName = key
            
            var value = dictionary[key]
            
            //: 恢复系统关键字的转换
            if isUsingKeyWord {
                key = keyPreffix + key
            }
            
            if let _ = value {
                let propertyMirror = Mirror(reflecting: value!)
                if debugModel
                {
                    LTLLog("键\(key) 类型\(propertyMirror.subjectType) 显示类型\(String(describing: propertyMirror.displayStyle))")
                }
                
                let type = String(describing:propertyMirror.displayStyle).components(separatedBy: ".").last
                let BaseType = String(describing:propertyMirror.subjectType)
                
                //: 字典类型
                if (isPropertyType(swiftDictionary, property: type) || isContentProperty(swf3Dictionary, property: BaseType)) {
                    //: 获取名词空间
                    if let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String {
                        model.propertyType = model.propertyName!.lowercased().capitalized
                        
                        if let propertyType = NSClassFromString(nameSpace + "." + model.propertyType!) {
                            
                            
                            //                            .toModel(value as! Dictionary<String,Any>)
                            value = propertyType.toModel(value as! Dictionary<String, Any>)
                        }
                    }
                    //: 数组类型
                } else if (isPropertyType(swiftArray, property: type) || isContentProperty(swf3Array, property: BaseType)) {
                    //                    let array = value as! Array<Any>
                    //                    model.propertyType = model.propertyName!.lowercased().capitalized
                    //
                    //                    value = NSObject.toModel(withClassName: model.propertyType!, withArray: array)
                    if let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String {
                        model.propertyType = model.propertyName!.lowercased().capitalized
                        
                        if let propertyType = NSClassFromString(nameSpace + "." + model.propertyType!) {
                            
                            //                            .toModel(value as! Dictionary<String,Any>)
                            value = propertyType.toModelArray(value as! Array<Any>)
                        }
                    }
                    
                    
                }
                
                //: 添加数据
                if let data = value {
                    object.setValue(data, forKeyPath: key)
                }
                
            }else
            {
                //LTLLog("\(object)中键值\(String(describing: key)) 的属性不存在", .error)
                if debugModel
                {
                    LTLLog("键值\(String(describing: key)) 的属性不存在", .error)
                }
            }
        }
        
        return object
    }
    
    
    /// 数组转换成模型
    ///
    /// - Parameters:
    ///   - className: 模型类名
    ///   - array: 数组
    /// - Returns: 模型数组
    @objc public class func toModelArray(_ array:Array<Any>) -> Array<Any> {
        
        var modelArray = Array<Any>()
        
        //: 获取元素
        for i in 0..<array.count {
            var data:Any?
            
            let subPropertyMirror = Mirror(reflecting: array[i])
            
            let type = String(describing:subPropertyMirror.displayStyle).components(separatedBy: ".").last
            let BaseType = String(describing:subPropertyMirror.subjectType)
            
            //: 字典类型
            if (isPropertyType(swiftDictionary, property: type) || isContentProperty(swf3Dictionary, property: BaseType)) {
                //: 获取名词空间
                if (Bundle.main.infoDictionary!["CFBundleExecutable"] as? String) != nil {
                    
                    data = self.toModel(array[i] as! Dictionary<String,Any>)
                    //                    if let _ = NSClassFromString(nameSpace + "." + className) {
                    //                        data = NSObject.toModel(withClassName:className, withDictionary:array[i] as! Dictionary<String,Any>)
                    //                    }
                }
                //: 数组类型
            } else  if (isPropertyType(swiftArray, property: type) || isContentProperty(swf3Array, property: BaseType)) {
                
                //                data = NSObject.toModel(withClassName: className, withArray: (array[i] as! Array<Any>))
                data = self.toModelArray(array[i] as! Array<Any>)
                //: 基本类型
            } else {
                data = array[i]
            }
            
            if let model = data {
                modelArray.append(model)
            }
        }
        
        return modelArray
    }
    
    
    /// 判断属性相同
    ///
    /// - Parameters:
    ///   - type: 属性类型
    ///   - property: 属性
    /// - Returns: 结果
    public  class func isPropertyType(_ type:String?,property:String?) -> Bool {
        return (type == property) ? true : false
    }
    
    
    /// 判断包含属性
    ///
    /// - Parameters:
    ///   - type: 属性类型
    ///   - property: 属性
    /// - Returns: 结果
    public class func isContentProperty(_ type:String,property:String) -> Bool {
        
        return property.contains(type)
    }
    //MARK:---------<#提示文字#>-----------
    //MARK: - 模型转为字典
    /// 模型转为字典
    
    func  dictionaryWithObject() -> [String:Any]? {
        
        // 1. 获取模型的属性列表
        let objDict = classPropertyList(self.classForCoder)
        
        var result = [String:Any]()
        
        for (k,v) in objDict {
            var value:NSObject? = self.value(forKey: k) as? NSObject
            if value == nil {
                value = NSNull()
            }
            if v.isEmpty || value === NSNull() {
                result[k] =  value
            }else{
                let type = "\(String(describing: value?.classForCoder))"
                var subValue : Any?
                if type == "NSArray" {
                    subValue = arrayWithObje(value! as! [NSObject])
                } else {
                    //                    subValue = dictionaryWithObject(obj: value!) as AnyObject
                    subValue = value?.dictionaryWithObject()
                }
                if subValue == nil {
                    subValue = NSNull()
                }
                result[k] = subValue
            }
        }
        
        if result.count > 0 {
            return result
        }else{
            return nil
        }
    }
    
    //MARK: - 模型数组转字典数组
    /**
     模型数组转字典数组
     
     - parameter array: 模型数组
     
     - returns: 字典数组
     */
    func arrayWithObje(_ array:[NSObject]) -> [Any]? {
        
        var result = [AnyObject]()
        
        for value in array {
            let type = "\(value.classForCoder)"
            
            var subValue: Any?
            if type == "NSArray" {
                subValue = arrayWithObje(value as! [NSObject])
            } else {
                subValue = value.dictionaryWithObject()
            }
            if subValue != nil {
                result.append(subValue! as AnyObject)
            }
        }
        
        if result.count > 0 {
            return result
        } else {
            return nil
        }
        
    }
    
    /// 模型缓存 [类名：模型信息字典]
    //    var clssPropertyCache = [String:[String:Any]]()
    //MARK: - 获取某个类的全部属性
    // 获取某个类的全部属性
    func classPropertyList(_ cls:AnyClass) -> [String:String] {
        //        if let cache = clssPropertyCache["\(cls)"] {
        //            return cache
        //        }
        // 属性列表
        var count: UInt32 = 0
        let propertys = class_copyPropertyList(cls, &count)
        
        var infoDict = [String:String]()
        for i in 0..<count {
            let property = propertys![Int(i)]
            
            // 属性名称
            let cname = property_getName(property)
            //            let name = String.fromCString(cname)!
            let name = String.init(cString: cname)
            infoDict[name] = ""
            
        }
        free(propertys)
        // 写入缓冲池
        //        clssPropertyCache["\(cls)"] = infoDict
        return infoDict
    }
    
}
