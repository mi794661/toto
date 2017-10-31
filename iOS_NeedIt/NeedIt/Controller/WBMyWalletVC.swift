//
//  WBMyWalletVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBMyWalletVC: WBBaseTableViewController {
    private var textField: UITextField? = nil
    private var aliTextInfo: String = ""
    private var moneyTextInfo: String = ""
    
    private var totalMoney: WBMyTotalMoneyBean?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewUI()
        self.tableView.mj_header.beginRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onBackNavAction() {
        if navigationController?.viewControllers.count > 1 {
            navigationController?.popViewControllerAnimated(true)
        }else{
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }
    
    func onRightNavAction() {
        let vc = CSUIUtils.vcOfCommon("idtWBFinancialRecordsVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WBMyWalletVC {
    private func requestTotalMoneyContent() {
        let urlStr = WBNetManager.sharedInstance.getTotalMoneyURL()
        print("我的钱包——总金额:\(urlStr)")
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(object: token, forKey: "token")
        WBNetManager.sharedInstance.requestByPost(urlStr, params: (dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) in
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }
            
            if isSuccess {
                self.totalMoney = WBMyTotalMoneyBean(json: json)
                print("当前:\(self.totalMoney!.status) : \(self.totalMoney!.data)")
                self.tableView.reloadData()
                return
            }
            if isFailure {
                self.baseLoadingView.showError("您当前网络有问题,请点击刷新~")
            }
        }
        
    }
    
    private func requestDrawMoneyContent(monery: String,ali: String = "") {
        SVProgressHUD.showWithStatus("正在处理...")
        let urlStr = WBNetManager.sharedInstance.getDrawMoneyURL()
        print("我的钱包——提取现金:\(urlStr)")
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(objects: [token,monery,ali], forKeys: ["token","money","ali"] )
        WBNetManager.sharedInstance.requestByPost(urlStr, params: (dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) in
            SVProgressHUD.dismiss()
            
            let retoBJ = WBMyDrawMoneyBean(json: json)
            if isSuccess {
                print("当前:\(retoBJ.status) : \(retoBJ.msg)")
                self.baseLoadingView.finishLoading()
                
                self.tableView.mj_header.beginRefreshing()
                return
            }
            if isFailure {
            }
            //SVProgressHUD.showErrorWithStatus(retoBJ.msg ?? "网络错误~")
        }
        
    }
}


extension WBMyWalletVC {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if 0 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBMyWalletBriefTBCell", forIndexPath: indexPath) as! WBMyWalletBriefTBCell
            var infoText = ""
            guard let n = totalMoney else {
                cell.moneyLable.text = "未知"
                return cell
            }
            infoText = n.data
            cell.moneyLable.text = infoText
            return cell
        }
        if 1 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBMyWalletInputTBCell", forIndexPath: indexPath) as! WBMyWalletInputTBCell
            cell.titleLabel.text = "支付宝账号:"
            cell.textInputField.tag  = 1001
            cell.textInputField.placeholder = ""
            cell.textInputField.delegate = self
            return cell
        }
        if 2 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBMyWalletInputTBCell", forIndexPath: indexPath) as! WBMyWalletInputTBCell
            cell.titleLabel.text = "提现金额 :"
            cell.textInputField.tag  = 1002
            cell.textInputField.placeholder = ""//"最高一次可以提现1999元"
            cell.textInputField.delegate = self
            return cell
        }
        if 3 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBMyWalletCashTBCell", forIndexPath: indexPath) as! WBMyWalletCashTBCell
            cell.cashButton.removeTarget(self, action: #selector(WBMyWalletVC.onClickCashButtonAction(_:)), forControlEvents: .TouchUpInside)
            cell.cashButton.addTarget(self, action: #selector(WBMyWalletVC.onClickCashButtonAction(_:)), forControlEvents: .TouchUpInside)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("idtWBMyWalletProtocolTBCell", forIndexPath: indexPath) as! WBMyWalletProtocolTBCell
        cell.protocolButton.removeTarget(self, action: #selector(WBMyWalletVC.onClickProtocolButtonAction(_:)), forControlEvents: .TouchUpInside)
        cell.protocolButton.addTarget(self, action: #selector(WBMyWalletVC.onClickProtocolButtonAction(_:)), forControlEvents: .TouchUpInside)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if 0 == indexPath.row {
            return 160
        }
        if 1 == indexPath.row {
            return 64
        }
        if 2 == indexPath.row {
            return 64
        }
        if 3 == indexPath.row {
            return 72
        }
        return 44
    }
    
    func onClickProtocolButtonAction(sender: UIButton) {
        let vc = CSUIUtils.vcOfCommon("idtWBWebViewVC") as! WBWebViewVC
        vc.urlStr = WBNetManager.sharedInstance.getAppProtocolURL()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func onClickCashButtonAction(sender: UIButton) {
        if aliTextInfo.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入支付宝账号！")
        }else{
            if moneyTextInfo.isEmpty {
                SVProgressHUD.showErrorWithStatus("请输入合法的金额！")
                return
            }
            requestDrawMoneyContent(moneyTextInfo, ali: aliTextInfo)
        }
        
    }
    
}

extension WBMyWalletVC : UITextFieldDelegate {
    
    func initViewUI() {
        navigationItem.title = "我的钱包"
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBMyWalletVC.onBackNavAction))
        CSUIUtils.configNavRightBarButton("财务记录", target: self, selector:#selector(WBMyWalletVC.onRightNavAction))
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.requestTotalMoneyContent()
            })
        (self.tableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (tableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
        
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
            aliTextInfo = textField.text!
            break
        case 1002:
            moneyTextInfo = textField.text ?? ""
            if !moneyTextInfo.isEmpty {
                if moneyTextInfo == "." {
                    moneyTextInfo = ""
                } else {
                    // 以点开头
                    if let range = moneyTextInfo.rangeOfString(".") where range.endIndex  == moneyTextInfo.startIndex.advancedBy(1) {
                        moneyTextInfo = "0" + moneyTextInfo
                    }
                    
                    // 能找到小数点
                    if let rang = moneyTextInfo.rangeOfString(".") {
                        let tmp = moneyTextInfo.substringFromIndex(rang.endIndex)
                        for _ in 0 ..< (2 - tmp.characters.count) {
                            moneyTextInfo += "0"
                        }
                    } else {
                        moneyTextInfo += ".00"
                    }
                }
                textField.text = moneyTextInfo
            }
            
            break
        default:
            break;
        }
        print("当前:\(self.aliTextInfo):\(self.moneyTextInfo)")
        self.textField = nil
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if 1001 == textField.tag {
            return true
        }
        let text:NSMutableString = textField.text!.mutableCopy() as! NSMutableString
        text.replaceCharactersInRange(range, withString: string)
        let range = text.rangeOfString(".")
        if range.location != NSNotFound {
            let num = text.substringFromIndex(range.location + range.length) as NSString
            let dotRange = num.rangeOfString(".")
            if dotRange.location != NSNotFound {
                return false
            }
            return num.length <= 2
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}