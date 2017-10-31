//
//  NSData+Extension.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import Foundation

extension NSData {
    var base64Encode: String {
        return self.base64EncodedStringWithOptions([])
    }
}
