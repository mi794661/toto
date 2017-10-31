//
//  String+Extension.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import Foundation

extension String {
    var MD5: String {
        let cString = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let length = CUnsignedInt(
            self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        )
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(
            Int(CC_MD5_DIGEST_LENGTH)
        )
        
        CC_MD5(cString!, length, result)
        
        return String(format:
            "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15])
    }
    
    // MARK:
    // https://github.com/Alamofire/Alamofire/blob/master/Source/ParameterEncoding.swift
    var urlEncodeString: String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)
        
        var escaped = ""
        if #available(iOS 8.3, OSX 10.10, *) {
            escaped = self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? self
        } else {
            let batchSize = 50
            var index = self.startIndex
            
            while index != self.endIndex {
                let startIndex = index
                let endIndex = index.advancedBy(batchSize, limit: self.endIndex)
                let range = Range(start: startIndex, end: endIndex)
                
                let substring = self.substringWithRange(range)
                
                escaped += substring.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    var data: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
    
    var base64Encode: NSData {
        return NSData(base64EncodedString: self, options: [])!
    }

    static func getTimeDifference(dateStr: String) -> String {
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let da = dateForm.dateFromString(dateStr)
        let now = NSDate()
        let das = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = [.NSYearCalendarUnit,.NSMonthCalendarUnit,.NSDayCalendarUnit,.NSHourCalendarUnit,.NSMinuteCalendarUnit,.NSSecondCalendarUnit]
        let nowCom = das.components(flags, fromDate: now)
        let timeCom = das.components(flags, fromDate: da!)
        
        if timeCom.year == nowCom.year {
            if timeCom.month == nowCom.month {
                if timeCom.day == nowCom.day {
                    if timeCom.hour == nowCom.hour {
                        if (nowCom.minute - timeCom.minute) > 0 {
                            return "\(nowCom.minute - timeCom.minute)分钟前"
                        }
                        
                    }else {
                        return "今天 \(timeCom.hour):\(timeCom.minute)"
                    }
                }else {
                    if nowCom.day - timeCom.day == 1 {
                        return "昨天 \(timeCom.hour):\(timeCom.minute)"
                    }else {
                        if (nowCom.day - timeCom.day) > 0 {
                            return "\(nowCom.day - timeCom.day)天前"
                        }
                    }
                }
                return da!.convertToString("dd日HH:mm")
            }else {
                if (nowCom.month - timeCom.month) > 0 {
                    return "\(nowCom.month - timeCom.month)月前"
                }
                return da!.convertToString("MM月dd日HH:mm")
            }
            
        }else{
            return da!.convertToString("yyyy年MM月dd日")
        }
    }
    
    static func getTimeDifferenceForCountdown(dateStr: String) -> String {
        let dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let da = dateForm.dateFromString(dateStr)
        let now = NSDate()
        let das = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = [.NSYearCalendarUnit,.NSMonthCalendarUnit,.NSDayCalendarUnit,.NSHourCalendarUnit,.NSMinuteCalendarUnit,.NSSecondCalendarUnit]
        let nowCom = das.components(flags, fromDate: now)
        let timeCom = das.components(flags, fromDate: da!)
        
        if timeCom.year == nowCom.year {
            if timeCom.month == nowCom.month {
                if timeCom.day == nowCom.day {
                    if timeCom.hour == nowCom.hour {
                        if (nowCom.minute - timeCom.minute) > 0 {
                            return "\(nowCom.minute - timeCom.minute)分钟前"
                        }
                        
                    }else {
                        return "今天 \(timeCom.hour):\(timeCom.minute)"
                    }
                }else {
                    if nowCom.day - timeCom.day == 1 {
                        return "昨天 \(timeCom.hour):\(timeCom.minute)"
                    }else {
                        if (nowCom.day - timeCom.day) > 0 {
                            return "\(nowCom.day - timeCom.day)天前"
                        }
                    }
                }
                return da!.convertToString("dd日HH:mm")
            }else {
                if (nowCom.month - timeCom.month) > 0 {
                    return "\(nowCom.month - timeCom.month)月前"
                }
                return da!.convertToString("MM月dd日")
            }
            
        }else{
            return da!.convertToString("yyyy年MM月dd日")
        }
    }


}