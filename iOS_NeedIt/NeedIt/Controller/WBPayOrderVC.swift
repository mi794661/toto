//
//  WBPayOrderVC.swift
//  NeedIt
//
//  Created by Think on 16/3/9.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

// 支付

import UIKit

typealias callBackPayOrderVC = (isPaied: Bool) -> Void

class WBPayOrderVC: WBBaseTableViewController {
    private var tradeOrderBean: WBTradeOrderBean?
    private var activityBean: WBActivityInfoBean?
    
    private var orderInfoBean: WBOrderInfoBean?
    
    private var activityName: String = ""
    private var tradeDataId: String = ""
    
    private var productNum: String = "1"
    private var productAllMoney: String = ""
    
    private var retPayClosure:callBackPayOrderVC?
    func initWithClosurePay(bean:WBTradeOrderBean,beanActivity:WBActivityInfoBean,closure:callBackPayOrderVC?){
        retPayClosure = closure
        tradeOrderBean = bean;
        activityBean = beanActivity
        
        tradeDataId = tradeOrderBean!.tradeCode
        activityName = activityBean!.name
        productAllMoney = tradeOrderBean!.allMoney
    }
    
    func initWithClosurePayWithOrderInfo(bean:WBOrderInfoBean,closure:callBackPayOrderVC?){
        retPayClosure = closure
        orderInfoBean = bean
        
        tradeDataId = bean.tradeCode
        activityName = bean.name
        productAllMoney = bean.total
    }
    
    private var payType = 1 {
        didSet {
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
            if 1 == payType {
                guard let _ = payWechatBean else {
                    requestPayOrderDetailContent()
                    return
                }
            }
            
            if 2 == payType {
                guard let _ = payALiPayBean else {
                    requestPayOrderDetailContent()
                    return
                }
            }
        }
    }
    
    private var payWechatBean:WBPayWeChatBean?
    private var payALiPayBean: WBPayAliBean?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewUI()
        
        tableView.mj_header.beginRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension WBPayOrderVC {
    private func requestPayOrderDetailContent() {
        SVProgressHUD.showWithStatus("正在处理...")
        let urlStr = WBNetManager.sharedInstance.getPayOrderURL()
        print("支付订单:\(urlStr)")
        
        //token 令牌 登录或者注册成功时返回的
        //pay_type 支付类型 1=微信; 2=支付宝
        //trade_code 订单编号
        let token = WBUserManager.sharedInstance.appLocalToken()
        let payType = "\(self.payType)"
        let tradeCode = tradeDataId
        
        let dicPost = NSMutableDictionary()
        dicPost.setObject(token, forKey: "token")
        dicPost.setObject(payType, forKey: "pay_type")
        dicPost.setObject(tradeCode, forKey: "trade_code")
        
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            SVProgressHUD.dismiss()
            
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }
//   成功
            if isSuccess {
//                if 1 == self.payType {
//                    self.payWechatBean = WBPayWeChatBean(json: json)
//                    //print("\(self.doWeiXinPay())")
//                }else{
                    self.payALiPayBean = WBPayAliBean(json: json)
                    //print("\(self.doAliPay())")
//                }
                return
            }
            if isFailure {
            }
            
        }
        
    }
}

