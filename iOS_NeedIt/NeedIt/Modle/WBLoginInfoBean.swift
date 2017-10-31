//
//  WBLoginInfoBean.swift
//  NeedIt
//
//  Created by Think on 16/3/22.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

//0=参数错误; 1=成功; 2=密码错误; 3=号码还未注册
class WBLoginInfoBean: NSObject {
    
    var status: Int!
    var errMsg: String!
    var token: String!
    
    init(json: JSON) {
        status = json["status"].intValue
        errMsg = json["err_msg"].stringValue
        token = json["token"].stringValue
    }
    
}
