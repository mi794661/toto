//
//  WBMessageVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBMessageVC: WBBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var curIndexPage: Int = 1
    private var messageBeanList = [WBMessageBriefBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewUI()
        tableView.mj_header.beginRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension WBMessageVC {
    private func requestListContent(pageIndex: NSInteger = 1,dataId: String = "") {
        let urlStr = WBNetManager.sharedInstance.getNotificationListURL(pageIndex, dataId: dataId)
        print("消息列表:\(urlStr)")
        let token = WBUserManager.sharedInstance.appLocalToken()        
        let dicPost = NSDictionary(object: token, forKey: "token")
        WBNetManager.sharedInstance.requestByPost(urlStr, params: (dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) in
            if isSuccess {
                let retoBJ = WBParseNetBase(json: json)
                var numRec = 0
                if retoBJ.isDataOk() {
                    if self.tableView.mj_header.isRefreshing() {
                        self.tableView.mj_header.endRefreshing()
//                        self.tableView.mj_footer.resetNoMoreData()
//                    }else if self.tableView.mj_footer.isRefreshing() {
//                        self.tableView.mj_footer.endRefreshing()
                    }
                    
                    if 1 == pageIndex {
                        self.messageBeanList.removeAll()
                        self.tableView.reloadData()
                    }

                    if retoBJ.data.isKindOfClass(NSNull){
                        SVProgressHUD.showSuccessWithStatus((1==pageIndex) ? "暂无消息~" : "暂无更多消息~" )
                    }else{
                        let retArr = retoBJ.data as! NSArray
                        numRec = retArr.count
                        if numRec > 0 {
                            self.curIndexPage = pageIndex
                            for obj in retArr {
                                self.messageBeanList.append( WBMessageBriefBean(json: JSON(obj)) )
                            }
                        }
                        self.tableView.reloadData()
                    }
                    
                    //if self.messageBeanList.count > 0 {
                    //    self.baseLoadingView.finishLoading()
                    //}else{
                    //    self.baseLoadingView.showError("暂无消息~")
                    //}
                    
                }
                return
            }
            if isFailure {
                if self.tableView.mj_header.isRefreshing() {
                    self.tableView.mj_header.endRefreshing()//
//                }else if self.tableView.mj_footer.isRefreshing() {
//                    self.tableView.mj_footer.endRefreshing()
                }
                //self.baseLoadingView.showError("您当前网络有问题,请点击刷新~")
            }
        }
        
    }
    
}

// MARK: - Table view data source
extension WBMessageVC {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageBeanList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idtWBMessageTBCell", forIndexPath: indexPath) as! WBMessageTBCell
        cell.selectionStyle = .None
        let bean = messageBeanList[indexPath.row]
        cell.configureCell(bean)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

// MARK: - Private Action
extension WBMessageVC {
    func initViewUI() {
        navigationItem.title = "消息"
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.requestListContent()
            })
        
//        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self]  () -> Void in
//            
//            var needPage = self!.curIndexPage
//            let endDataID = ""
//            
//            if self!.messageBeanList.count > 0{
//                needPage = self!.curIndexPage + 1
//                //endDataID = (self!.messageBeanList.last)!.dataId
//            }
//            self!.requestListContent(needPage, dataId: endDataID)
//            
//            })
        
        //view.addSubview(baseLoadingView)
        //baseLoadingView.showLoading("", target: self, select: #selector(WBMessageVC.onClickNetError))
        (tableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (tableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
//        (tableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.textColor = WBMJHeaderColor
        tableView.tableFooterView = UIView()
    }
    
    func onBackNavAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onClickNetError() {
        //baseLoadingView.showLoading("", target: self, select: #selector(WBMessageVC.onClickNetError))
        requestListContent()
    }
    
}

