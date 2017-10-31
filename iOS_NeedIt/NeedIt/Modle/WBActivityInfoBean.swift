//
//  WBActivityInfoBean.swift
//  NeedIt
//
//  Created by Think on 16/3/22.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

//deal_type=1，点击购买按钮时，跳转到只填写姓名电话的订单提交页。
//deal_type=2,跳转到需要填写地址的提交页
//orderStatus 0未付款，1付款成功，2完成交易
class WBActivityInfoBean: NSObject {
    var price: String!
    var surplus: String!
    var dataId: String!
    var toAccount: String!
    var dealType: String!
    var storage: String!
    var deal: String!
    var name: String!
    
    var info: [[String]]?
    
    var moreDetail: String!
    var img: String!
    
    var orderStatus: String!
    var oid: String!
    var tradeCode: String!
    

    init(json: JSON) {
        tradeCode = json["trade_code"].stringValue
        orderStatus = json["order_status"].stringValue
        oid = json["oid"].stringValue
        
        moreDetail = json["more_detail"].stringValue
        img = json["img"].stringValue
        
        price = json["price"].stringValue
        surplus = json["surplus"].stringValue
        dataId = json["id"].stringValue
        toAccount = json["to_account"].stringValue
        dealType = json["deal_type"].stringValue
        storage = json["storage"].stringValue
        deal = json["deal"].stringValue
        name = json["name"].stringValue

        info = []
        if let items = json["info"].array {
            for item in items {
                var tmpArr = [String]()
                for itemValue in item {
                    tmpArr.append("\(itemValue.1)")
                }
                info?.append(tmpArr)
            }
        } else {
            info = nil
        }

    }
    
}
