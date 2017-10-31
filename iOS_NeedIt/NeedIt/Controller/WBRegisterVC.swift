//
//  WBRegisterVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

typealias callBackRegisterVCRigistSuccessed = (isRegisted: Bool) -> Void
typealias callBackRegisterVCForgetPwdSuccessed = (isLogined: Bool) -> Void

class WBRegisterVC: WBBaseTableViewController {
    private var titleText: String = ""
    private var textField: UITextField? = nil
    
    var textPhone:String = ""
    var textCode:String = ""
    var textPwd:String = ""
    
    var retRegisterClosure:callBackRegisterVCRigistSuccessed?
    func initWithClosureRegister(closure:callBackRegisterVCRigistSuccessed?){
        retRegisterClosure = closure
        titleText = "注册"
    }
    
    var retForgetPwdClosure:callBackRegisterVCForgetPwdSuccessed?
    func initWithClosureForgetPwd(closure:callBackRegisterVCForgetPwdSuccessed?){
        retForgetPwdClosure = closure
        titleText = "忘记密码"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = titleText
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBRegisterVC.onBackNavAction))
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
    
}

extension WBRegisterVC {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if 0 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBRegisterNameInputTBCell", forIndexPath: indexPath) as! WBRegisterNameInputTBCell
            cell.selectionStyle = .None
            cell.nameInputTextView.tag = 1001
            cell.nameInputTextView.delegate = self
            return cell
        }
        if 1 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBRegisterCodeInputTBCell", forIndexPath: indexPath) as! WBRegisterCodeInputTBCell
            cell.selectionStyle = .None
            cell.nameInputTextView.tag = 1002
            cell.nameInputTextView.delegate = self
            cell.callFunc = { [unowned self] () in
                self.onClickRequestCode(cell.requestCode)
            }
            return cell
        }
        if 2 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBRegisterPwdTBCell", forIndexPath: indexPath) as! WBRegisterPwdTBCell
            cell.selectionStyle = .None
            cell.nameInputTextView.delegate = self
            cell.nameInputTextView.tag = 1003
            return cell
        }
        if 3 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBRegisterNowTBCell", forIndexPath: indexPath) as! WBRegisterNowTBCell
            cell.selectionStyle = .None
            cell.signInButton.removeTarget(self, action: #selector(WBRegisterVC.onClickSignInButton(_:)), forControlEvents: .TouchUpInside)
            cell.signInButton.addTarget(self, action: #selector(WBRegisterVC.onClickSignInButton(_:)), forControlEvents: .TouchUpInside)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("idtWBRegisterProtocolTBCell", forIndexPath: indexPath) as! WBRegisterProtocolTBCell
        cell.selectionStyle = .None
        cell.protocolButton.removeTarget(self, action: #selector(WBRegisterVC.onClickProtocolButton(_:)), forControlEvents: .TouchUpInside)
        cell.protocolButton.addTarget(self, action: #selector(WBRegisterVC.onClickProtocolButton(_:)), forControlEvents: .TouchUpInside)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if 0 == indexPath.row {
            return 70
        }
        if 1 == indexPath.row {
            return 64
        }
        if 2 == indexPath.row {
            return 60
        }
        if 3 == indexPath.row {
            return 72
        }
        return 44
    }
    
    func onClickRequestCode(sender: UIButton) {
        hideKeyboard()
        if CSCommonUtils.verifyPhoneNumber(textPhone) {
            requestVerifyCodeContent()
        }else{
            SVProgressHUD.showErrorWithStatus("请输入正确手机号！")
        }
    }
    
    func onClickSignInButton(sender: UIButton) {
        hideKeyboard()
        if CSCommonUtils.verifyPhoneNumber(textPhone) {
            
            if !textCode.isEmpty {
                
                if !textPwd.isEmpty {
                    requestRegisterContent()
                    return
                }else{
                    SVProgressHUD.showErrorWithStatus("请输入密码！")
                }
                
            }else{
                SVProgressHUD.showErrorWithStatus("请输入验证码！")
            }
            
        }else{
            SVProgressHUD.showErrorWithStatus("请输入正确手机号！")
        }
    }
    
    func onClickProtocolButton(sender: UIButton) {
        let vc = CSUIUtils.vcOfCommon("idtWBWebViewVC") as! WBWebViewVC
        vc.urlStr = WBNetManager.sharedInstance.getAppProtocolURL()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WBRegisterVC : UITextFieldDelegate,UIGestureRecognizerDelegate {
    @IBAction func onTapAction(sender: AnyObject) {
        hideKeyboard()
    }
    
    private func requestVerifyCodeContent() {
        let urlStr = WBNetManager.sharedInstance.getSignVerifyURL()
        print("发送验证码:\(urlStr)")
        
        let dicPost = NSDictionary(objects: [textPhone], forKeys: ["phone"])
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            let lBean = WBLoginInfoBean(json: json)
            if isSuccess {
                if 1 == lBean.status {//1=成功
                    print("当前登录 成功:\(lBean.token)")
                    return
                }
            }
            if isFailure {
            }
            let msg = lBean.errMsg.isEmpty ? "网络失败~" : lBean.errMsg
            SVProgressHUD.showErrorWithStatus(msg)
        }
    }
    
    private func requestRegisterContent() {
        SVProgressHUD.showWithStatus("正在注册...")
        let urlStr = WBNetManager.sharedInstance.getSignUpURL()
        print("用户注册:\(urlStr)")
        let dicPost = NSDictionary(objects: [textPhone,textPwd.MD5,textCode], forKeys: ["phone","pwd","verify"])
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            
                        
            let lBean = WBLoginInfoBean(json: json)
            if isSuccess {
                if 1 == lBean.status {
                    print("当前注册 成功:\(lBean.token)")
                    WBUserManager.sharedInstance.doUserLogIn(lBean.token, phone: self.textPhone)
                    self.retRegisterClosure?(isRegisted:true)
                    SVProgressHUD.dismiss()
                    return
                }
            }
            if isFailure {
            }
            SVProgressHUD.showErrorWithStatus(lBean.errMsg ?? "网络错误~")
            SVProgressHUD.dismissWithDelay(2.0)
        }
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
            self.textPhone = textField.text!
            break
        case 1002:
            self.textCode = textField.text!
            break
        case 1003:
            self.textPwd = textField.text!
            break
        default:
            break;
        }
        print("当前:\(self.textPhone):\(self.textCode):\(self.textPwd)")
        self.textField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



