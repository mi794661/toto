//
//  WBTaskVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBTaskVC: WBBaseViewController {
    
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    
    private var curToRebateIndexPage: Int = 1
    private var curRebatedIndexPage: Int = 1
    
    private var toRebateBeanList = [WBRebateBean]()
    private var rebatedBeanList = [WBRebateBean]()
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var slideImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "任务库"
        
        initViewUI()
        leftButton.selected = true
        leftTableView.mj_header.beginRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickLeftButton(sender: AnyObject) {
        var center = slideImageView.center
        let rect = slideImageView.frame
        let bounds = UIScreen.mainScreen().bounds
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.leftButton.userInteractionEnabled = false
            self.rightButton.userInteractionEnabled = false
            
            center.x =  bounds.width*3/4
            let targetFrame = CGRectMake(abs(center.x - rect.size.width * 0.5), center.y - rect.size.height * 0.5, rect.size.width, rect.size.height )
            self.slideImageView.frame = targetFrame
            
        }) { (isFinished) -> Void in
            if(isFinished) {
                self.rightTableView.hidden = true
                self.leftTableView.hidden = false
                self.leftButton.selected = true
                self.rightButton.selected = false

                self.leftButton.userInteractionEnabled = true
                self.rightButton.userInteractionEnabled = true

                center.x =  bounds.width/4
                let targetFrame = CGRectMake(abs(center.x - rect.size.width * 0.5), center.y - rect.size.height * 0.5, rect.size.width, rect.size.height )
                self.slideImageView.frame = targetFrame

            }
        }
    }
    
    @IBAction func clickRightButton(sender: AnyObject) {
        if (0 != rebatedBeanList.count || rightTableView.mj_header.isRefreshing()
            //|| rightTableView.mj_footer.isRefreshing()
            ){
        }else{
            rightTableView.mj_header.beginRefreshing()
        }
        
        var center = slideImageView.center
        let rect = slideImageView.frame
        let bounds = UIScreen.mainScreen().bounds

        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.leftButton.userInteractionEnabled = false
            self.rightButton.userInteractionEnabled = false

            center.x =  bounds.width/4
            let targetFrame = CGRectMake(abs(center.x - rect.size.width * 0.5), center.y - rect.size.height * 0.5, rect.size.width, rect.size.height )
            self.slideImageView.frame = targetFrame

        }) { (isFinished) -> Void in
            if (isFinished) {
                self.rightTableView.hidden = false
                self.leftTableView.hidden = true
                self.leftButton.selected = false
                self.rightButton.selected = true
                
                self.leftButton.userInteractionEnabled = true
                self.rightButton.userInteractionEnabled = true

                center.x =  bounds.width*3/4
                let targetFrame = CGRectMake(abs(center.x - rect.size.width * 0.5), center.y - rect.size.height * 0.5, rect.size.width, rect.size.height )
                self.slideImageView.frame = targetFrame

            }
        }
    }
    
}

// MARK: - Private Action
extension WBTaskVC {
    func initViewUI() {
        slideImageView.layer.cornerRadius = 1;
        leftTableView.tableFooterView = UIView()
        rightTableView.tableFooterView = UIView()
        leftTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.requestToRebateListContent()
            })
        
//        leftTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self]  () -> Void in
//            
//            var needPage = self!.curToRebateIndexPage
//            let endDataID = ""
//            
//            if self!.toRebateBeanList.count > 0{
//                needPage = self!.curToRebateIndexPage + 1
//                //endDataID = (self!._messageBeanList.last)!.dataId
//            }
//            self!.requestToRebateListContent(needPage, dataId: endDataID)
//            
//            })
        
        rightTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.requestRebatedListContent()
            })
        
//        rightTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self]  () -> Void in
//            
//            var needPage = self!.curRebatedIndexPage
//            let endDataID = ""
//            
//            if self!.rebatedBeanList.count > 0{
//                needPage = self!.curToRebateIndexPage + 1
//                //endDataID = (self!._messageBeanList.last)!.dataId
//            }
//            self!.requestRebatedListContent(needPage, dataId: endDataID)
//            
//            })
        (leftTableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (rightTableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (leftTableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
//        (leftTableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.textColor = WBMJHeaderColor
        (rightTableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
//        (rightTableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.textColor = WBMJHeaderColor
    }
    
    func onBackNavAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onClickNetError() {
    }
    
}

// MARK: - Table view data source
extension WBTaskVC {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return toRebateBeanList.count
        }
        return rebatedBeanList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBTaskRebateTBCell", forIndexPath: indexPath) as! WBTaskRebateTBCell
            cell.selectionStyle = .None
            let bean = toRebateBeanList[indexPath.row]
            cell.configureCell(bean)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("idtWBTaskRebatedTBCell", forIndexPath: indexPath) as! WBTaskRebatedTBCell
        cell.selectionStyle = .None
        let bean = rebatedBeanList[indexPath.row]
        cell.configureCell(bean)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == leftTableView {
            let bean = toRebateBeanList[indexPath.row]
            if 1 == bean.type {
                let vc = CSUIUtils.vcOfCommon("idtWBPlayRebateVideoVC") as! WBPlayRebateVideoVC
                vc.initWithClosurePlayRebateVideo(bean, closure: { (isFinished) in
                    if isFinished {
                        self.leftTableView.mj_header.beginRefreshing()
                    }
                    return
                })
                let nav = WBBaseNavigationController(rootViewController: vc)
                nav.isNeedSupportLandscape = true
                vc.navigationController?.navigationBar.hidden = true
                self.presentViewController(nav, animated: true, completion: {
                })
                
            }else{
                let vc = CSUIUtils.vcOfCommon("idtWBQuestionNaireVC") as! WBQuestionNaireVC
                let nav = WBBaseNavigationController(rootViewController: vc)
                vc.initWithClosureQuestionNaire(bean, closure: { (isFinished) in
                    if isFinished {
                        self.leftTableView.mj_header.beginRefreshing()
                    }
                    return
                })
                self.presentViewController(nav, animated: true, completion: {
                })
            }
            
        }
    }
}

