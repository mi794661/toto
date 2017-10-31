//
//  WBOrderPaySuccessVC.swift
//  NeedIt
//
//  Created by Think on 16/3/21.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

typealias callBackOrderPaySuccessVC = (isCheckPayOrder: Int) -> Void

class WBOrderPaySuccessVC: WBBaseViewController {
    private var retPaySuccessClosure:callBackOrderPaySuccessVC?
    private var tradeOrderBean: WBTradeOrderBean?
    private var activityBean: WBActivityInfoBean?
    private var orderInfoBean: WBOrderInfoBean?
    
    private var activityDataId:String!
    private var tradeCodeId:String!
    
    func initWithClosureOrderPaySuccess(bean:WBTradeOrderBean,beanActivity:WBActivityInfoBean,closure:callBackOrderPaySuccessVC?){
        retPaySuccessClosure = closure
        tradeOrderBean = bean;
        activityBean = beanActivity
        
        activityDataId = beanActivity.dataId
        tradeCodeId = bean.tradeCode
    }

    func initWithClosureOrderPaySuccess(bean:WBOrderInfoBean,closure:callBackOrderPaySuccessVC?){
        retPaySuccessClosure = closure
        orderInfoBean = bean;
        
        activityDataId = bean.dataId
        tradeCodeId = bean.tradeCode
    }
    
    @IBOutlet weak var payStatusButton: UIButton!
    
    @IBAction func clickReviewOrderDetailButton(sender: AnyObject) {
        self.retPaySuccessClosure?(isCheckPayOrder:1)
        dismissViewControllerAnimated(false, completion: { () -> Void in
            (UIApplication.sharedApplication().keyWindow?.rootViewController as! WBMainTabBarController).gotoActivityDetail(self.activityDataId)
        })
    }
    
    @IBAction func clickCchekRebateButtonButton(sender: AnyObject) {
        self.retPaySuccessClosure?(isCheckPayOrder:0)
        dismissViewControllerAnimated(false, completion: { () -> Void in
            (UIApplication.sharedApplication().keyWindow?.rootViewController as! WBMainTabBarController).gotoRebateVC(self.tradeCodeId)
        })
    }
    
    @IBOutlet weak var checkRebateButton: UIButton!
    @IBOutlet weak var reviewOrderDetailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "付款成功"
        checkRebateButton.layer.cornerRadius = 2
        reviewOrderDetailButton.layer.cornerRadius = 2
        payStatusButton.layer.cornerRadius = payStatusButton.bounds.width/2
        payStatusButton.layer.masksToBounds = true
        
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBOrderPaySuccessVC.onBackNavAction))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onBackNavAction() {
        self.retPaySuccessClosure?(isCheckPayOrder:-1)
        dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
}
