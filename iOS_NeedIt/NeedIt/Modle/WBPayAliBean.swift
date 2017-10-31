//
//  WBPayAliBean.swift
//  NeedIt
//
//  Created by Think on 16/3/23.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBPayAliBean: NSObject {
    var status: Int!
    
    var sign: String!
    var str: String!
    
    init(json: JSON) {
        status = json["status"].intValue
        
        sign = json["sign"].stringValue
        str = json["str"].stringValue
    }
    
}
