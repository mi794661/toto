//
//  WBHomeNoticeBean.swift
//  NeedIt
//
//  Created by Think on 16/3/22.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBHomeNoticeBean: NSObject {
    
    var status: Int = 0
    var text: String = ""
    
    init(json: JSON) {
        status = json["status"].intValue
        text = json["text"].stringValue
    }
    
}
