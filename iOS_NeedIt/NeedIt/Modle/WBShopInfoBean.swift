//
//  WBShopInfoBean.swift
//  NeedIt
//
//  Created by Think on 16/3/22.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBShopInfoBean: NSObject {
    
    var city: String!
    var address: String!
    var mapX: String!
    var mapY: String!
    var dataId: String!
    var phone: String!
    var name: String!
    
    init(json: JSON) {
        city = json["city"].stringValue
        address = json["address"].stringValue
        mapX = json["map_x"].stringValue
        mapY = json["map_y"].stringValue
        dataId = json["id"].stringValue
        phone = json["phone"].stringValue
        name = json["name"].stringValue
        
    }
}
