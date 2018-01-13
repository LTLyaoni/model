//
//  NetworkConfig.swift
//  appTemplates
//
//  Created by 123 on 2017/11/13.
//  Copyright © 2017年 LiTaiLiang. All rights reserved.
//

import Foundation
///域名
let MainBaseURL : String = {
    #if DEBUG
        return "http://192.168.3.6:8080"
    #else
        return "http://xiaoyuke.zaixue365.com "
    #endif
}()
///路径
private let SecondPath = "/api"
///校验头
let kAPPID = "21"
let MkAppSign = "9999999999"

let Mk_App_Id = "Mk-App-Id"
let Mk_App_Sign = "Mk-App-Sign"



public enum API:String {
    case path = "/api"
    //MARK:---------API后缀-----------
    ///获取机构信息
    case  orgFullInfo = "/org/getOrgFullInfo"
    ///2-2 登录
    case  login =  "/user/login"
    ///2-1 注册
    case  Regist =  "/user/regist"
    ///1-1 发送验证码
    case  sendVerifyCode =  "/sms/sendVerifyCode"
    ///1-2 检查验证码
    case  checkCarefulVerifyCode =  "/sms/checkCarefulVerifyCode"
    ///2-3 找回密码
    case  resetPwd =  "/user/resetPwd"
    ///3-2 获取首页数据
    case  index =  "/course/index"
    ///3-1 获取首页推荐课
    case  listRecommendedCourse =  "/course/listRecommendedCourse"
    ///4-2 获取课时详情(包括直播数据)
    case  LiveConfig =  "/lession/detailLessionWithLive"
    ///4-12 获取教学历史消息(仅针对语音课)
    case  HistoryVoiceMsgLive =  "/lession/historyVoiceMsgLive"
    ///4-13 获取讨论区消息
    case  HistoryMsgLive =  "/lession/historyMsgLive"
    ///4-10 发送直播消息(文字，图片，语音等)
    case  SendMsgLive =  "/lession/sendMsgLive"
    /// 1-4 上传文件(直播处理)
    case  UploadLive =  "/lession/uploadLive"
    ///4-7 获取直播课的ppt图片
    case  GetPptListLive =  "/lession/getPptListLive"
    ///4-8 获取直播课的doc列表
    case  GetDocListLive =  "/lession/getDocListLive"
    ///4-9 删除直播课的doc
    case  DelDocLive =  "/lession/delDocLive"
    ///1-5 上传文件(ppt课件上传到mk的接口,这里是指通过)
//    @available(*, unavailable, message: "已失效,不要再用,请 UploadLive")
//    case  UploadMobileImageLive =  "/file/uploadMobileImageLive"
    ///4-16 教学区消息已读
    case  ReadMsgLive =  "/lession/readMsgLive"
    ///4-15 教学区消息点赞接口地
    case  ZanLive =  "/lession/zanLive"
    ///4-11 删除直播课的消息
    case  DelMsgLive =  "/lession/delMsgLive"
    ///4-18 直播讨论区禁言/取消某人
    case  UpdateUserSilence =  "/lession/updateUserSilence"
    ///4-20 禁言整个直播
    case  UpdateSilence =  "/lession/updateSilence"
    /// 4-19 获取直播的参与人员
    case  GetUserNameList =  "/lession/getUserNameList"
    ///4-21 直播踢人
    case  Drop =  "/lession/drop"
    ///4-26 获取直播绘图历史消息
    case  HistoryDrawMsgLive =  "/lession/historyDrawMsgLive"
    ///4-22 获取推广海报
    case  share =  "/share/listPosterItemTo"
    ///4-30 课时的学习成员
    case  UserInLession =  "/courseStudyhistory/listLatestUserInLession"
    ///4-5 获取课时评价
    case  listLessionEval =  "/courseEval/listLessionEval"
    ///4-6 获取留言
    case  listAllComment =  "/comment/listAllComment"

}


//MARK:---------API后缀-----------
///获取机构信息
let NetWork_orgFullInfo = SecondPath+"/org/getOrgFullInfo"
//MARK:---------服务协议-----------
//http://daxue.zaixue365.com/article/detail?articleId=58
let ServiceAgreement = MainBaseURL+"/article/detail?articleId=58"
///2-2 登录
let NetWork_Login = SecondPath+"/user/login"
///2-1 注册
let NetWork_Regist = SecondPath+"/user/regist"
///1-1 发送验证码
let NetWork_sendVerifyCode = SecondPath+"/sms/sendVerifyCode"
///1-2 检查验证码
let NetWork_checkCarefulVerifyCode = SecondPath+"/sms/checkCarefulVerifyCode"
///2-3 找回密码
let NetWork_resetPwd = SecondPath+"/user/resetPwd"
///3-2 获取首页数据
let NetWork_index = SecondPath+"/course/index"
///3-1 获取首页推荐课
let NetWork_listRecommendedCourse = SecondPath+"/course/listRecommendedCourse"
///4-2 获取课时详情(包括直播数据)
let NetWork_LiveConfig = SecondPath+"/lession/detailLessionWithLive"
///4-12 获取教学历史消息(仅针对语音课)
let NetWork_HistoryVoiceMsgLive = SecondPath+"/lession/historyVoiceMsgLive"
///4-13 获取讨论区消息
let NetWork_HistoryMsgLive = SecondPath+"/lession/historyMsgLive"
///4-10 发送直播消息(文字，图片，语音等)
let NetWork_SendMsgLive = SecondPath+"/lession/sendMsgLive"
/// 1-4 上传文件(直播处理)
let NetWork_UploadLive = SecondPath+"/lession/uploadLive"
///4-7 获取直播课的ppt图片
let NetWork_GetPptListLive = SecondPath+"/lession/getPptListLive"
///4-8 获取直播课的doc列表
let NetWork_GetDocListLive = SecondPath+"/lession/getDocListLive"
///4-9 删除直播课的doc
let NetWork_DelDocLive = SecondPath+"/lession/delDocLive"
///1-5 上传文件(ppt课件上传到mk的接口,这里是指通过)
@available(*, unavailable, message: "已失效,不要再用,请NetWork_UploadLive")
let NetWork_UploadMobileImageLive = SecondPath+"/file/uploadMobileImageLive"
///4-16 教学区消息已读
let NetWork_ReadMsgLive = SecondPath+"/lession/readMsgLive"
///4-15 教学区消息点赞接口地
let NetWork_ZanLive = SecondPath+"/lession/zanLive"
///4-11 删除直播课的消息
let NetWork_DelMsgLive = SecondPath+"/lession/delMsgLive"
///4-18 直播讨论区禁言/取消某人
let NetWork_UpdateUserSilence = SecondPath+"/lession/updateUserSilence"
///4-20 禁言整个直播
let NetWork_UpdateSilence = SecondPath+"/lession/updateSilence"
/// 4-19 获取直播的参与人员
let NetWork_GetUserNameList = SecondPath+"/lession/getUserNameList"
///4-21 直播踢人
let NetWork_Drop = SecondPath+"/lession/drop"
///4-26 获取直播绘图历史消息
let NetWork_HistoryDrawMsgLive = SecondPath+"/lession/historyDrawMsgLive"
///4-22 获取推广海报
let NetWork_share = SecondPath+"/share/listPosterItemTo"
///4-30 课时的学习成员
let NetWork_UserInLession = SecondPath+"/courseStudyhistory/listLatestUserInLession"
///4-5 获取课时评价
let NetWork_listLessionEval = SecondPath+"/courseEval/listLessionEval"
///4-6 获取留言
let NetWork_listAllComment = SecondPath+"/comment/listAllComment"


