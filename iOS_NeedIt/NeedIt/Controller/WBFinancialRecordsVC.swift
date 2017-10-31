//
//  WBFinancialRecordsVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBFinancialRecordsVC: WBBaseTableViewController {
    private var curIndexPage: Int = 1
    private var recordBeanList = [WBFinancialRecordBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewUI()
        
        requestListContent()        
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

extension WBFinancialRecordsVC {
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
        return recordBeanList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idtWBFinancialRecordsTBCell", forIndexPath: indexPath) as! WBFinancialRecordsTBCell
        let bean = recordBeanList[indexPath.row]
        cell.configureCell(bean)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 54
        }
        return 50
    }
    
}

// MARK: - Private Action
extension WBFinancialRecordsVC {
    func initViewUI() {
        navigationItem.title = "财务记录"
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBFinancialRecordsVC.onBackNavAction))

        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.requestListContent()
            })
        
//        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self]  () -> Void in
//            
//            var needPage = self!.curIndexPage
//            let endDataID = ""
//            
//            if self!.recordBeanList.count > 0{
//                needPage = self!.curIndexPage + 1
//                //endDataID = (self!._messageBeanList.last)!.dataId
//            }
//            self!.requestListContent(needPage, dataId: endDataID)
//            
//            })
        
        //view.addSubview(baseLoadingView)
        //baseLoadingView.showLoading("", target: self, select: #selector(WBFinancialRecordsVC.onClickNetError))
        (tableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (tableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
//        (tableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.textColor = WBMJHeaderColor
        tableView.tableFooterView = UIView()
    }
    
    func onClickNetError() {
        //baseLoadingView.showLoading("", target: self, select: #selector(WBFinancialRecordsVC.onClickNetError))
        requestListContent()
    }
    
}

extension WBFinancialRecordsVC {
    private func requestListContent(pageIndex: NSInteger = 1,dataId: String = "") {
        let urlStr = WBNetManager.sharedInstance.getFinancialDetailURL(pageIndex, dataId: dataId)
        print("财务列表:\(urlStr)")
        let token = WBUserManager.sharedInstance.appLocalToken()
        //let token = "1581132815511111458563578"
        let dicPost = NSDictionary(objects: [token], forKeys: ["token"] )
        WBNetManager.sharedInstance.requestByPost(urlStr, params: (dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) in
            let retoBJ = WBParseNetBase(json: json)
            
            if isSuccess {
                var numRec = 0
                if retoBJ.isDataOk() {
                    if 1 == pageIndex {
                        self.recordBeanList.removeAll()
                        self.tableView.reloadData()
                    }
                    if retoBJ.data.isKindOfClass(NSNull){
                        SVProgressHUD.showSuccessWithStatus((1==pageIndex) ? "暂无记录~" : "暂无更多记录~" )
                    }else{
                        let retArr = retoBJ.data as! NSArray
                        numRec = retArr.count
                        if numRec > 0 {
                            self.curIndexPage = pageIndex
                            for obj in retArr {
                                self.recordBeanList.append(WBFinancialRecordBean(json: JSON(obj)) )
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
                
                if self.tableView.mj_header.isRefreshing() {
                    self.tableView.mj_header.endRefreshing()
//                    self.tableView.mj_footer.resetNoMoreData()
//                }else if self.tableView.mj_footer.isRefreshing() {
//                    self.tableView.mj_footer.endRefreshing()
                    
                }
                
                //if self.recordBeanList.count > 0 {
                //    self.baseLoadingView.finishLoading()
                //}else{
                //    self.baseLoadingView.showError("暂无消息~")
                //}
                
//                if CS_NET_PAGE_COUNT == numRec {
//                    self.tableView.mj_footer.hidden = false
//                }
//                else{
//                    self.tableView.mj_footer.hidden = true
//                }
                return
            }
            if isFailure {
                if self.tableView.mj_header.isRefreshing() {
                    self.tableView.mj_header.endRefreshing()
//                }else if self.tableView.mj_footer.isRefreshing() {
//                    self.tableView.mj_footer.endRefreshing()
                }
                //self.baseLoadingView.showError("您当前网络有问题,请点击刷新~")
                
            }
            SVProgressHUD.showSuccessWithStatus(retoBJ.msg ?? "网络错误!" )
        }
        
    }
    
}

