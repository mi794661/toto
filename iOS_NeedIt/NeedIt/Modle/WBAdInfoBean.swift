//
//  WBAdInfoBean.swift
//  NeedIt
//
//  Created by Think on 16/3/22.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBAdInfoBean: NSObject {
    
    var img: String = ""
    var urlId: String = ""
    
    init(json: JSON) {
        img = json["img"].stringValue
        urlId = json["url_id"].stringValue
        print("图片下载\(urlId)")
    }
    
}
