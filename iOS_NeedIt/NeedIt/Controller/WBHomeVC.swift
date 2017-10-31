//
//  WBHomeVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

// 首页

import UIKit

class WBHomeVC: WBBaseViewController {
    
    private var curShowCityName:String = "北京"
    private var homeHeaderView:WBHomeTBHeaderView!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var midTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    
    private var showIndexType = 0 { didSet{
        switch showIndexType {
        case 0:
            updataShowLeftView()
            break
            
        case 1:
            updataShowMidView()
            break
            
        case 2:
            updataShowRightView()
            break
            
        default:
            break
        }
        }
    }
    
    private var homeNav:WBHomeNavView!
    private var homeNoticeBean:WBHomeNoticeBean?
    private var homeAdBean:WBHomeAdBean?
    
    private var curIndexPageLeft: Int = 1
    private var curIndexPageMid: Int = 1
    private var curIndexPageRight: Int = 1
    private var newShopBeanList = [WBNewShopBean]()
    private var newProductBeanList = [WBNewProductBean]()
    private var newBuildingBeanList = [WBNewBuildingBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WBHomeVC.appCityChanged), name: CSNSNotification_UserLocation_Update, object: nil)
        initViewUI()
        refreshUpdateContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshUpdateContent() {
        requestHomeHeaderNoticeContent()
        requestHomeAdContent()
        requestHomeListViewContent()
    }
    
    func appCityChanged() {
        if (curShowCityName as NSString).isEqualToString(WBUserManager.sharedInstance.appLocalCity()){
            print("城市未切换")
        }else{
            curShowCityName = WBUserManager.sharedInstance.appLocalCity()
            refreshUpdateContent()
        }
        
    }
}

// MARK: - Table view data source
extension WBHomeVC {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if 1 == section{
            return 44
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (homeHeaderView == nil) {
            guard let view = self.leftTableView.dequeueReusableHeaderFooterViewWithIdentifier("idtWBHomeTBHeaderView") else {
                let viewNew = NSBundle.mainBundle().loadNibNamed("idtWBHomeTBHeaderView", owner: nil, options: nil)[0] as! WBHomeTBHeaderView
                return viewNew
            }
            homeHeaderView = view as! WBHomeTBHeaderView
            homeHeaderView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44)
            homeHeaderView.callFunc = { [unowned self](isIndex: Int) in
                if (2 != isIndex){
                    self.showIndexType = isIndex
                }else{
                    self.updataShowRightView()
                }
            }
        }
        
