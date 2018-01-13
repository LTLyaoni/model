
//
//  UserInfoRequest.swift
//  appTemplates
//
//  Created by 李泰良 on 2017/10/19.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//

//import Foundation
import UIKit


class UserInfoRequest {
//   class func WXLogin() {
//        let accessToken = UserDefaults.standard.object(forKey: WX_ACCESS_TOKEN)
//        let openID = UserDefaults.standard.object(forKey: WX_OPEN_ID)
//        if accessToken != nil && openID != nil
//        {
//            let refreshToken:String = UserDefaults.standard.object(forKey: WX_REFRESH_TOKEN) as! String
//            let refreshUrlStr = WX_BASE_URL+"/oauth2/refresh_token?appid="+WXAppID+"&grant_type=refresh_token&refresh_token="+refreshToken
//            LTLNetworkTools.requestData(.get, URLString: refreshUrlStr, finishedCallback: { (responseObject) in
//                let refreshDict:Dictionary = responseObject as! [String:Any]
//                let reAccessToken = refreshDict[WX_ACCESS_TOKEN]
//                if reAccessToken != nil
//                {
//                    UserDefaults.standard.set(reAccessToken, forKey: WX_ACCESS_TOKEN)
//                    UserDefaults.standard.set(refreshDict[WX_OPEN_ID], forKey: WX_OPEN_ID)
//                    UserDefaults.standard.set(refreshDict[WX_REFRESH_TOKEN], forKey: WX_REFRESH_TOKEN)
//                    UserDefaults.standard.synchronize()
//                    // 当存在reAccessToken不为空时执行
//                    wechatLoginByRequestForUserInfo()
//                }
//                else
//                {
//                    wechatLogin()
//                }
//                
//            }, errorCallback: { (error) in
//                
//            })
//            
//        }
//        else
//        {
//            wechatLogin()
//        }
//    }
//    
//   class func wechatLogin()  {
//        if WXApi.isWXAppInstalled() {
//            let req = SendAuthReq.init()
//            req.scope = "snsapi_userinfo"
//            req.state = "GSTDoctorApp"
//            WXApi.send(req)
//        }
//        else
//        {
//            LTLSVProgressHUD.showError(withStatus: "未安装微信")
//        }
//    }
//    
//   class func wechatLoginByRequestForUserInfo()  {
//        getWxUserInfoWithSuccess { (responseObject) in
//            doWxLogin()
//        }
//    }
//    
//    
//    
//    
//    /// 获取用户个人信息（UnionID机制）
//   class func getWxUserInfoWithSuccess(finishedCallback :  @escaping (_ result : Any) -> ()) {
//        let accessToken:String = UserDefaults.standard.object(forKey: WX_ACCESS_TOKEN) as! String
//        let openID:String = UserDefaults.standard.object(forKey: WX_OPEN_ID) as! String
//        let userUrlStr = WX_BASE_URL+"/userinfo?access_token="+accessToken+"&openid="+openID
//        LTLNetworkTools.requestData(.get, URLString: userUrlStr, finishedCallback: { (responseObject) in
//            let refreshDict:Dictionary = responseObject as! [String:Any]
//            let userInfo = LTLUersInfo.shareInstance
//           
//            userInfo.WXIofn = WXUserInfo(fromDictionary: refreshDict)
//
//            finishedCallback(responseObject)
//            
//        }) { (error) in
//            LTLSVProgressHUD.showError(withStatus: "获取用户个人信息失败")
//        }
//    }
//    ///登录doWxLogin 和  编辑个人信息 (PS: 每一次登录都会根据微信的信息进行一次修改用户信息,所以在个人中心页面修改 头像,与微信相同的资料时时无用的)
//   class func doWxLogin()  {
//        let url = MainBaseURL+"/api/user/doWxLogin"
//        let uersInfo = LTLUersInfo.shareInstance
//    let parameters:[String : Any] = ["openId": uersInfo.WXIofn!.openid,"unionId":uersInfo.WXIofn!.unionid,"from":"wx","sourceUrl":"nil"]
//    
//    LTLNetworkTools.postConventionWith(URLString: url, parameters: parameters , finishedCallback: { (response) in
//        LTLLog(response)
//        let refreshDict:Dictionary = response as! [String:Any]
//        
////        LTLLog(items: refreshDict["status"] as! Bool)
//        
//        
//        
//    }) { (error) in
//        
//    }
//    
//    }
}


