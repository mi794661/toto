//
//  WBQuestionBean.swift
//  NeedIt
//
//  Created by Think on 16/3/30.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBQuestionBean: NSObject {
    
    var dataId: String!
    var title: String!
    var selectb: String!
    var selecta: String!
    var selectc: String!
    var selectd: String!
    
    init(json: JSON) {
        dataId = json["id"].stringValue
        title = json["title"].stringValue
        
        selecta = json["selecta"].stringValue
        selectb = json["selectb"].stringValue
        selectc = json["selectc"].stringValue
        selectd = json["selectd"].stringValue
        selectd = json["selectd"].stringValue
    }
    
    
}
