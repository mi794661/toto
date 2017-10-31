//
//  WBOrderListVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

//  订单列表

import UIKit

class WBOrderListVC: WBBaseTableViewController {
    private var curIndexPage: Int = 1
    private var orderBeanList = [WBOrderInfoBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewUI()
        
        tableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
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

extension WBOrderListVC {
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderBeanList.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if 0 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBOrderRecordBlankTBCell", forIndexPath: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("idtWBOrderRecordTBCell", forIndexPath: indexPath) as! WBOrderRecordTBCell
        cell.retButton.tag = indexPath.row - 1
        cell.retButton.removeTarget(self, action: #selector(WBOrderListVC.onClickRetButtonAction(_:)), forControlEvents: .TouchUpInside)
        cell.retButton.addTarget(self, action: #selector(WBOrderListVC.onClickRetButtonAction(_:)), forControlEvents: .TouchUpInside)
        let bean = orderBeanList[indexPath.row - 1]
        cell.configureCell(bean)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row > 0 {
            ////orderStatus 0未付款，1付款成功，2完成交易
            let bean = orderBeanList[indexPath.row - 1]
            if "2" == bean.status {
                gotoRebate(bean)
            }else if "1" == bean.status {
                gotoDetail(bean)
            }else {
                gotoPay(bean)
            }
        }
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 15
        }
        return 150
    }
    
    func onClickRetButtonAction(sender: UIButton) {
        let bean = orderBeanList[sender.tag]
        if "2" == bean.status {
            gotoRebate(bean)
        }else if "1" == bean.status {
            gotoDetail(bean)
        }else {
            gotoPay(bean)
        }
    }
    
    func gotoPay(bean:WBOrderInfoBean) {
        dismissViewControllerAnimated(false, completion: { () -> Void in
            (UIApplication.sharedApplication().keyWindow?.rootViewController as! WBMainTabBarController).gotoPay(bean)
        })
    }
    
    func gotoDetail(bean:WBOrderInfoBean) {
        dismissViewControllerAnimated(false, completion: { () -> Void in
            (UIApplication.sharedApplication().keyWindow?.rootViewController as! WBMainTabBarController).gotoActivityDetail(bean.dataId, bean: bean)
        })
    }
    
    func gotoRebate(bean:WBOrderInfoBean) {
        dismissViewControllerAnimated(false, completion: { () -> Void in
            (UIApplication.sharedApplication().keyWindow?.rootViewController as! WBMainTabBarController).gotoRebateVC(bean.tradeCode)
        })
    }

}

// MARK: - Private Action
extension WBOrderListVC {
    func initViewUI() {
        navigationItem.title = "订单列表"
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBOrderListVC.onBackNavAction))
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.requestListContent()
            })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self]  () -> Void in
            
            var needPage = self!.curIndexPage
            let endDataID = ""
            
            if self!.orderBeanList.count > 0{
                needPage = self!.curIndexPage + 1
                //endDataID = (self!._messageBeanList.last)!.dataId
            }
            self!.requestListContent(needPage, dataId: endDataID)
            
            })
        
        //view.addSubview(baseLoadingView)
        //baseLoadingView.showLoading("", target: self, select: #selector(WBOrderListVC.onClickNetError))
        (tableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (tableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
        (tableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.textColor = WBMJHeaderColor
        tableView.tableFooterView = UIView()
    }
    
    func onClickNetError() {
        //baseLoadingView.showLoading("", target: self, select: #selector(WBOrderListVC.onClickNetError))
        requestListContent()
    }
    
}

extension WBOrderListVC {
    private func requestListContent(pageIndex: NSInteger = 1,dataId: String = "") {
        let urlStr = WBNetManager.sharedInstance.getOrderListURL(pageIndex, dataId: dataId)
        print("订单列表:\(urlStr)")
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(object: token, forKey: "token")
        
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            let retoBJ = WBParseNetBase(json: json)
            
            if isSuccess {
                var numRec = 0
                if retoBJ.isDataOk() {
                    if 1 == pageIndex {
                        self.orderBeanList.removeAll()
                        self.tableView.reloadData()
                    }
                    
                    if retoBJ.data.isKindOfClass(NSNull){
                        SVProgressHUD.showSuccessWithStatus((1==pageIndex) ? "暂无订单~" : "暂无更多订单信息~" )
                    }else{
                        let retArr = retoBJ.data as! NSArray
                        numRec = retArr.count
                        if numRec > 0 {
                            self.curIndexPage = pageIndex
                            for obj in retArr {
                                self.orderBeanList.append(WBOrderInfoBean(json: JSON(obj)) )
                            }
                        }
                        self.tableView.reloadData()
                        
                    }
                    
                }
                
                if self.tableView.mj_header.isRefreshing() {
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.resetNoMoreData()
                    
                }else if self.tableView.mj_footer.isRefreshing() {
                    self.tableView.mj_footer.endRefreshing()
                    
                }
                
                //if self.orderBeanList.count > 0 {
                //    self.baseLoadingView.finishLoading()
                //}else{
                //    self.baseLoadingView.showError("暂无订单~")
                //}
                
                if CS_NET_PAGE_COUNT == numRec {
                    self.tableView.mj_footer.hidden = false
                }
                else{
                    self.tableView.mj_footer.hidden = true
                }
                return
            }
            if isFailure {
                if self.tableView.mj_header.isRefreshing() {
                    self.tableView.mj_header.endRefreshing()
                    
                }else if self.tableView.mj_footer.isRefreshing() {
                    self.tableView.mj_footer.endRefreshing()
                }
                //self.baseLoadingView.showError("您当前网络有问题,请点击刷新~")
            }
            SVProgressHUD.showSuccessWithStatus(retoBJ.msg ?? "网络错误!" )
            
        }
        
    }
    
}

