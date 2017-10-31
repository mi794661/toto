//
//  WBActivityProductLikeInfoBean.swift
//  NeedIt
//
//  Created by Think on 16/3/23.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBActivityProductLikeInfoBean: NSObject {
    
    var data: [WBActivityProductLikeBean]
    var status: Int
    
    init(json: JSON) {
        data = []
        if let items = json["data"].array {
            for item in items {
                data.append(WBActivityProductLikeBean(json: item))
            }
        } else {
        }
        status = json["status"].intValue
        
    }
    
}
