//
//  WBOrderInfoBean.swift
//  NeedIt
//
//  Created by Think on 16/3/23.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBOrderInfoBean: NSObject {
    
    var tradeCode: String!
    var img: String!
    var total: String!
    var dataId: String!
    var status: String!
    var name: String!
    
    init(json: JSON) {
        tradeCode = json["trade_code"].stringValue
        img = json["img"].stringValue
        total = json["total"].stringValue
        dataId = json["id"].stringValue
        status = json["status"].stringValue
        name = json["name"].stringValue
        
    }
}
