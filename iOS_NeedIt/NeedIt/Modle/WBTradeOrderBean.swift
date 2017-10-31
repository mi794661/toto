//
//  WBTradeOrderBean.swift
//  NeedIt
//
//  Created by Think on 16/3/23.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBTradeOrderBean: NSObject {
    
    var tradeCode: String!
    var status: Int!
    var total: Int!
    var msg: String?
    
    var num: Int = 0
    var allMoney: String = ""
    
    init(json: JSON) {
        tradeCode = json["trade_code"].stringValue
        status = json["status"].intValue
        total = json["total"].intValue
        
        if json[CS_RESPONSE_MSG].exists() {
            msg = json[CS_RESPONSE_MSG].stringValue
        }
        
    }
    
}
