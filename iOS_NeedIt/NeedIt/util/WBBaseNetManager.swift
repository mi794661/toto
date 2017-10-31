//
//  WBBaseNetManager.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit
import Foundation

class WBBaseNetManager: NSObject {
    let _manager: AFHTTPRequestOperationManager
    
    override init() {
        _manager = AFHTTPRequestOperationManager()
        super.init()
        
        _manager.responseSerializer = AFJSONResponseSerializer()
        _manager.responseSerializer.acceptableContentTypes = NSSet(array: ["application/json", "text/plain"]) as Set<NSObject>
    }
    
    func requestByGet(url: String, callFunc: netResponseCallFunc?) -> AFHTTPRequestOperation? {
        let getUrl = (url as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return _manager.GET(getUrl, parameters: nil, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
            
            let json = JSON(responseObject)
            if let call = callFunc {
                if json[CS_RESPONSE_CODE].exists() && json[CS_RESPONSE_CODE].intValue == CS_NET_RESPONSE_SUCCESSED {
                    call(isSuccess: true, isFailure: false, json: json, error: nil)
                } else {
                    call(isSuccess: false, isFailure: false, json: json, error: nil)
                }
            }
        }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
            if let call = callFunc {
                call(isSuccess: false, isFailure: true, json: JSON.null, error: error)
            }
        }
    }
    
    func requestByPost(url: String, params:String?, callFunc: netResponseCallFunc?) -> AFHTTPRequestOperation? {
        let postUrl = (url as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        print("postUrl \(postUrl)")
        return _manager.POST(postUrl, parameters: nil, constructingBodyWithBlock: { ( formData :AFMultipartFormData) -> Void in
           
            
            
            if ((params) != nil){
                formData.appendPartWithFormData(params!.dataUsingEncoding(NSUTF8StringEncoding)! , name: "project")
                print("project=\(params!)")
            }
            
            
            }, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                let json = JSON(responseObject)
                if let call = callFunc {
                    if json[CS_RESPONSE_CODE].exists() && json[CS_RESPONSE_CODE].intValue == CS_NET_RESPONSE_SUCCESSED {
                        call(isSuccess: true, isFailure: false, json: json, error: nil)
                    } else {
                        call(isSuccess: false, isFailure: false, json: json, error: nil)
                    }
                }
                
        }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
            if let call = callFunc {
                call(isSuccess: false, isFailure: true, json: JSON.null, error: error)
            }
        }
    }
    
    func requestByPostFile(url: String, params:[String: AnyObject]?, files:[String: String]?, callFunc: netResponseCallFunc?) -> AFHTTPRequestOperation? {
        let postUrl = (url as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return _manager.POST(postUrl, parameters: params, constructingBodyWithBlock: { (formData:AFMultipartFormData) -> Void in
            let filePath = files!["logo"]!
            let fileName = "logo.png"
            /**
             *  appendPartWithFileURL   //  指定上传的文件
             *  name                    //  指定在服务器中获取对应文件或文本时的key
             *  fileName                //  指定上传文件的原始文件名
             *  mimeType                //  指定商家文件的MIME类型
             */
            do {
                try formData.appendPartWithFileURL(NSURL(fileURLWithPath: filePath), name: "logo", fileName: fileName, mimeType: "image/png")
            }catch{
                print(error)
            }
            
            
            }, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                
                let json = JSON(responseObject)
                if let call = callFunc {
                    if json[CS_RESPONSE_CODE].exists() && json[CS_RESPONSE_CODE].intValue == CS_NET_RESPONSE_SUCCESSED {
                        call(isSuccess: true, isFailure: false, json: json, error: nil)
                    } else {
                        call(isSuccess: false, isFailure: false, json: json, error: nil)
                    }
                }
                
        }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
            if let call = callFunc {
                call(isSuccess: false, isFailure: true, json: JSON.null, error: error)
            }
        }
        
    }
    
    func requestByPostFileForUploadImage(url: String, params:[String: AnyObject]?, files:[String: String]?, callFunc: netResponseCallFunc?) -> AFHTTPRequestOperation? {
        let postUrl = (url as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return _manager.POST(postUrl, parameters: params, constructingBodyWithBlock: { (formData:AFMultipartFormData) -> Void in
            let filePath = files!["img"]!
            let fileName = "img.png"
            /**
             *  appendPartWithFileURL   //  指定上传的文件
             *  name                    //  指定在服务器中获取对应文件或文本时的key
             *  fileName                //  指定上传文件的原始文件名
             *  mimeType                //  指定商家文件的MIME类型
             */
            do {
                try formData.appendPartWithFileURL(NSURL(fileURLWithPath: filePath), name: "img", fileName: fileName, mimeType: "image/png")
            }catch{
                print(error)
            }
            
            
            }, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                
                let json = JSON(responseObject)
                if let call = callFunc {
                    if json[CS_RESPONSE_CODE].exists() && json[CS_RESPONSE_CODE].intValue == CS_NET_RESPONSE_SUCCESSED {
                        call(isSuccess: true, isFailure: false, json: json, error: nil)
                    } else {
                        call(isSuccess: false, isFailure: false, json: json, error: nil)
                    }
                }
                
        }) { (operation:AFHTTPRequestOperation?, error:NSError!) -> Void in
            if let call = callFunc {
                call(isSuccess: false, isFailure: true, json: JSON.null, error: error)
            }
        }
        
    }
    
}

