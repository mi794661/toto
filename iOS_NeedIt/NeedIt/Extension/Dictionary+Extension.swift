//
//  Dictionary+Extension.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import Foundation

extension Dictionary {
    func stringForKey(key: Key) -> String {
        return self.stringForKey(key, dlftValue: "")
    }
    
    func stringForKey(key: Key, dlftValue: String) -> String {
        if let value = self[key] as? String {
            return value
        }
        
        if let value = self[key] as? NSNumber {
            return value.stringValue
        }
        
        if let value = self[key] as? NSData {
            if let result = NSString(data: value, encoding: NSUTF8StringEncoding) as? String {
                return result
            }
        }
        
        return dlftValue
    }
    
    func integerForKey(key: Key) -> Int {
        return self.integerForKey(key, dlftValue: 0)
    }
    
    func integerForKey(key: Key, dlftValue: Int) -> Int {
        if let value = self[key] as? NSNumber {
            return value.integerValue
        }
        
        if let value = self[key] as? NSString {
            return value.integerValue
        }
        
        return dlftValue
    }
    
    func doubleForKey(key: Key) -> Double {
        return self.doubleForKey(key, dlftValue: 0.0)
    }
    
    func doubleForKey(key: Key, dlftValue: Double) -> Double {
        if let value = self[key] as? NSNumber {
            return value.doubleValue
        }
        
        if let value = self[key] as? NSString {
            return value.doubleValue
        }
        
        return dlftValue
    }
    
    func dictionaryForKey(key: Key) -> Dictionary<String, AnyObject> {
        if let value = self[key] as? Dictionary<String, AnyObject> {
            return value
        }
        
        return Dictionary<String, AnyObject>()
    }
}
