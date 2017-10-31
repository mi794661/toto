//
//  WBSubmitOrderVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

typealias callBackSubmitOrderVC = (isPurchase: Bool) -> Void

class WBSubmitOrderVC: WBBaseTableViewController {
    private var retPurchaseClosure:callBackSubmitOrderVC?
    func initWithClosureShop(bean:WBActivityInfoBean, closure:callBackSubmitOrderVC?){
        retPurchaseClosure = closure
        acvityBean = bean;
        isPhoneOrder = ("1" as NSString).isEqualToString(acvityBean!.dealType)
    }
    
    private var isPhoneOrder = true
    private var numCountProduct = 1
    private var acvityBean: WBActivityInfoBean?
    private var userBean: WBUserInfoBean = WBUserInfoBean()
    private var textField: UITextField? = nil
    private var tardeBean: WBTradeOrderBean?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewUI()
        
        userBean.userPhone = WBUserManager.sharedInstance.appUserPhone()
        userBean.userToken = WBUserManager.sharedInstance.appLocalToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension WBSubmitOrderVC {
    private func requestSubmintOrderContent() {
        let urlStr = WBNetManager.sharedInstance.getMakeOrderURL()
        print("提交订单:\(urlStr)")
        //token 令牌 登录或者注册成功时返回的
        //pid 商品ID
        //name 用户姓名 可以为空
        //address 用户地址 可以为空
        //phone 用户电话
        //count 商品数量 暂时固定传值count=1
        let token = userBean.userToken
        let phone = userBean.userPhone
        let name = userBean.userName
        let address = userBean.userAddress
        let pid = acvityBean!.dataId
        
        let dicPost = NSMutableDictionary()
        dicPost.setObject(token, forKey: "token")
        dicPost.setObject(phone, forKey: "phone")
        dicPost.setObject(name, forKey: "name")
        dicPost.setObject(address, forKey: "address")
        
        dicPost.setObject(pid, forKey: "pid")
        dicPost.setObject("1", forKey: "count")
        SVProgressHUD.showWithStatus("正在处理....")
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            
            let tradeBean = WBTradeOrderBean(json: json)
            if isSuccess {
                SVProgressHUD.dismiss()
                
                tradeBean.allMoney = self.acvityBean!.price
                tradeBean.num = 1
                    
                self.tardeBean = tradeBean
                let vc = CSUIUtils.vcOfCommon("idtWBPayOrderVC") as! WBPayOrderVC
                vc.initWithClosurePay(self.tardeBean!, beanActivity: self.acvityBean!, closure: { (isPaied) in
                    if (isPaied) {
                    }
                })
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            if isFailure {
            }
            SVProgressHUD.showErrorWithStatus(tradeBean.msg ?? "网络错误~")
            SVProgressHUD.dismissWithDelay(2.0)

            
        }
    }
}

// MARK: - Table view data source
extension WBSubmitOrderVC {
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
        guard let _ = acvityBean else{
            return 0
        }
        return 3
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (0 == section) {
            let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(12)]
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let size = CGSizeMake(UIScreen.mainScreen().bounds.width - 20,CGFloat(MAXFLOAT))
            let strToShow:NSString = "\(acvityBean!.name)"
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
            let strToShow:NSString = "\(acvityBean!.name)"
            lb.text = strToShow as String
            
