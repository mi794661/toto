//
//  WBNetManager.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBNetManager: WBBaseNetManager {
    
    private lazy var _loacalToken : String = ""
    
    class var sharedInstance: WBNetManager {
        struct Singleton {
            static let instance = WBNetManager()
        }
        return Singleton.instance
    }
    
    //隐私协议
    func getAppProtocolURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/public/protocol"
    }
    
    //商家入驻 -  Web
    func getAppBuildingURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/public/productSubmit"
    }
    
    //首页通知
    func getHomeHeadNoticeURL() -> String {
        return CS_REQUEST_BASEURL + "/xym/app.php/FrontPage/headnotice"
    }
    
    //首页头图
    func getHomeHeadAdURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Index/headImg"
    }
    
    //首页列表
    func getHomeListURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Index/productList"
    }
    
    //用户登录
    func getUserLoginURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Public/logIn"
    }
    
    //用户注册-发送验证码
    func getSignVerifyURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Public/signVerify"
    }
    
    //用户注册-提交密码
    func getSignUpURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Public/signUp"
    }
    
    //商品详情
    func getActivityDetailURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Product/productDetail"
    }
    
    //浏览过该商品的人还看过
    func getActivityProductLikeURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Product/productMaybeLike"
    }
    
    //提交订单
    func getMakeOrderURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Order/makeOrder"
    }
    
    //支付
    func getPayOrderURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Order/goPay"
    }
    
    //热搜词
    func getHotKeyURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Search/hotsearch"
    }
    
    //搜索结果
    func getSearchKeyURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Search/doSearch"
    }
    
    //订单列表
    func getOrderListURL(pageIndex: NSInteger = 0,dataId: String = "") -> String {
        let urlStr = CS_REQUEST_BASEURL + "/main/app.php/order/orderlist"
        if pageIndex <= 0 || dataId.isEmpty {
            return urlStr
        }
        return urlStr + "&\(CS_REQUEST_PAGE)=\(pageIndex)&\(CS_REQUEST_END_ID)=\(dataId)"
    }
    
    //返利列表——未参与
    func getToRebateListURL(pageIndex: NSInteger = 0,dataId: String = "") -> String {
        let urlStr = CS_REQUEST_BASEURL + "/main/app.php/Video/videoList"
        if pageIndex <= 0 || dataId.isEmpty {
            return urlStr
        }
        return urlStr + "&\(CS_REQUEST_PAGE)=\(pageIndex)&\(CS_REQUEST_END_ID)=\(dataId)"
    }
    
    //返利列表——已参加
    func getRebatedListURL(pageIndex: NSInteger = 0,dataId: String = "") -> String {
        let urlStr = CS_REQUEST_BASEURL + "/main/app.php/Video/canyu"
        if pageIndex <= 0 || dataId.isEmpty {
            return urlStr
        }
        return urlStr + "&\(CS_REQUEST_PAGE)=\(pageIndex)&\(CS_REQUEST_END_ID)=\(dataId)"
    }
    
    //视频（完整观看后）返利
    func getVideoRebateURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Video/fanliVideo"
    }
    
    //调查问卷页面
    func getQuestionListURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Video/questionList"
    }
    
    //提交调查问卷的答案
    func getQuestionAnswerSubmitURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Video/answerSubmit"
    }
    
    //消息通知
    func getNotificationListURL(pageIndex: NSInteger = 0,dataId: String = "") -> String {
        let urlStr =  CS_REQUEST_BASEURL + "/main/app.php/User/notificationList"
        if pageIndex <= 0 || dataId.isEmpty {
            return urlStr
        }
        return urlStr + "&\(CS_REQUEST_PAGE)=\(pageIndex)&\(CS_REQUEST_END_ID)=\(dataId)"
    }
    
    //我的钱包——财务记录
    func getFinancialDetailURL(pageIndex: NSInteger = 0,dataId: String = "") -> String {
        let urlStr =  CS_REQUEST_BASEURL + "/main/app.php/User/financialDetail"
        if pageIndex <= 0 || dataId.isEmpty {
            return urlStr
        }
        return urlStr + "&\(CS_REQUEST_PAGE)=\(pageIndex)&\(CS_REQUEST_END_ID)=\(dataId)"
    }

    //我的钱包——财务记录
    func getTotalMoneyURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/user/totalMoney"
    }
    
    //我的钱包——提取现金
    func getDrawMoneyURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/user/drawMoney"
    }
    
    //成交
    func getOrderDealURL() -> String {
        return CS_REQUEST_BASEURL + "/main/app.php/Order/orderDeal"
    }
    
}
