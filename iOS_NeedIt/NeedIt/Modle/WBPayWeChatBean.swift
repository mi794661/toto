//
//  WBPayWeChatBean.swift
//  NeedIt
//
//  Created by Think on 16/3/23.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBPayWeChatBean: NSObject {
    var status: Int!
    
    var noncestr: String!
    var appid: String!
    var sign: String!
    var partnerid: String!
    var timeStamp: String!
    var prepayid: String!
    var package: String!
    
    init(json: JSON) {
        status = json["status"].intValue
        
        noncestr = json["noncestr"].stringValue
        appid = json["appid"].stringValue
        sign = json["sign"].stringValue
        partnerid = json["partnerid"].stringValue
        timeStamp = json["timestamp"].stringValue
        prepayid = json["prepayid"].stringValue
        package = json["package"].stringValue
        
    }
    
    
}
