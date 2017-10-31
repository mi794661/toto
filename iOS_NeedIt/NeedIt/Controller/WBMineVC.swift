//
//  WBMineVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBMineVC: WBBaseViewController {
    
    @IBOutlet weak var userNameLable: UILabel!
    @IBOutlet weak var logoImageButton: UIButton!
    @IBOutlet weak var exitLoginButton: UIButton!
    
    @IBOutlet weak var scanView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewUI()
        updateUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickOrderListButton(sender: AnyObject) {
        if WBUserManager.sharedInstance.isUserLogined() {
            let vc = CSUIUtils.vcOfCommon("idtWBOrderListVC")
            let nav = WBBaseNavigationController(rootViewController: vc)
            self.presentViewController(nav, animated: true) { () -> Void in
            }
        }else{
            gotoLogin()
        }
        
    }
    
    @IBAction func clickMoneyButton(sender: AnyObject) {
        if WBUserManager.sharedInstance.isUserLogined() {
            let vc = CSUIUtils.vcOfCommon("idtWBMyWalletVC")
            let nav = WBBaseNavigationController(rootViewController: vc)
            self.presentViewController(nav, animated: true) { () -> Void in
            }
        }else{
            gotoLogin()
        }
    }
    
    @IBAction func clickMakeDearButton(sender: AnyObject) {
        if WBUserManager.sharedInstance.isUserLogined() {
            let vc = CSUIUtils.vcOfCommon("idtWBScanQRCodeVC") as! WBScanQRCodeVC
            let nav = WBBaseNavigationController(rootViewController: vc)
            self.presentViewController(nav, animated: true) { () -> Void in
            }
            updateUI()
        }else{
            gotoLogin()
        }
    }
    
    @IBAction func clickLoginInOutButtonButton(sender: AnyObject) {
        if WBUserManager.sharedInstance.isUserLogined() {
            WBUserManager.sharedInstance.doUserLogOut()
            updateUI()
        }else{
            gotoLogin()
        }
    }
    
    private func gotoLogin(){
        let vc = CSUIUtils.vcOfCommon("idtWBSignInVC") as! WBSignInVC
        vc.retLoginClosure = { [unowned self](isLogined: Bool) in
            if isLogined {
                self.updateUI()
            }
            return
        }
        let nav = WBBaseNavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: {
        })
    }
}

extension WBMineVC {
    func initViewUI() {
        logoImageButton.layer.cornerRadius = logoImageButton.bounds.size.width/2
        logoImageButton.layer.masksToBounds = true
        logoImageButton.backgroundColor = UIColor.clearColor()
        logoImageButton.setImage(UIImage(named:"user_default_head"), forState: .Normal)
        exitLoginButton.layer.cornerRadius = 5
    }
    
    func updateUI() {
        userNameLable.text = WBUserManager.sharedInstance.appUserPhone().isEmpty ? "暂无登录..." : WBUserManager.sharedInstance.appUserPhone()
        
        print("当前:\(WBUserManager.sharedInstance.isUserLogined())")
        exitLoginButton.setTitle(WBUserManager.sharedInstance.isUserLogined() ? "退出登录" : "登录" , forState: .Normal)
    }
    
}
