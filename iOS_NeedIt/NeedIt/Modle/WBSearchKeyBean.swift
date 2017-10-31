//
//  WBSearchKeyBean.swift
//  NeedIt
//
//  Created by Think on 16/3/24.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBSearchKeyBean: NSObject {
    
    var slogan: String!
    var product: String!
    
    init(json: JSON) {
        slogan = json["slogan"].stringValue
        product = json["product"].stringValue
    }
    
}
