//
//  CSAppConst.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import Foundation

let WBThemeColor = UIColor.colorWithHexRGB(0x02ACCE)
let WBRedColor = UIColor.colorWithHexRGB(0xE95200)
let WBGreenColor = UIColor.colorWithHexRGB(0x6FBE4D)
let WBViewColor = UIColor.colorWithHexRGB(0xE2E2E3)

let WBMJHeaderColor = UIColor.colorWithHexRGB(0xCCCCCC)

/// 后台字段解析
let CS_RESPONSE_CODE  = "status"
let CS_RESPONSE_MSG   = "msg"
let CS_RESPONSE_DATA  = "data"
let CS_RESPONSE_TOKEN = "token"

let CS_NET_RESPONSE_SUCCESSED = 1  //1表示成功
let CS_NET_PAGE_COUNT = 10         //每页10条

let CS_REQUEST_PAGE      = "page"
let CS_REQUEST_END_ID    = "end_id"
let CS_REQUEST_PRODUCTID = "id"

let CS_REQUEST_BASEURL = "http://114.55.29.49"

typealias netResponseCallFunc = (isSuccess: Bool, isFailure: Bool, json: JSON, error: NSError?) -> Void
typealias responseJsonCallFunc = (isSuccess: Bool, jsonObj: JSON) -> Void


//App-info.plist wx460c5edceb33873c
let WB_WeiXinKey = "wx460c5edceb33873c"
let WB_AppName = "智慧宝盒科技有限公司"