        let chooseButton:UIButton!
        switch showIndexType {
        case 0:
            chooseButton = homeHeaderView.newShopButton
            homeHeaderView.slideSectionViewButton(chooseButton)
            break
        case 1:
            chooseButton = homeHeaderView.newProductButton
            homeHeaderView.slideSectionViewButton(chooseButton)
            break
        case 2:
            //homeHeaderView.slideSectionViewButton(chooseButton)
            chooseButton = homeHeaderView.newbuildingButton
            break
        default:
            chooseButton = homeHeaderView.newShopButton
            break
        }
        return homeHeaderView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section{
            var n = 0
            if (homeAdBean != nil) {
                guard homeAdBean?.status == 1 else {
                    return 0
                }
                n = (homeAdBean?.dataList.count > 0) ? 1 : 0                 
            }
            return n
        }
        if tableView == leftTableView {
            return newShopBeanList.count
        }
        if tableView == midTableView {
            return newProductBeanList.count
        }
        return newBuildingBeanList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if 0 == indexPath.section {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBHomeAdViewTBCell", forIndexPath: indexPath) as! WBHomeAdViewTBCell
            cell.selectionStyle = .None
            var vScroll : LJAutoScrollView? = cell.contentView.viewWithTag(8080) as? LJAutoScrollView
            if ((vScroll) != nil) {
            }else{
                let height: CGFloat = (self.view.bounds.width/414)*196//(self.view.bounds.width*2)/3
                vScroll = LJAutoScrollView(frame: CGRectMake(0, 0, self.view.bounds.width, height) )
                vScroll!.delegate = self;
                vScroll!.itemSize = CGSizeMake(self.view.frame.size.width, (self.view.bounds.width/414)*196);
                vScroll!.scrollInterval = 1;
                vScroll!.pageIndicatorTintColor = UIColor.whiteColor()
                vScroll!.currentPageIndicatorTintColor = UIColor.colorWithHexRGB(0x189ECD)
                
                cell.contentView.addSubview(vScroll!)
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("idtWBHomeTBCell", forIndexPath: indexPath) as! WBHomeTBCell
        cell.followButton.tag = indexPath.row
        cell.followButton.removeTarget(self, action: #selector(WBHomeVC.gotoPurchase(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.followButton.addTarget(self, action: #selector(WBHomeVC.gotoPurchase(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.selectionStyle = .None
        var bean: NSObject!
        if tableView == leftTableView {
            bean = newShopBeanList[indexPath.row]
            cell.configureShopCell(bean as! WBNewShopBean)
            
        }else if tableView == midTableView {
            bean = newProductBeanList[indexPath.row]
            cell.configureProductCell(bean as! WBNewProductBean)
            
        }else if tableView == rightTableView {
            bean = newBuildingBeanList[indexPath.row]
            cell.configureBuildingCell(bean as! WBNewBuildingBean)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if 0 == indexPath.section {
            var n = 0
            if (homeAdBean != nil) {
                guard homeAdBean?.status == 1 else {
                    return 0
                }
                n = (homeAdBean?.dataList?.count)!
            }
            if n <= 0 {
                return 0
            }
            return (self.view.bounds.width/414)*196//(self.view.bounds.width*2)/3
        }
        return 300*UIScreen.mainScreen().bounds.width/414
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = CSUIUtils.vcOfCommon("idtWBActivityDetailVC") as! WBActivityDetailVC
        let nav = WBBaseBlackNavigationController(rootViewController: vc)
        if tableView == leftTableView {
            let bean = newShopBeanList[indexPath.row]
            vc.initWithClosureShop(bean, closure: { (isPurchase) in
            })
            
        }else if tableView == midTableView {
            let bean = newProductBeanList[indexPath.row]
            vc.initWithClosureProcuct(bean, closure: { (isPurchase) in
            })
        }else{
            let bean = newBuildingBeanList[indexPath.row]
            vc.initWithClosureBuilding(bean, closure: { (isPurchase) in
            })
        }
        
        self.presentViewController(nav, animated: false, completion: {
        })
    }
    
    func gotoPurchase(sender: UIButton) -> Void {
        let index = sender.tag
        let vc = CSUIUtils.vcOfCommon("idtWBActivityDetailVC") as! WBActivityDetailVC
        let nav = WBBaseBlackNavigationController(rootViewController: vc)
        switch showIndexType {
        case 0:
            let bean = newShopBeanList[index]
            vc.initWithClosureShop(bean, closure: { (isPurchase) in
            })
            break
            
        case 1:
            let bean = newProductBeanList[index]
            vc.initWithClosureProcuct(bean, closure: { (isPurchase) in
            })
            break
            
        case 2:
            //let bean = newBuildingBeanList[index]
            //vc.initWithClosureBuilding(bean, closure: { (isPurchase) in
            //})
            break
            
        default:
            break
        }
        self.presentViewController(nav, animated: false, completion: {
        })

    }
    
}


// MARK: - Private Action
extension WBHomeVC {
    func gotoSearchVC() {
        let vc = CSUIUtils.vcOfCommon("idtWBSearchVC") as! WBSearchVC
        let nav = WBBaseNavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: {
        })
    }
    
    func initViewUI() {
        //.Nav
        let rShow = self.navigationController?.navigationBar.bounds
        let vShow = NSBundle.mainBundle().loadNibNamed("WBHomeNavView", owner: nil, options: nil)[0] as! WBHomeNavView
        vShow.frame = rShow!
        self.navigationController?.navigationBar.addSubview(vShow)
        homeNav = vShow
        vShow.scrollTitleLabel.text = "正在获取..."
        vShow.searchButton.addTarget(self, action: #selector(WBHomeVC.gotoSearchVC), forControlEvents: .TouchUpInside)
        
        //.TableView
        let nibHeader = UINib.init(nibName: "WBHomeTBHeaderView",bundle: NSBundle.mainBundle())
        let nibCell = UINib.init(nibName: "WBHomeTBCell",bundle: NSBundle.mainBundle())
        let nibAd = UINib.init(nibName: "WBHomeAdViewTBCell",bundle: NSBundle.mainBundle())
        self.leftTableView.registerNib(nibHeader, forHeaderFooterViewReuseIdentifier: "idtWBHomeTBHeaderView")
        self.midTableView.registerNib(nibHeader, forHeaderFooterViewReuseIdentifier: "idtWBHomeTBHeaderView")
        self.rightTableView.registerNib(nibHeader, forHeaderFooterViewReuseIdentifier: "idtWBHomeTBHeaderView")
        
        self.leftTableView.registerNib(nibCell, forCellReuseIdentifier: "idtWBHomeTBCell")
        self.midTableView.registerNib(nibCell, forCellReuseIdentifier: "idtWBHomeTBCell")
        self.rightTableView.registerNib(nibCell, forCellReuseIdentifier: "idtWBHomeTBCell")
        self.leftTableView.registerNib(nibAd, forCellReuseIdentifier: "idtWBHomeAdViewTBCell")
        self.midTableView.registerNib(nibAd, forCellReuseIdentifier: "idtWBHomeAdViewTBCell")
        self.rightTableView.registerNib(nibAd, forCellReuseIdentifier: "idtWBHomeAdViewTBCell")
        self.leftTableView.tableFooterView = UIView()
        self.midTableView.tableFooterView = UIView()
        self.rightTableView.tableFooterView = UIView()
        self.leftTableView.backgroundColor = UIColor.clearColor()
        self.midTableView.backgroundColor = UIColor.clearColor()
        self.rightTableView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor.colorWithHexRGB(0xE2E2E3)
        
        self.midTableView.hidden = true
        self.rightTableView.hidden = true
        
        leftTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.requestHomeHeaderNoticeContent()
            self!.requestHomeAdContent()
            self!.requestLeftContent()
            
            self!.leftTableView.mj_footer.resetNoMoreData()
            })
        
        leftTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self]  () -> Void in
            
            var needPage = self!.curIndexPageLeft
            let endDataID = ""
            
            if self!.newShopBeanList.count > 0{
                needPage = self!.curIndexPageLeft + 1
                //endDataID = (self!._messageBeanList.last)!.dataId
            }
            self!.requestLeftContent(needPage, dataId: endDataID)
            
            })
        leftTableView.tableFooterView = UIView()
        (leftTableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (leftTableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
        (leftTableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.textColor = WBMJHeaderColor
        
        
        midTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.requestHomeHeaderNoticeContent()
            self!.requestHomeAdContent()
            self!.requestMidContent()
            
            self!.midTableView.mj_footer.resetNoMoreData()
            })
        
        midTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self]  () -> Void in
            
            var needPage = self!.curIndexPageMid
            let endDataID = ""
            
            if self!.newShopBeanList.count > 0{
                needPage = self!.curIndexPageMid + 1
                //endDataID = (self!._messageBeanList.last)!.dataId
            }
            self!.requestMidContent(needPage, dataId: endDataID)
            
            })
        midTableView.tableFooterView = UIView()
        (midTableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (midTableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
        (midTableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.textColor = WBMJHeaderColor
        
        rightTableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.requestHomeHeaderNoticeContent()
            self!.requestHomeAdContent()
            self!.requestRightContent()
            
            self!.rightTableView.mj_footer.resetNoMoreData()
            })
        
        rightTableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self]  () -> Void in
            
            var needPage = self!.curIndexPageRight
            let endDataID = ""
            
            if self!.newBuildingBeanList.count > 0{
                needPage = self!.curIndexPageRight + 1
                //endDataID = (self!._messageBeanList.last)!.dataId
            }
            self!.requestRightContent(needPage, dataId: endDataID)
            
            })
        rightTableView.tableFooterView = UIView()
        (rightTableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (rightTableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
        (rightTableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.textColor = WBMJHeaderColor
        
        //view.addSubview(baseLoadingView)
        //baseLoadingView.showLoading("", target: self, select: #selector(WBMessageVC.onClickNetError))
    }
    
    func onClickNetError() {
        baseLoadingView.showLoading("", target: self, select: #selector(WBMessageVC.onClickNetError))
        //requestListContent()
    }
    
}

// MARK: - LJAutoScrollViewDelegate
extension WBHomeVC: LJAutoScrollViewDelegate {
    func autoScrollView(autoScrollView: LJAutoScrollView!, customViewForIndex index: Int) -> UIView! {
        let imageV = UIImageView(frame: CGRectMake(0.0, 0.0, self.view.bounds.width, (self.view.bounds.width/414)*183.33))
        imageV.userInteractionEnabled = true
        imageV.clipsToBounds = true
        imageV.contentMode = .ScaleAspectFit
        imageV.backgroundColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1)
        if index < 0 {
            return imageV
        }
        let imageStr = homeAdBean?.dataList![NSInteger(index)].img
        imageV.sd_setImageWithURL(NSURL(string: imageStr!), placeholderImage: UIImage(named: "imageDefault"), options: SDWebImageOptions.RefreshCached) { (image, error, cachType, url) -> Void in
            if nil === image {
                imageV.image = nil
                //imageV.image = UIImage(named: "imageDefault")
            }else{
                imageV.image = image
                //imageV.backgroundColor = UIColor.whiteColor()
            }
        }
        return imageV
    }
    
    func numberOfPagesInAutoScrollView(autoScrollView: LJAutoScrollView!) -> Int {
        var n = 0
        if (homeAdBean != nil) {
            guard homeAdBean?.status == 1 else {
                return 0
            }
            n = (homeAdBean?.dataList?.count)!
        }
        return n
    }
    

    /*********     广告图标点击事件
     
     
     ************/
    
    
    func autoScrollView(autoScrollView: LJAutoScrollView!, didSelectItemAtIndex index: Int) {
        let bean = homeAdBean?.dataList![NSInteger(index)]
        print("开始界面跳转值为：\(homeAdBean?.dataList![NSInteger(index)]) ＝＝＝＝＝＝＝ \(bean!.urlId)")
        

        
        let vc = WBHomeslideListingViewController()
        vc.urlId = bean!.urlId
        let nav = WBBaseNavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: {})
        
        /*
        let bean = homeAdBean?.dataList![NSInteger(index)]
        
        let vc = CSUIUtils.vcOfCommon("idtWBActivityDetailVC") as! WBActivityDetailVC
        vc.initWithClosureDetailId(bean!.urlId) { (isPurchase) in
        }
//        let nav = WBBaseBlackNavigationController(rootViewController: vc)
//        self.presentViewController(nav, animated: false, completion: {
//        })
        print("开始界面跳转值为：\(homeAdBean?.dataList![NSInteger(index)]) ＝＝＝＝＝＝＝ \(bean!.urlId)")
        
        
        let nav = WBHomeslideListingViewController()
        nav.urlId = bean!.urlId
        self.presentViewController(nav, animated: false) { 
            
        }
        */
    }
    
}

