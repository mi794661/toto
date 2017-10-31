//
//  WBParseNetBase.swift
//  NeedIt
//
//  Created by Think on 16/3/22.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBParseNetBase: NSObject {
    var data: AnyObject
    var code: Int = 0
    var msg: String
    
    func isDataOk() -> Bool {
        return (code == 1)
    }
    
    init(json: JSON) {
        if json[CS_RESPONSE_CODE].exists() {
            code = json[CS_RESPONSE_CODE].intValue
        }else{
            code = -1
        }
        if json[CS_RESPONSE_MSG].exists() {
            msg = json[CS_RESPONSE_MSG].stringValue
        }else{
            if 1 == code {
                msg = "无更多数据"
            }else{
                msg = "数据错误"
            }
        }
        if json[CS_RESPONSE_DATA].exists() {
            data = json[CS_RESPONSE_DATA].object
        }else{
            data = NSNull()
        }
        
    }
    
}
