//
//  LTLNetworkTools.swift
//  appTemplates
//
//  Created by 李泰良 on 2017/10/16.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//

import UIKit
import Alamofire
///返回对象
struct LTLreturnObj {
    ///返回data字段为数组
    var arr:[Any] = [Any]()
    ///返回data字段为字典数组
    var dictArray:[[String:Any]] = [[String:Any]]()
    ///返回data字段为字典
    var dict:[String:Any] =  [String:Any]()
    ///返回data字段
    var any:Any
    ///返回数据为其他
    var returnObj:Any
    ///返回的info字段信息
    var message:String = ""
    ///success结果
    var success : Bool = false
    ///返回的status字段信息
    var status : NSInteger = 0
    ///请求错误信息
    var errorMsg :String = ""
    ///请求是否成功
    var isOk = false
    ///判断处理
    func resultProcessing(_ successViod:@escaping () -> (), failViod:@escaping () -> () , _ HUDbottom:Bool = false   ) {
        
        if isOk
        {
            if success
            {
                successViod()
                LTLLog("===================================================================")
            }
            else
            {
                failViod()
                LTLLog("后台返回错误信息:"+message, .error)
                if HUDbottom
                {
                    WTTipView.showTip(message)
                }else
                {
//                    showError(message)
                }
                
            }
        }
        else
        {
            failViod()
            LTLLog("请求网络错误信息:"+errorMsg, .error)
            if HUDbottom
            {
                WTTipView.showTip(errorMsg)
            }else
            {
//                showError(errorMsg)
            }
            
        }
    }
    
}

//MARK:---------网络请求工具-----------
class LTLNetworkTools : LTLBaseNetWork {
    //MARK: ============创建单例============
    static let share :LTLNetworkTools =
    {
        let networkTools = LTLNetworkTools()
        networkTools.Baseurl = MainBaseURL
        networkTools.stitchingURL = true
        networkTools.manager.session.configuration.timeoutIntervalForRequest = TimeInterval(networkTools.timeoutIntervalForRequest)
        networkTools.manager.session.configuration.timeoutIntervalForResource = TimeInterval(networkTools.timeoutIntervalForRequest)
        return networkTools
    }()
}
//MARK: - 网络请求封装: -级封装
extension LTLNetworkTools
{
    
}
//MARK: - 网络请求封装: 二级封装
extension LTLNetworkTools
{
    ///请求常规API 的 post 请求
    ///
    /// - Parameters:
    ///   - URLString: 请求API
    ///   - parame: 参数
    ///   - finishedCallback: 返回结果
    class func postRequest( _ URLString: String, _ parame: [String : Any]? = nil, _ finishedCallback:  @escaping (_ result: LTLreturnObj) ->Void){
        ///请求头 /// 定义NetworkConfig 文件里   NetworkConfig 文件 放置网络配置
        let headers: HTTPHeaders = [
            Mk_App_Id: kAPPID,
            Mk_App_Sign: MkAppSign
            //            "Accept": "application/json"
        ]
        LTLLog( "请求参数"+"\(String(describing: parame))", .debug)
        ///网络请求
        self.share.Request(.POST, URLString: URLString, headers: headers, parameters: parame) { (returnData) in
            dataModel(returnData, finishedCallback)
        }
    }

    ///文件上传
    class func postData(_ URLString: String, _ parame: [String : Any]? = nil,file:[Data],fileParameter:[String],_ finishedCallback:  @escaping (_ result: LTLreturnObj) ->Void) {
        
        let headers: HTTPHeaders = [
            Mk_App_Id: kAPPID,
            Mk_App_Sign: MkAppSign
            //            "Accept": "application/json"
        ]
        self.share.upload(.POST, URLString: URLString, file: file, fileParameter: fileParameter, parameter: parame, headers: headers) { (returnData) in
            dataModel(returnData, finishedCallback)
        }
        
    }
    
    class func dataModel(_ returnData:LTLReturnData ,  _ finishedCallback:  @escaping (_ result: LTLreturnObj) ->Void) {
        ////对返回的数据进行处理  模仿别人的处理
        guard let message = returnData.DataDict["info"] as? String else{
            finishedCallback(LTLreturnObj(arr: [[String:Any]](), dictArray: [[String:Any]](), dict: [String:Any](), any: "", returnObj: returnData.object.object, message: "数据错误", success: false, status: 0, errorMsg: returnData.errorMsg, isOk: returnData.isOk))
            return
        }
        guard let success = returnData.DataDict["success"] else{
            
            finishedCallback(LTLreturnObj(arr: [[String:Any]](), dictArray: [[String:Any]](), dict: [String:Any](), any: "", returnObj: returnData.object.object, message: message, success: false, status: 0, errorMsg: returnData.errorMsg, isOk: returnData.isOk))
            return
        }
        guard let code = returnData.DataDict["status"] else{
            
            finishedCallback(LTLreturnObj(arr: [[String:Any]](), dictArray: [[String:Any]](), dict: [String:Any](), any: "", returnObj: returnData.object.object, message: message, success: success as! Bool, status: 0, errorMsg: returnData.errorMsg, isOk: returnData.isOk))
            return
        }
        guard let data = returnData.DataDict["data"] else{
            
            finishedCallback(LTLreturnObj(arr: [Any](), dictArray: [[String:Any]](), dict: [String:Any](), any: "", returnObj: returnData.object.object, message: message, success: success as! Bool, status: code as! NSInteger, errorMsg: returnData.errorMsg, isOk: returnData.isOk))
            return
        }
        if data is [[String:Any]] {
            
            finishedCallback(LTLreturnObj(arr: data as! [Any], dictArray: data as! [[String : Any]], dict: [String:Any](), any: data, returnObj: returnData.object.object, message: message, success: success as! Bool, status: code as! NSInteger, errorMsg: returnData.errorMsg, isOk: returnData.isOk))
            
        }
        else if data is [Any] {
            
            finishedCallback(LTLreturnObj(arr: data as! [Any], dictArray: [[String:Any]](), dict: [String:Any](), any: data, returnObj: returnData.object.object, message: message, success: success as! Bool, status: code as! NSInteger, errorMsg: returnData.errorMsg, isOk: returnData.isOk))
        }
        else if data is [String:Any]{
            
            finishedCallback(LTLreturnObj(arr: [Any](), dictArray: [[String:Any]](), dict: data as! [String:Any], any: data, returnObj: returnData.object.object, message: message, success: success as! Bool, status: code as! NSInteger, errorMsg: returnData.errorMsg, isOk: returnData.isOk))
        }
        else{
            
            finishedCallback(LTLreturnObj(arr: [Any](), dictArray: [[String:Any]](), dict: [String:Any](), any: data, returnObj: returnData.object.object, message: message, success: success as! Bool, status: code as! NSInteger, errorMsg: returnData.errorMsg, isOk: returnData.isOk))
        }
    }
    
}