extension WBHomeVC {
    func updataNavView() {
        homeNav.scrollTitleLabel.text = self.homeNoticeBean?.text
        homeNav.locationButton.setTitle(WBUserManager.sharedInstance.appLocalCity(), forState: .Normal)
    }
    
    func updataAdView() {
        let tbView:UITableView!
        if 0 == showIndexType {
            tbView = leftTableView
        }else if 1 == showIndexType {
            tbView = midTableView
        }else {
            tbView = rightTableView
        }
        tbView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func updataShowLeftView() {
        leftTableView.hidden = false
        midTableView.hidden = true
        rightTableView.hidden = true
        
        leftTableView.reloadData()
        if newShopBeanList.count > 0 {
            return
        }
        if leftTableView.mj_header.isRefreshing() ||  leftTableView.mj_footer.isRefreshing() {
        }else{
            leftTableView.mj_header.beginRefreshing()
        }
    }
    
    func updataShowMidView() {
        leftTableView.hidden = true
        midTableView.hidden = false
        rightTableView.hidden = true

        midTableView.reloadData()
        if newProductBeanList.count > 0 {
            return
        }
        if midTableView.mj_header.isRefreshing() ||  midTableView.mj_footer.isRefreshing() {
        }else{
            midTableView.mj_header.beginRefreshing()
        }
    }
    
    func updataShowRightView() {
        let vc = CSUIUtils.vcOfCommon("idtWBWebViewVC") as! WBWebViewVC
        vc.urlStr = WBNetManager.sharedInstance.getAppBuildingURL()
        homeNav.hidden = true
        vc.hidesBottomBarWhenPushed = true;
        vc.initWithClosureRegister { [weak self](isCloseVC) in
            self?.homeNav.hidden = false
        }
        self.navigationController?.pushViewController(vc, animated: false)
        //let nav = WBBaseNavigationController(rootViewController: vc)
        //self.navigationController!.presentViewController(nav, animated: false) {}
        return
        
        /*
        leftTableView.hidden = true
        midTableView.hidden = true
        rightTableView.hidden = false
        
        rightTableView.reloadData()
        if newBuildingBeanList.count > 0 {
            return
        }
        if rightTableView.mj_header.isRefreshing() ||  rightTableView.mj_footer.isRefreshing() {
        }else{
            rightTableView.mj_header.beginRefreshing()
        }
         */
    }
    
    private func requestHomeHeaderNoticeContent() {
        let urlStr = WBNetManager.sharedInstance.getHomeHeadNoticeURL()
        print("首页通知:\(urlStr)")
        
        WBNetManager.sharedInstance.requestByPost(urlStr, params: nil) { (isSuccess, isFailure, json, error) -> Void in
            if isSuccess {
                self.homeNoticeBean = WBHomeNoticeBean(json: json)
            }
            if isFailure {
            }
            self.updataNavView()
        }
    }
    
    private func requestHomeAdContent() {
        let urlStr = WBNetManager.sharedInstance.getHomeHeadAdURL()
        print("首页头图:\(urlStr)")
        
        let cityName = WBUserManager.sharedInstance.appLocalCity()
        let dicPost = NSDictionary(object: cityName, forKey: "city")//长沙
        print("dicPost  == \(dicPost)")
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            if isSuccess {
                self.homeAdBean = WBHomeAdBean(json: json)
            }
            if isFailure {
            }
            self.updataAdView()
            
        }
    }
    
