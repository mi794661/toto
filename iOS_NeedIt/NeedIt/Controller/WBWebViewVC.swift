//
//  WBWebViewVC.swift
//  NeedIt
//
//  Created by Think on 16/3/31.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

typealias callBackWBWebViewVCClose = (isCloseVC: Bool) -> Void

class WBWebViewVC: WBBaseViewController {
    var retCloseClosure:callBackWBWebViewVCClose?
    func initWithClosureRegister(closure:callBackWBWebViewVCClose?){
        retCloseClosure = closure
    }
    
    var urlStr: String = ""
    var titleStr: String = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = titleStr.isEmpty ? "需要么" : titleStr
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBRegisterVC.onBackNavAction))
        webView.dataDetectorTypes = .All
        webView.loadRequest(NSURLRequest(URL: NSURL(string: urlStr)! ) )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onBackNavAction() {
        guard let _ = retCloseClosure else {
            if navigationController?.viewControllers.count > 1 {
                navigationController?.popViewControllerAnimated(true)
            }else{
                dismissViewControllerAnimated(true, completion: { () -> Void in
                })
            }
            return
        }
        retCloseClosure?(isCloseVC:true)
        if navigationController?.viewControllers.count > 1 {
            navigationController?.popViewControllerAnimated(true)
        }else{
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }

    }
    
}
