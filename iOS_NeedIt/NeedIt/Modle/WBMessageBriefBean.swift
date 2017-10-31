//
//  WBMessageBriefBean.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBMessageBriefBean: NSObject {
    
    var title: String!
    var content: String!
    var time: String!
    
    init(json: JSON) {
        title = json["title"].stringValue
        content = json["content"].stringValue
        time = json["time"].stringValue
        
    }
}
