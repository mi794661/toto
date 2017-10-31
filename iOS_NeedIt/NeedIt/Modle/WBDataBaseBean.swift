//
//  WBDataBaseBean.swift
//  NeedIt
//
//  Created by Think on 16/4/1.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBDataBaseBean: NSObject {

    var price: String!
    var img: String!
    var dataId: String!
    var toAccount: String!
    var time: String!
    var name: String!
    
    init(json: JSON) {
        price = json["price"].stringValue
        img = json["img"].stringValue
        dataId = json["id"].stringValue
        toAccount = json["to_account"].stringValue
        time = json["time"].stringValue
        name = json["name"].stringValue
        
    }
    
}
