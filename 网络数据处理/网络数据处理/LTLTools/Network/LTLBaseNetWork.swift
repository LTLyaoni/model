    //
    //  LTLBaseNetWork.swift
    //  TLToolExtension
    //
    //  Created by 李泰良 on 2017/11/5.
    //  Copyright © 2017年 李泰良. All rights reserved.
    //

    import UIKit
    import Alamofire

    struct objc
    {
        var object:Any
    }
    ///请求结果
    class LTLReturnData: NSObject {
        ///请求到的字典
        var DataDict = [NSString:Any]()
        ///请求到的数组结果
        var DataArr = [Any]()
        ///请求json结果
        var object  = objc(object: "")
        ///请求错误信息
        var errorMsg = ""
        ///请求是否成功
        var isOk = false
    }

    ///请求类型
    enum MethodType {
        case GET
        case POST
    }
    /// 网络状态
    enum NetworkStatus : Int {
        /// 没网
        case StatusNotReach
        /// 未知
        case StatusUnknow
        /// 手机网络
        case StatusWWan
        /// WIFI
        case StatusWiFi
    }

    // final关键字这个类或方法不希望被重写
    public class LTLBaseNetWork: NSObject {
        
        var Baseurl = ""
        ///超时时长
        var timeoutIntervalForRequest = 10
        //是否拼接链接
        var stitchingURL = true
        
        var manager = Alamofire.SessionManager.default
        
        /// 创建单例
        static let superShared : LTLBaseNetWork = {
            
            let NetworkRequestInstance = LTLBaseNetWork()
            
            NetworkRequestInstance.manager.session.configuration.timeoutIntervalForRequest = TimeInterval(NetworkRequestInstance.timeoutIntervalForRequest)
            NetworkRequestInstance.manager.session.configuration.timeoutIntervalForResource = TimeInterval(NetworkRequestInstance.timeoutIntervalForRequest)
            
            return NetworkRequestInstance
            
        }()
        
        /// 网络请求封装
        ///
        /// - Parameters:
        ///   - type: 请求类型
        ///   - URLString: 请求链接 可以是API后一段,进行连接拼接
        ///   - headers: 请求头
        ///   - parameters: 请求参数
        ///   - failture: 请求结果
        final  func Request(_ type : MethodType, URLString : String, headers : [String: String]? = nil , parameters : [String : Any]? = nil,failture: @escaping(_ data: LTLReturnData ) -> ())
        {
            
            
            monitorNetworkStatus { (status) in
                LTLLog("当前网络状态 ======== " + "\(status)" , .debug)
            }
            var URL = URLString
            
            if stitchingURL
            {
                URL = Baseurl + URLString
            }
            /// 设置请求超时时长
            //        let manager = Alamofire.SessionManager.default
            //        manager.session.configuration.timeoutIntervalForRequest = TimeInterval(timeoutIntervalForRequest)
            //        manager.session.configuration.timeoutIntervalForResource = TimeInterval(timeoutIntervalForRequest)
            // 获取类型
            let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
            LTLLog( "请求类型" + "\(method)", .debug)
            ///请求
            manager.request(URL, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in

                failture(self.responseData(response))
                
            }
            
        }
        
        private func responseData(_ response:DataResponse<Any> ) -> LTLReturnData
        {
            var isOk = false
            
            LTLLog("请求的内容" + "\(String(describing: response.request!))", .debug)

            let data = LTLReturnData()
            switch response.result
            {
            case .success(let json):

            isOk = true
            if response.value != nil
            {
            data.object = objc(object: json)

            if let dict =  json as? [NSString:Any]
            {
            data.DataDict = dict
            }
            if let arr =  json as? [Any]
            {
            data.DataArr = arr
            }
            }
            else
            {
            data.errorMsg = "没有数据！"
            }
            case .failure(let err):
            isOk = false
            data.errorMsg = returnError(err._code)

            }

            data.isOk = isOk
            
            return data
        }
        
        
        /// 文件上传
        ///
        /// - Parameters:
        ///   - type: 请求类型
        ///   - URLString: url
        ///   - file: 文件数组
        ///   - fileParameter: 文件参数
        ///   - parameter: 请求参数
        ///   - headers: 请求头
        ///   - failture: 返回数据
        final func upload( _ type : MethodType, URLString : String, file:[Data],fileParameter:[String],parameter:[String : Any]? = nil,headers : [String: String]? = nil,failture: @escaping(_ data: LTLReturnData ) -> ()) {

            monitorNetworkStatus { (status) in
                LTLLog("当前网络状态 ======== " + "\(status)", .debug)
            }
            var URL = URLString
            
            if stitchingURL
            {
                URL = Baseurl + URLString
            }
            
            // 获取类型
            let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                ///文件
                for (index, fileData) in file.enumerated()
                {
                     LTLLog((Swime.mimeType(data: fileData)?.ext), .debug)
                    
                    // 图片绑定参数
                    let  imageName = "\(NSInteger(Date.timeIntervalSinceReferenceDate))" + ".\((Swime.mimeType(data: fileData)?.ext)!)"
                    LTLLog(imageName, .debug)
                    multipartFormData.append(fileData, withName: fileParameter[index] , fileName: imageName, mimeType: (Swime.mimeType(data: fileData)?.mime)!)
                    
                }
                if parameter != nil
                {
                    // 其余参数绑定
                    for (key, value) in parameter! {
    //                    assert(value is String)
    //                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(String.Encoding.utf8)!, name: key)
                        let valueStr = "\(String(describing:value))"
                        LTLLog(valueStr)
                        LTLLog(key, .debug)
                        multipartFormData.append(valueStr.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: URL, method: method, headers: headers) { (encodingResult) in
                
                switch encodingResult
                {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress { progress in // main queue by default
                        LTLLog("Upload Progress: \(progress.fractionCompleted)", .debug)
                    }
                    upload.responseJSON { response in
                        failture(self.responseData(response))
                    }
                    
                case .failure(_): break
                    
                }
            }
        }
        
        //MARK:https证书验证
        final func verificationCertificate() -> Void {
            
            let manager = SessionManager.default
            
            manager.delegate.sessionDidReceiveChallenge = { session, challenge in
                
                var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
                var credential: URLCredential?
                
                if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                    
                    disposition = URLSession.AuthChallengeDisposition.useCredential
                    credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
                    
                } else {
                    if challenge.previousFailureCount > 0 {
                        
                        disposition = .cancelAuthenticationChallenge
                        
                    } else {
                        
                        credential = manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                        
                        if credential != nil {
                            disposition = .useCredential
                        }
                    }
                }
                
                return (disposition, credential)
            }
            
        }
        /// 监听网络状态
        final func monitorNetworkStatus(netStatus: @escaping(NetworkStatus) -> ()) {
            
            var manager : NetworkReachabilityManager?
            
            manager = NetworkReachabilityManager.init(host: Baseurl)
            
            manager?.listener = { status in
                
                switch status {
                    
                case .notReachable:
                    
                    netStatus(.StatusNotReach)
                    
                case .unknown:
                    
                    netStatus(.StatusUnknow)
                    
                case .reachable(.ethernetOrWiFi):
                    
                    netStatus(.StatusWiFi)
                    
                case .reachable(.wwan):
                    
                    netStatus(.StatusWWan)
                    
                }
                
            }
            manager?.startListening()
            
        }
    }
