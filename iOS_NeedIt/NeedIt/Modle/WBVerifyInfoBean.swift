//
//  WBVerifyInfoBean.swift
//  NeedIt
//
//  Created by Think on 16/3/22.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

//0=参数错误; 1=成功; 2=此号码已经注册，请尝试找回密码; 3=验证码发送失败，请重试
class WBVerifyInfoBean: NSObject {
    var status: Int?
    var errMsg: String?
    
    init(json: JSON) {
        status = json["status"].intValue
        errMsg = json["err_msg"].stringValue
    }
    
}
