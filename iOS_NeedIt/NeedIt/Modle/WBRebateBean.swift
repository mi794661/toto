//
//  WBRebateBean.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBRebateBean: NSObject {

    var type: Int
    var img: String
    var product: String
    var dataId: String
    var oid: String
    var url: String
    var name: String
    
    init(json: JSON) {
        type = json["type"].intValue
        img = json["img"].stringValue
        product = json["product"].stringValue
        dataId = json["id"].stringValue
        oid = json["oid"].stringValue
        url = json["url"].stringValue
        name = json["name"].stringValue
        
    }
    
}