            let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(12)]
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let size = CGSizeMake(UIScreen.mainScreen().bounds.width - 20,CGFloat(MAXFLOAT))
            let rect = strToShow.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
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
        if isPhoneOrder {
            switch(section){
            case 0:return 2
            case 1:return 1
            case 2:return 1
            default:return 0
            }
        }
        switch(section){
        case 0:return 2
        case 1:return 3
        case 2:return 1
        default:return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if 0 == indexPath.section {
            if (0 == indexPath.row){
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSubmitOrderNumberTBCell", forIndexPath: indexPath) as! WBSubmitOrderNumberTBCell
                cell.selectionStyle = .None
                cell.reduceButton.removeTarget(self, action: #selector(WBSubmitOrderVC.onClickReduceButtonAction(_:)), forControlEvents: .TouchUpInside)
                cell.reduceButton.addTarget(self, action: #selector(WBSubmitOrderVC.onClickReduceButtonAction(_:)), forControlEvents: .TouchUpInside)
                cell.plusButton.removeTarget(self, action: #selector(WBSubmitOrderVC.onClickPlusButtonAction(_:)), forControlEvents: .TouchUpInside)
                cell.plusButton.addTarget(self, action: #selector(WBSubmitOrderVC.onClickPlusButtonAction(_:)), forControlEvents: .TouchUpInside)
                
                cell.titleNameLable.text = "数量"
                cell.textFieldView.text = "1"
                
                cell.textFieldView.userInteractionEnabled = false
                return cell
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSubmitOrderTextInputTBCell", forIndexPath: indexPath) as! WBSubmitOrderTextInputTBCell
            cell.selectionStyle = .None
            cell.textFieldView.userInteractionEnabled = false
            cell.titleNameLable.text = "小记"
            cell.textFieldView.text = "￥\(acvityBean!.price)"
            return cell
        }
        if isPhoneOrder {
            switch(indexPath.section){
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSubmitOrderTextInputTBCell", forIndexPath: indexPath) as! WBSubmitOrderTextInputTBCell
                cell.selectionStyle = .None
                //cell.textFieldView.delegate = self
                cell.titleNameLable.text = "电话"
                cell.textFieldView.text = userBean.userPhone
                return cell
                
            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSubmitOrderSubmitTBCell", forIndexPath: indexPath) as! WBSubmitOrderSubmitTBCell
                cell.selectionStyle = .None
                cell.submitButton.removeTarget(self, action: #selector(WBSubmitOrderVC.onClickSubmitButtonAction(_:)), forControlEvents: .TouchUpInside)
                cell.submitButton.addTarget(self, action: #selector(WBSubmitOrderVC.onClickSubmitButtonAction(_:)), forControlEvents: .TouchUpInside)
                return cell
                
            default:
                return UITableViewCell()
            }
        }
        switch(indexPath.section){
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSubmitOrderTextInputTBCell", forIndexPath: indexPath) as! WBSubmitOrderTextInputTBCell
            cell.selectionStyle = .None
            cell.textFieldView.delegate = self
            cell.textFieldView.tag = 1001 + indexPath.row
            var  strName = ""
            var  strValue = ""
            
            switch indexPath.row {
            case 0:
                strName = "收货人姓名"
                strValue = userBean.userName
                break;
            case 1:
                strName = "地址"
                strValue = userBean.userName
                break;
            case 2:
                strName = "电话"
                strValue = userBean.userPhone
                break;
                
            default:
                break
            }
            cell.titleNameLable.text = strName
            cell.textFieldView.text = strValue
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSubmitOrderSubmitTBCell", forIndexPath: indexPath) as! WBSubmitOrderSubmitTBCell
            cell.selectionStyle = .None
            cell.submitButton.removeTarget(self, action: #selector(WBSubmitOrderVC.onClickSubmitButtonAction(_:)), forControlEvents: .TouchUpInside)
            cell.submitButton.addTarget(self, action: #selector(WBSubmitOrderVC.onClickSubmitButtonAction(_:)), forControlEvents: .TouchUpInside)
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
    }
    
    func onClickSubmitButtonAction(sender: UIButton) {
        hideKeyboard()
        if !isPhoneOrder {
            if userBean.userName.isEmpty {
                SVProgressHUD.showErrorWithStatus("请填写收件人~")
                return
            }
            if userBean.userAddress.isEmpty {
                SVProgressHUD.showErrorWithStatus("请填写地址~")
                return
            }
        }
        
        print("提交订单...:\(userBean.userToken):\(userBean.userName):\(userBean.userPhone):\(userBean.userAddress):\(acvityBean!.price):\(acvityBean!.dataId)")
        requestSubmintOrderContent()
    }
    
    func onClickReduceButtonAction(sender: UIButton) {
        print("减少...")
    }
    
    func onClickPlusButtonAction(sender: UIButton) {
        print("增加...")
    }
    
}

// MARK: - Private Action
extension WBSubmitOrderVC: UITextFieldDelegate {
    func onBackNavAction() {
        if navigationController?.viewControllers.count > 1 {
            navigationController?.popViewControllerAnimated(true)
        }else{
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }
    
    func initViewUI() {
        navigationItem.title = "提交订单"
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBSubmitOrderVC.onBackNavAction))
        tableView.tableFooterView = UIView()
    }
    
    func onClickNetError() {
    }
    
    @IBAction func onTapAction(sender: AnyObject) {
        hideKeyboard()
    }
    // MARK: private method
    private func hideKeyboard() {
        textField?.resignFirstResponder()
    }
    
    // MARK: gesture delegate
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return textField != nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.textField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case 1001:
            self.userBean.userName = textField.text!
            break
        case 1002:
            self.userBean.userAddress = textField.text!
            break
        case 1002:
            self.userBean.userPhone = textField.text!
            break
        default:
            break;
        }
        self.textField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

