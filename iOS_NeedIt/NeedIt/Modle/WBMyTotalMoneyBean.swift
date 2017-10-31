//
//  WBMyTotalMoneyBean.swift
//  NeedIt
//
//  Created by Think on 16/3/30.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBMyTotalMoneyBean: NSObject {
    
    var data: String!
    var status: Int!
    
    func isDataOk() -> Bool {
        return (status == 1)
    }
    
    init(json: JSON) {
        data = json["data"].stringValue
        status = json["status"].intValue
        
    }
}