extension WBTaskVC {
    private func requestToRebateListContent(pageIndex: NSInteger = 1,dataId: String = "") {
        let url = WBNetManager.sharedInstance.getToRebateListURL(pageIndex, dataId: dataId)
        print("待做任务列表:\(url)")
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(object: token, forKey: "token")
        WBNetManager.sharedInstance.requestByPost(url, params: (dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) in
            if self.leftTableView.mj_header.isRefreshing() {
                self.leftTableView.mj_header.endRefreshing()
//                self.leftTableView.mj_footer.resetNoMoreData()
//            }else if self.leftTableView.mj_footer.isRefreshing() {
//                self.leftTableView.mj_footer.endRefreshing()
                
            }

            if isSuccess {
                let retoBJ = WBParseNetBase(json: json)
                var numRec = 0
                if retoBJ.isDataOk() {
                    if 1 == pageIndex {
                        self.toRebateBeanList.removeAll()
                        self.leftTableView.reloadData()
                    }
                    if retoBJ.data.isKindOfClass(NSNull){
                        SVProgressHUD.showSuccessWithStatus((1==pageIndex) ? "暂无消息~" : "暂无更多消息~" )
                    }else{
                        let retArr = retoBJ.data as! NSArray
                        numRec = retArr.count
                        if numRec > 0 {
                            self.curToRebateIndexPage = pageIndex
                            for obj in retArr {
                                self.toRebateBeanList.append( WBRebateBean(json: JSON(obj)) )
                            }
                        }
                        self.leftTableView.reloadData()
                    }
                    
                }
                
//                if CS_NET_PAGE_COUNT == numRec {
//                    self.leftTableView.mj_footer.hidden = false
//                }
//                else{
//                    self.leftTableView.mj_footer.hidden = true
//                }
                return
            }
            
            if isFailure {
            }
            
        }
        
    }
    
    private func requestRebatedListContent(pageIndex: NSInteger = 1,dataId: String = "") {
        let urlStr = WBNetManager.sharedInstance.getRebatedListURL(pageIndex, dataId: dataId)
        print("已完成任务列表:\(urlStr)")
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(object: token, forKey: "token")
        WBNetManager.sharedInstance.requestByPost(urlStr, params: (dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) in
            if self.rightTableView.mj_header.isRefreshing() {
                self.rightTableView.mj_header.endRefreshing()
//                self.rightTableView.mj_footer.resetNoMoreData()
//            }else if self.rightTableView.mj_footer.isRefreshing() {
//                self.rightTableView.mj_footer.endRefreshing()
//                
            }

            if isSuccess {
                let retoBJ = WBParseNetBase(json: json)
                var numRec = 0
                if retoBJ.isDataOk() {
                    if 1 == pageIndex {
                        self.rebatedBeanList.removeAll()
                        self.rightTableView.reloadData()
                    }
                    
                    if retoBJ.data.isKindOfClass(NSNull){
                        SVProgressHUD.showSuccessWithStatus((1==pageIndex) ? "暂无消息~" : "暂无更多消息~" )
                    }else{
                        let retArr = retoBJ.data as! NSArray
                        numRec = retArr.count
                        if numRec > 0 {
                            self.curRebatedIndexPage = pageIndex
                            for obj in retArr {
                                self.rebatedBeanList.append( WBRebateBean(json: JSON(obj)) )
                            }
                        }
                        self.rightTableView.reloadData()
                    }
                }
                
//                if CS_NET_PAGE_COUNT == numRec {
//                    self.rightTableView.mj_footer.hidden = false
//                }
//                else{
//                    self.rightTableView.mj_footer.hidden = true
//                }
                return
            }
            
            if isFailure {
            }
            
        }
    }
    
}
