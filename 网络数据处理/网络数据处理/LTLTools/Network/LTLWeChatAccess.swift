//
//  LTLLTLWeChatAccess.swift
//  appTemplates
//
//  Created by 李泰良 on 2017/11/12.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//

import UIKit


let WX_ACCESS_TOKEN = "access_token"
let WX_OPEN_ID = "openid"
let WX_REFRESH_TOKEN = "refresh_token"
let WX_UNION_ID = "unionid"
//微信授权成功通知
let LTLAuthorizationSuccessNotification = "LTLAuthorizationSuccessNotification"
let LTLPayNotification = "LTLPayNotification"

class LTLWeChatAccess: NSObject {
    /// 创建单例
    static let shared : LTLWeChatAccess = {
        
        let weChatAccess = LTLWeChatAccess()
        
        return weChatAccess
        
    }()
}
//extension LTLWeChatAccess :WXApiDelegate
//{
//    //    如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
//    func onResp(_ resp: BaseResp!) {
//        if resp.isKind(of: SendAuthResp.self)
//        {
//            //            let accessUrlStr = WX_BASE_URL+"/oauth2/access_token?appid="+WXAppID+"&secret="+WXAppSecret+"&code="+(resp as! SendAuthResp).code+"&grant_type=authorization_code"
//            //            LTLNetworkTools.requestData(.get, URLString: accessUrlStr, finishedCallback: {(response) in
//            //                let accessDict:Dictionary = response  as! [String : Any]
//            ////                let accessToken:String = accessDict[WX_ACCESS_TOKEN] as! String
//            ////                let openID:String = accessDict[WX_OPEN_ID] as! String
//            ////                let refreshToken:String = accessDict[WX_REFRESH_TOKEN] as! String
//            ////                if accessToken != "" && openID != ""
//            ////                {
//            ////                    UserDefaults.standard.set(accessToken, forKey: WX_ACCESS_TOKEN)
//            ////                    UserDefaults.standard.set(openID, forKey: WX_OPEN_ID)
//            ////                    UserDefaults.standard.set(refreshToken, forKey: WX_REFRESH_TOKEN)
//            ////                    // 命令直接同步到文件里，来避免数据的丢失
//            ////                    UserDefaults.standard.synchronize()
//            ////                    ///已授权
//            ////                    UserDefaults.standard.set(true, forKey: IsAuthorization)
//            ////                }
//            //
//            ////                SVProgressHUD.show()
//            //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LTLAuthorizationSuccessNotification), object: self, userInfo: accessDict)
//            //
//            //            }, errorCallback: { (error) in
//            ////                SVProgressHUD.showError(withStatus: "网络请求错误")
//            //            })
//            //        }
//            //        else if resp.isKind(of: PayResp.self)
//            //        {
//            //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LTLPayNotification), object: nil, userInfo: ["state":resp.errCode])
//        }
//    }
//    
//}

