//
//  WBUserManager.swift
//  NeedIt
//
//  Created by Think on 16/3/29.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit
import Foundation

let localToken = "user_local_token"
let localPhone = "user_phone_login"

let CSNSNotification_UserData_LogIn:String = "_csnsnotification_userdata_in"
let CSNSNotification_UserData_LogOut:String = "_csnsnotification_userdata_logout"
let CSNSNotification_UserData_Update:String = "_csnsnotification_userdata_update"
let CSNSNotification_UserLocation_Update:String = "_csnsnotification_userlocation_update"

class WBUserManager: NSObject {
    var userLocation:CLLocation?
    var userInfo: WBUserInfoBean?
    
    private var curUserCity:String = "长沙"
    private var isUserHaveLogin: Bool = false
    private var isSystemNewsRedDot: Bool = false
    
    class var sharedInstance: WBUserManager {
        struct Singleton {
            static let instance = WBUserManager()
        }
        return Singleton.instance
    }
    
    override init() {
        isUserHaveLogin = !(NSUserDefaults.standardUserDefaults().stringForKey(localToken) ?? "").isEmpty
    }
    
    func isUserLogined() -> Bool {
        return isUserHaveLogin
    }
    
    func updateUserInfo() {
        if isUserHaveLogin {
            requestUserInfoContent()
        }
    }
    
    func doUserLogIn(token:String ,phone:String) {
        updateAppLocalToken(token)
        updateAppUserPhone(phone)
        isUserHaveLogin = true
        NSNotificationCenter.defaultCenter().postNotificationName(CSNSNotification_UserData_LogIn, object: nil)
    }
    
    func doUserLogOut() {
        updateAppLocalToken("")
        updateAppUserPhone("")
        isUserHaveLogin = false
        NSNotificationCenter.defaultCenter().postNotificationName(CSNSNotification_UserData_LogOut, object: nil)
    }
    
    func isNeedShowSystemRedDot() -> Bool {
        return isSystemNewsRedDot
    }
    
    func updateSystemRedDotState(isShowed: Bool) {
        isSystemNewsRedDot = !isShowed
    }

    func appLocalCity() -> String {
        return curUserCity
    }
    
    func updateAppLocalCity(cityName : String) -> Void {
        curUserCity = cityName
    }

    func appLocalToken() -> String {
        return NSUserDefaults.standardUserDefaults().stringForKey(localToken) ?? ""
    }
    
    func updateAppLocalToken(appToken : String) -> Void {
         isUserHaveLogin = true
        NSUserDefaults.standardUserDefaults().setObject(appToken, forKey: localToken)
    }
    
    func appUserPhone() -> String {
        return NSUserDefaults.standardUserDefaults().stringForKey(localPhone) ?? ""
    }
    
    func updateAppUserPhone(appPhone : String) -> Void {
        NSUserDefaults.standardUserDefaults().setObject(appPhone, forKey: localPhone)
    }
    
    func getDistence(tagLoc:CLLocation) -> String {
        guard let _ = userLocation else {
            return "未知"
        }
        let meters = userLocation!.distanceFromLocation(tagLoc)
        if meters > 1000 {
            return"\(meters/1000)km"
        }
        return "\(meters)m"
    }
    
    private func requestUserInfoContent() {
        //        let uid = CSUserManager.sharedInstance.userServerUID()
        //        let urluserInfo = WBNetManager.sharedInstance.getuserInfoURL(uid)
        //        print("更新用户信息:\(urluserInfo)")
        //        WBNetManager.sharedInstance.requestByGet(urluserInfo) { (isSuccess, isFailure, json, error) -> Void in
        //            if isSuccess {
        //                let retoBJ = WBParseNetBase(json: json)
        //                let tmpuserInfo = CSUserInfoBean(json: JSON(retoBJ.data))
        //                self.userInfo = tmpuserInfo
        //
        //                if 0 < (tmpuserInfo.sysMsg as NSString).integerValue {
        //                    self.isSystemNewsRedDot = true
        //                }else{
        //                    self.isSystemNewsRedDot = false
        //                }
        //                NSNotificationCenter.defaultCenter().postNotificationName(CSNSNotification_UserData_Update, object: nil)
        //                return
        //            }
        //            if isFailure {
        //            }
        //        }
    }
}
