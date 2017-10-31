//
//  WBParseQuestionBean.swift
//  NeedIt
//
//  Created by Think on 16/3/30.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBParseQuestionBean: NSObject {
    
    var status: Int!
    var order: WBOrderInfoBean!
    var questions: [WBQuestionBean]!
    
    init(json: JSON) {
        status = json["status"].intValue
        order = WBOrderInfoBean(json: json["order"])
        questions = []
        if let items = json["questions"].array {
            for item in items {
                questions?.append(WBQuestionBean(json: item))
            }
        } else {
            questions = nil
        }
        
    }
    
}