    private func requestHomeListViewContent(pageIndex: NSInteger = 1,dataId: String = "") {
        if 0 == showIndexType {
            requestLeftContent(pageIndex, dataId: dataId)
        }else if (1 == showIndexType){
            requestMidContent(pageIndex, dataId: dataId)
        }else{
            requestRightContent(pageIndex, dataId: dataId)
        }
    }
    
    private func requestLeftContent(pageIndex: NSInteger = 1,dataId: String = "") {
        let urlStr = WBNetManager.sharedInstance.getHomeListURL()
        print("商店列表:\(urlStr)")
        
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(objects: [token,curShowCityName,"1","\(pageIndex)"], forKeys: ["token","city","type","page"])
        
        WBNetManager.sharedInstance.requestByPost(urlStr, params: (dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) in
            if self.leftTableView.mj_header.isRefreshing() {
                self.leftTableView.mj_header.endRefreshing()
            }else if self.leftTableView.mj_footer.isRefreshing() {
                self.leftTableView.mj_footer.endRefreshing()
            }
            
            if isSuccess {
                let retoBJ = WBParseNetBase(json: json)
                var numRec = 0
                if retoBJ.isDataOk() {
                    if 1 == pageIndex {
                        self.newShopBeanList.removeAll()
                        self.leftTableView.reloadData()
                    }
                    
                    if retoBJ.data.isKindOfClass(NSNull){
                        SVProgressHUD.showSuccessWithStatus((1==pageIndex) ? "暂无店铺~" : "暂无更多店铺~" )
                    }else{
                        let retArr = retoBJ.data as! NSArray
                        numRec = retArr.count
                        if numRec > 0 {
                            self.curIndexPageLeft = pageIndex
                            for obj in retArr {
                                self.newShopBeanList.append( WBNewShopBean(json: JSON(obj)) )
                            }
                        }else{
                            self.leftTableView.mj_footer.endRefreshingWithNoMoreData()
                            (self.leftTableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.text = "已经到底了..."
                        }
                        self.leftTableView.reloadData()
                    }
                }
                return
            }
            if isFailure {
            }
        }
        
    }
    
    private func requestMidContent(pageIndex: NSInteger = 1,dataId: String = "") {
        let urlStr = WBNetManager.sharedInstance.getHomeListURL()
        print("产品列表:\(urlStr)")
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(objects: [token,curShowCityName,"2","\(pageIndex)"], forKeys: ["token","city","type","page"])
        
        print("dicPost \(dicPost)")
        
        WBNetManager.sharedInstance.requestByPost(urlStr, params: (dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) in
            if self.midTableView.mj_header.isRefreshing() {
                self.midTableView.mj_header.endRefreshing()
            }else if self.midTableView.mj_footer.isRefreshing() {
                self.midTableView.mj_footer.endRefreshing()
            }

            if isSuccess {
                let retoBJ = WBParseNetBase(json: json)
                var numRec = 0
                if retoBJ.isDataOk() {
                    if 1 == pageIndex {
                        self.newProductBeanList.removeAll()
                        self.midTableView.reloadData()
                    }
                    
                    if retoBJ.data.isKindOfClass(NSNull){
                        SVProgressHUD.showSuccessWithStatus((1==pageIndex) ? "暂无店铺~" : "暂无更多店铺~" )
                    }else{
                        let retArr = retoBJ.data as! NSArray
                        numRec = retArr.count
                        if numRec > 0 {
                            self.curIndexPageMid = pageIndex
                            for obj in retArr {
                                self.newProductBeanList.append( WBNewProductBean(json: JSON(obj)) )
                            }
                        }else{
                            self.midTableView.mj_footer.endRefreshingWithNoMoreData()
                            (self.midTableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.text = "已经到底了..."
                        }
                        self.midTableView.reloadData()
                    }
                }
                return
            }
            if isFailure {
            }
            
        }
    }
    
    private func requestRightContent(pageIndex: NSInteger = 1,dataId: String = "") {
        let urlStr = WBNetManager.sharedInstance.getHomeListURL()
        print("楼盘列表:\(urlStr)")
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(objects: [token,curShowCityName,"3","\(pageIndex)"], forKeys: ["token","city","type","page"])
        
        WBNetManager.sharedInstance.requestByPost(urlStr, params: (dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) in
            if self.rightTableView.mj_header.isRefreshing() {
                self.rightTableView.mj_header.endRefreshing()
            }else if self.rightTableView.mj_footer.isRefreshing() {
                self.rightTableView.mj_footer.endRefreshing()
            }

            if isSuccess {
                let retoBJ = WBParseNetBase(json: json)
                var numRec = 0
                if retoBJ.isDataOk() {
                    if 1 == pageIndex {
                        self.newBuildingBeanList.removeAll()
                        self.rightTableView.reloadData()
                    }
                    
                    if retoBJ.data.isKindOfClass(NSNull){
                        SVProgressHUD.showSuccessWithStatus((1==pageIndex) ? "暂无店铺~" : "暂无更多店铺~" )
                    }else{
                        let retArr = retoBJ.data as! NSArray
                        numRec = retArr.count
                        if numRec > 0 {
                            self.curIndexPageRight = pageIndex
                            for obj in retArr {
                                self.newBuildingBeanList.append( WBNewBuildingBean(json: JSON(obj)) )
                            }
                        }else{
                            self.rightTableView.mj_footer.endRefreshingWithNoMoreData()
                            (self.rightTableView.mj_footer as! MJRefreshAutoNormalFooter).stateLabel!.text = "已经到底了..."
                        }
                        self.rightTableView.reloadData()
                    }
                }
                return
            }
            if isFailure {
            }
            
        }
    }
    
}
