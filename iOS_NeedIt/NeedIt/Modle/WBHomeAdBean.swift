//
//  WBHomeAdBean.swift
//  NeedIt
//
//  Created by Think on 16/3/22.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBHomeAdBean: NSObject {
    
    
    
    
    var status: Int = 0
    var dataList: [WBAdInfoBean]!
    init(json: JSON) {
        
        print("下载成功：\(json)")
        status = json["status"].intValue
        
        dataList = []
        if let items = json["data"].array {
            for item in items {
                dataList.append(WBAdInfoBean(json: item))
            }
        } else {

        }
        
    }
    
}
