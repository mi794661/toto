//
//  WBActivityProductLikeBean.swift
//  NeedIt
//
//  Created by Think on 16/3/23.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBActivityProductLikeBean: NSObject {
    
    var price: String!
    var img: String!
    var dataId: String!
    var unit: String!
    var name: String!
    
    init(json: JSON) {
        price = json["price"].stringValue
        img = json["img"].stringValue
        dataId = json["id"].stringValue
        unit = json["unit"].stringValue
        name = json["name"].stringValue
        
    }
    
}
