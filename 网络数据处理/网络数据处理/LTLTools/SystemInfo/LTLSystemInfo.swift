//
//  LTLSystemInfo.swift
//  appTemplates
//
//  Created by 123 on 2017/11/14.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//

import UIKit
///
private let loginKey:String = "MKloginKey"
///
private let appVersionKey:String = "MKAPPVersionKey"
///标识应用程序的发布版本号
private let VersionString:String = "CFBundleShortVersionString"
///app名称
private let app_Name:String = "CFBundleDisplayName"


class LTLSystemInfo: NSObject {
    
    //    private let MKdefaults = UserDefaults.standard
    ///判断是否已登录
    static var IsLogin : Bool
    {
        get
        {
            return UserDefaults.standard.bool(forKey: loginKey)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: loginKey)
            UserDefaults.standard.synchronize()
        }
    }
    ///判断是否是第一次启动
    static var FirstBoot: Bool
    {
        get
        {
            // 得到当前应用的版本号
         
//            let infoDictionary = Bundle.main.infoDictionary
//            let currentAppVersion = infoDictionary![VersionString] as! String
            let currentAppVersion = self.version
            // 取出之前保存的版本号
            let userDefaults = UserDefaults.standard
            let appVersion = userDefaults.string(forKey: appVersionKey)
            
            // 如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
            if appVersion == nil || appVersion != currentAppVersion
            {
                
                // 保存最新的版本号
                userDefaults.set(currentAppVersion, forKey: appVersionKey)
                return true
            }
            else
            {
                return false
            }
        }
    }
    // 得到当前应用的版本号
    static private(set) var version: String =
    {
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary![VersionString] as! String
        return currentAppVersion
    }()
    //app名称
    static private(set) var APPName: String =
    {
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary![app_Name] as! String
        return currentAppVersion
    }()
}
