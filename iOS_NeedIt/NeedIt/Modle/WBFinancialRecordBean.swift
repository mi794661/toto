//
//  WBFinancialRecordBean.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

//1=返现（UI红色字）
//2=提现（UI绿色字）
class WBFinancialRecordBean: NSObject {
    
    var type: Int!
    var time: String!
    var total: String!
    
    init(json: JSON) {
        type = json["type"].intValue
        time = json["time"].stringValue
        total = json["total"].stringValue
        
    }
    
}
