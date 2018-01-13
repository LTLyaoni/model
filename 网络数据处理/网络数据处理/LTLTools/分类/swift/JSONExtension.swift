
import Foundation
#if os(iOS)
    import CoreFoundation
    import CoreGraphics
    import UIKit
#elseif os(OSX)
    import CoreServices
#endif


extension JSONSerialization {
    /*
     JSON解析,去掉了null
     */
    public class func LTLJSONObject(with data:Data,options opt:JSONSerialization.ReadingOptions = [])->Any?{
        do {
            var obj:Any = try jsonObject(with: data, options: opt)
            if let result = LTLRemoveNull(with: obj, replaceNullWith: { () -> Any? in
                return ""
            }) {
                obj = result
            }
            return obj
        } catch {
        }
        return nil
    }
    
    
    /*
     把已知的数据结构改动一下,遍历所有的数据,找到null,然后把它替换成需要的数据
     如果穿nil,会把这个字段去掉,建议直接返回空字符串("")
     */
    public class func LTLRemoveNull(with inputData:Any, replaceNullWith:(()->Any?))->Any?{
        if let _ = inputData as? NSNull {
            let c = replaceNullWith()
            return c
        }else if let array = inputData as? [Any]{
            var returnArray:[Any] = [Any]()
            for item:Any in array{
                if let result = LTLRemoveNull(with: item, replaceNullWith: replaceNullWith) {
                    returnArray.append(result)
                }
            }
            return returnArray
        }else if let dictionary = inputData as? [String:Any]{
            var returnDict:[String:Any] = [String:Any]()
            for(k,v)in dictionary{
                if let result = LTLRemoveNull(with: v, replaceNullWith: replaceNullWith){
                    returnDict.updateValue(result, forKey: k)
                }
            }
            return returnDict
        }
        return inputData
    }
}

extension String
{
    
    func getDictionaryFromJSONString() -> Dictionary<String, Any> {
        
        let jsonData:Data = self.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! Dictionary<String, Any>
        }
        return Dictionary()
        
    }
    
}
public extension Dictionary
{
    
    public func JSONString() -> String {
        
        if !JSONSerialization.isValidJSONObject(self) {
            LTLLog("无法解析出JSONString",.error)
            return ""
        }
        var JSONString: String  = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted){
            JSONString = String(data: data, encoding: .utf8)!
        }
        return JSONString
    }
    
    
}

public extension NSDictionary
{
    
    public func JSONString() -> String?{
        return (self as Dictionary).JSONString()
    }
    
}
