//
//  NSURL+Extension.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

extension NSURL {
    /**
    解析URL询问字串中的键值对
    
    - parameter queryString: URL询问语句
    
    - returns: 键值对字典
    */
    class func parseURLQueryString(queryString: String) -> [String: String] {
        var dict = [String: String]()
        let pairs = queryString.componentsSeparatedByString("&")
        for pair in pairs {
            let keyValue = pair.componentsSeparatedByString("=")
            if keyValue.count == 2 {
                let value = keyValue[1].stringByRemovingPercentEncoding
                dict[keyValue[0]] = value
            }
        }
        
        return dict
    }
    
    /**
    智能生成正确的URL地址，
    
    - parameter string: 想要进入的web界面（或调起其他App）的url地址
    
    - returns: 可空的NSURL对象
    */
    class func smartURLForString(string: String) -> NSURL? {
        let trimmedStr = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var result:NSURL? = nil;
        if !trimmedStr.isEmpty {
            if let schemeMarkerRange = trimmedStr.rangeOfString("://") {
                if schemeMarkerRange.startIndex >= trimmedStr.startIndex {
                    let scheme = trimmedStr.substringToIndex(schemeMarkerRange.startIndex)
                    if scheme.isEmpty {
                        result = NSURL(string: "http\(trimmedStr)")
                    } else /*if scheme == "http" || scheme == "https"*/ {
                        result = NSURL(string: trimmedStr)
                    }
                } else {
                    result = NSURL(string: "http://\(trimmedStr)")
                }
            } else {
                result = NSURL(string: "http://\(trimmedStr)")
            }
        }
        
        return result;

    }
    
}
