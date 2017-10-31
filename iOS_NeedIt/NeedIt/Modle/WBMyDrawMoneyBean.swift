//
//  WBMyDrawMoneyBean.swift
//  NeedIt
//
//  Created by Think on 16/3/30.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBMyDrawMoneyBean: NSObject {

    /*
     0=参数错误
     1=成功
     5=未登录
     18=提取金额不能大于钱包总额
     19=提取失败请重试
     
     */
    var status: Int = 0
    var msg: String
    
    func isDataOk() -> Bool {
        return (status == 1)
    }
    
    init(json: JSON) {
        if json["status"].exists() {
            status = json["status"].intValue
        }else{
            status = -1
        }
        if json["err_msg"].exists() {
            msg = json["err_msg"].stringValue
        }else{
            msg = "数据错误"
        }
        
        
    }
    
}
