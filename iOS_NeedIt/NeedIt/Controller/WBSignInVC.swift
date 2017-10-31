//
//  WBSignInVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//
//  登录
import UIKit

typealias callBackSignInVCLoginSuccessed = (isLogined: Bool) -> Void

class WBSignInVC: WBBaseTableViewController {
    private var textField: UITextField? = nil
    
    var textPhone:String = ""
    var textPwd:String = ""
    
    var retLoginClosure:callBackSignInVCLoginSuccessed?
    func initWithClosureLogin(closure:callBackSignInVCLoginSuccessed?){
        retLoginClosure = closure
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "登录"
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBSignInVC.onBackNavAction))
        CSUIUtils.configNavRightBarButton("注册", target: self, selector:#selector(WBSignInVC.onRightNavAction))
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

extension WBSignInVC: UITextFieldDelegate,UIGestureRecognizerDelegate {
    @IBAction func onTapAction(sender: AnyObject) {
        hideKeyboard()
    }
    
    func onLoginAction(sender: UIButton) {
        hideKeyboard()
        if CSCommonUtils.verifyPhoneNumber(textPhone) {
            if !textPwd.isEmpty {
                requestUserLoginContent()
                return
            }
            SVProgressHUD.showErrorWithStatus("请输入密码！")
        }else{
            SVProgressHUD.showErrorWithStatus("请输入正确手机号！")
        }
        
    }
    
    func onRightNavAction() {
        let vc = CSUIUtils.vcOfCommon("idtWBRegisterVC") as! WBRegisterVC
        vc.initWithClosureRegister { (isRegisted) in
            if isRegisted {
                self.retLoginClosure?(isLogined: true)
                self.dismissViewControllerAnimated(true, completion: {
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func onForgetPwdAction(sender: UIButton) {
        let vc = CSUIUtils.vcOfCommon("idtWBRegisterVC") as! WBRegisterVC
        vc.initWithClosureForgetPwd { (isLogined) in
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func requestUserLoginContent() {
        let urlStr = WBNetManager.sharedInstance.getUserLoginURL()
        print("用户登录:\(urlStr)")
        
        SVProgressHUD.showWithStatus("正在登录...")
        let dicPost = NSDictionary(objects: [textPhone,textPwd.MD5], forKeys: ["phone","pwd"])
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            //SVProgressHUD.dismiss()
            
            let lBean = WBLoginInfoBean(json: json)
            if isSuccess {
                if 1 == lBean.status {//1=成功;
                    SVProgressHUD.showSuccessWithStatus("登录成功~")
                    SVProgressHUD.dismissWithDelay(2.0)

                    WBUserManager.sharedInstance.doUserLogIn(lBean.token, phone: self.textPhone)
                    print("当前登录 成功:\(lBean.token)")
                    self.retLoginClosure?(isLogined: true)
                    self.dismissViewControllerAnimated(true, completion: {
                    })
                    return
                }
                return
            }
            if isFailure {
            }
            SVProgressHUD.showErrorWithStatus(lBean.errMsg ?? "网络错误~")
            SVProgressHUD.dismissWithDelay(2.0)
            return
            /*
            if 2 == lBean.status {//2=密码错误;
                SVProgressHUD.showErrorWithStatus("密码错误~")
            }else if 3 == lBean.status {//3=号码还未注册
                SVProgressHUD.showErrorWithStatus("当前手机号暂未注册~")
            }//0=参数错误;
            else{
                SVProgressHUD.showErrorWithStatus(lBean.errMsg ?? "网络错误~")
            }
             */
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
            self.textPwd = textField.text!
            break
        default:
            break;
        }
        print("当前:\(self.textPhone):\(self.textPwd)")
        self.textField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension WBSignInVC {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if 0 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSignInNameInputTBCell", forIndexPath: indexPath) as! WBSignInNameInputTBCell
            cell.selectionStyle = .None
            cell.nameInputTextView.tag = 1001
            cell.nameInputTextView.delegate = self
            return cell
        }
        if 1 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSignInCodeInputTBCell", forIndexPath: indexPath) as! WBSignInCodeInputTBCell
            cell.selectionStyle = .None
            cell.codeInputTextView.tag = 1002
            cell.codeInputTextView.delegate = self
            return cell
        }
        if 2 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSignInLoginTBCell", forIndexPath: indexPath) as! WBSignInLoginTBCell
            cell.selectionStyle = .None
            cell.loginButton.removeTarget(self, action: #selector(WBSignInVC.onLoginAction(_:)), forControlEvents: .TouchUpInside)
            cell.loginButton.addTarget(self, action: #selector(WBSignInVC.onLoginAction(_:)), forControlEvents: .TouchUpInside)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSignInForgetPwdTBCell", forIndexPath: indexPath) as! WBSignInForgetPwdTBCell
        cell.selectionStyle = .None
        cell.forgetPwdButton.removeTarget(self, action: #selector(WBSignInVC.onForgetPwdAction(_:)), forControlEvents: .TouchUpInside)
        cell.forgetPwdButton.addTarget(self, action: #selector(WBSignInVC.onForgetPwdAction(_:)), forControlEvents: .TouchUpInside)
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
            return 72
        }
        return 0//44
    }
    
}