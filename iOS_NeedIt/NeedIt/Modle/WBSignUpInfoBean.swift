
//
//  WBSignUpInfoBean.swift
//  NeedIt
//
//  Created by Think on 16/3/22.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

//0=参数错误; 1=成功; 2=验证码错误; 3=号码已注册
class WBSignUpInfoBean: NSObject {
    var status: Int?
    var errMsg: String?
    
    init(json: JSON) {
        status = json["status"].intValue
        errMsg = json["err_msg"].stringValue
    }
    
}