// MARK: - Table view data source
extension WBPayOrderVC {
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if 2 == indexPath.section {
            cell.separatorInset = UIEdgeInsetsMake(0, UIScreen.mainScreen().bounds.width, 0, 0)
            return
        }
        cell.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (0 == section) {
            let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(12)]
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let size = CGSizeMake(UIScreen.mainScreen().bounds.width - 20,CGFloat(MAXFLOAT))
            let strToShow:NSString = "\(activityName)"
            let rect = strToShow.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
            if rect.size.height > 38 {
                return rect.size.height + 1 + 8*2
            }
            return 38
            
        }
        return 18
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var h = 0;
        if (0 == section) {
            h = 38
        }else{
            h = 18
        }
        let retView = UIView(frame:CGRect(x: 0, y: 0, width: (Int)(UIScreen.mainScreen().bounds.size.width), height: h))
        if (0 == section){
            let lb = UILabel(frame: CGRect(x: 10, y: 0, width:(Int)(UIScreen.mainScreen().bounds.width - 20) , height: h))
            lb.font = UIFont.systemFontOfSize(12)
            lb.lineBreakMode = .ByWordWrapping
            lb.numberOfLines = 0
            lb.textColor = UIColor.colorWithHexRGB(0x565960)
            retView.backgroundColor = UIColor.colorWithHexRGB(0xE2E2E3)
            let strToShow:NSString = "\(activityName)"
            lb.text = strToShow as String
            
            let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(12)]
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let size = CGSizeMake(UIScreen.mainScreen().bounds.width - 20,CGFloat(MAXFLOAT))
            let rect = strToShow.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
            print("\(rect)")
            var f = lb.frame
            if rect.size.height > 38 {
                f.origin.y = 8
                f.size.height = rect.height + 1
            }else{
                f.origin.y = 0
                f.size.height = 38
            }
            lb.frame = f
            retView.addSubview(lb)
            
        }
        return retView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section){
        case 0:return 2
       
//        支付选项
        case 1:return 1
//        case 1:return 2

        case 2:return 1
        default:return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section){
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBPayOrderDescTBCell", forIndexPath: indexPath) as! WBPayOrderDescTBCell
            cell.selectionStyle = .None
            if 0 == indexPath.row {
                cell.titleNameLable.text = "数量"
                cell.valueDescLable.text = "\(productNum)"
            }else{
                cell.titleNameLable.text = "支付金额"
                cell.valueDescLable.text = "\(productAllMoney)"
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBPayOrderWayTBCell", forIndexPath: indexPath) as! WBPayOrderWayTBCell
            cell.selectionStyle = .None
            cell.chooseButton.tag = indexPath.row + 1
            cell.chooseButton.removeTarget(self, action: #selector(WBPayOrderVC.onClickPayWayButtonAction(_:)), forControlEvents: .TouchUpInside)
            cell.chooseButton.addTarget(self, action: #selector(WBPayOrderVC.onClickPayWayButtonAction(_:)), forControlEvents: .TouchUpInside)
//            if 0 == indexPath.row {
//                cell.payWayImageView.image = UIImage(named: "fk_main_wechat")
//                cell.payNameLable.text = "微信支付"
//                if 1 == payType {
//                    cell.chooseButton.setImage(UIImage(named: "dcwj_main_rb_click"), forState: .Normal)
//                }else{
//                    cell.chooseButton.setImage(UIImage(named: "dcwj_main_rb"), forState: .Normal)
//                }
//            }else{
                cell.payWayImageView.image = UIImage(named: "fk_main_zhifubao")
                cell.payNameLable.text = "支付宝支付"
                //if 1 == payType {
                //    cell.chooseButton.setImage(UIImage(named: "dcwj_main_rb"), forState: .Normal)
                //}else{
                    cell.chooseButton.setImage(UIImage(named: "dcwj_main_rb_click"), forState: .Normal)
                //}
//            }
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBPayOrderPayNowTBCell", forIndexPath: indexPath) as! WBPayOrderPayNowTBCell
            cell.selectionStyle = .None
            cell.payNowButton.removeTarget(self, action: #selector(WBPayOrderVC.onClickPayNowButtonAction(_:)), forControlEvents: .TouchUpInside)
            cell.payNowButton.addTarget(self, action: #selector(WBPayOrderVC.onClickPayNowButtonAction(_:)), forControlEvents: .TouchUpInside)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if 2 == indexPath.section {
            return 72
        }
        switch(indexPath.row){
        case 0:
            return 48
        case 1:
            return 48
        default:
            return 50
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if 1 == indexPath.section {
           payType = indexPath.row+1
        }
    }
    
//    调用支付方法
    func onClickPayNowButtonAction(sender: UIButton) {
//        if 1 == payType {
//            guard let _ = payWechatBean else {
//                requestPayOrderDetailContent()
//                return
//            }
//            doWeiXinPay()
//        }else{
            guard let _ = payALiPayBean else {
                requestPayOrderDetailContent()
                return
            }
            doAliPay()
        }
//    }
    
    func onClickPayWayButtonAction(sender: UIButton) {
        payType = sender.tag
    }
    
}

// MARK: - Private Action
extension WBPayOrderVC {
    func initViewUI() {
        navigationItem.title = "付款"
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBPayOrderVC.onBackNavAction))
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.requestPayOrderDetailContent()
            })
        (tableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (tableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
        tableView.tableFooterView = UIView()
    }
    
    func onBackNavAction() {
        if navigationController?.viewControllers.count > 1 {
            navigationController?.popViewControllerAnimated(true)
        }else{
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }
    
    func onClickNetError() {
    }
    
}

extension WBPayOrderVC: WXApiManagerDelegate {
    func gotoSuccessPayedVC() {
        let vc = CSUIUtils.vcOfCommon("idtWBOrderPaySuccessVC") as! WBOrderPaySuccessVC
        guard let _ = orderInfoBean else {
            vc.initWithClosureOrderPaySuccess(tradeOrderBean!, beanActivity: activityBean!) { (isCheckPayOrder) in
                if -1 == isCheckPayOrder {
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        vc.initWithClosureOrderPaySuccess(orderInfoBean!, closure: { (isCheckPayOrder) in
            if -1 == isCheckPayOrder {
            }
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func managerDidRecvPayResponse(response: PayResp!) {
        switch (response.errCode) {
        case WXSuccess.rawValue:
            gotoSuccessPayedVC()
            break;
            
        default:
            SVProgressHUD.showErrorWithStatus("\(response.errStr)")
            break;
        }
    }
    
    func doWeiXinPay() -> Bool {
        WXApiManager.sharedManager().delegate = self
        //调起微信支付
        let req = PayReq()
        req.partnerId = payWechatBean!.partnerid
        req.prepayId = payWechatBean!.prepayid
        req.nonceStr = payWechatBean!.noncestr
        req.timeStamp = UInt32(payWechatBean!.timeStamp)!
        req.package = payWechatBean!.package
        req.sign = payWechatBean!.sign
        print("**\(UInt32(payWechatBean!.timeStamp)!)**")
        return WXApi.sendReq(req)
    }
    
    func doAliPay() {
        //应用注册scheme,在App-Info.plist定义URL types
        let appScheme = "cn.wisdombox.NeedIt"
        
        //将商品信息拼接成字符串
        let orderSpec = payALiPayBean!.str
        
        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
        let signedString = payALiPayBean!.sign
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        var orderString = "";
        if (signedString != nil) {
            orderString = NSString(format: "%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, "RSA") as String
            
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: {[weak self] ( resultDic : [NSObject : AnyObject]!) -> Void in
                print("reslut \(resultDic)")
                if (resultDic["resultStatus"] as! NSString).isEqualToString("9000") {
                    self!.gotoSuccessPayedVC()
                    return
                }
                SVProgressHUD.showErrorWithStatus("支付失败！")
                
            })
            
        }
        
    }
    
}
