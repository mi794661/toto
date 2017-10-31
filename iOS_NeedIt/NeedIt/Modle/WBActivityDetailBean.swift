//
//  WBActivityDetailBean.swift
//  NeedIt
//
//  Created by Think on 16/3/23.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBActivityDetailBean: NSObject {
    
    var data: WBActivityInfoBean
    var status: Int
    var shop: WBShopInfoBean
    
    init(json: JSON) {
        data = WBActivityInfoBean(json: json["data"])
        status = json["status"].intValue
        shop = WBShopInfoBean(json: json["shop"])
        
    }
}
