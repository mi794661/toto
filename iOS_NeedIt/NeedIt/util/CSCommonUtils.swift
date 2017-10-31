//
//  CSCommonUtils.swift
//  Delicious
//
//  Created by Think on 15/12/28.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import Foundation

class CSCommonUtils: NSObject {
    
    static func verifyPhoneNumber(number: String) -> Bool {
        let mobile = "^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        return regextestmobile.evaluateWithObject(number)
    }
    
    static func verifyPassword(password: String) -> Bool {
        let pwd = "^[a-zA-Z0-9]{6,20}$"
        let regextestPwd = NSPredicate(format: "SELF MATCHES %@", pwd)
        return regextestPwd.evaluateWithObject(password)
    }
    
    static func verifyNickName(nickName: String) -> Bool {
        let name = "^[a-zA-Z0-9]{1,20}$"
        let regextestName = NSPredicate(format: "SELF MATCHES %@", name)
        return regextestName.evaluateWithObject(nickName)
    }
    
}