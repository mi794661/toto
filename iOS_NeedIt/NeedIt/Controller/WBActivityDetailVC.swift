//
//  WBActivityDetailVC.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//


//  活动详情

import UIKit

typealias callBackActivityDetailVCShop = (isPurchase: Bool) -> Void
typealias callBackActivityDetailVCProduct = (isPurchase: Bool) -> Void
typealias callBackActivityDetailVCBuilding = (isPurchase: Bool) -> Void

typealias callBackActivityDetailVCLikeData = (isPurchase: Bool) -> Void
typealias callBackActivityDetailVCOrder = (isPurchase: Bool) -> Void

typealias callBackActivityDetailVCDetailId = (isPurchase: Bool) -> Void

enum WBActivityDetailEnum : Int {
    case WBActivityDetailShop = 0, WBActivityDetailProduct = 1, WBActivityDetailBuilding = 2, WBActivityDetailMyOrder
}

class WBActivityDetailVC: UIViewController {
    
    internal var dataId:String!
    private var orderInfoBean:WBOrderInfoBean?
    private var isShowQRCodeOrReabte: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomDescLable: UILabel!
    @IBOutlet weak var bottomPurchaseLable: UIButton!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    //Shop
    private var shopBean: WBNewShopBean?
    var retShopClosure:callBackActivityDetailVCShop?
    func initWithClosureShop(beanShop:WBNewShopBean, closure:callBackActivityDetailVCShop?){
        retShopClosure = closure
        shopBean = beanShop;
        dataId = shopBean!.dataId
    }
    
    //Product
    private var productBean: WBNewProductBean?
    var retProductClosure:callBackActivityDetailVCProduct?
    func initWithClosureProcuct(beanProduct:WBNewProductBean, closure:callBackActivityDetailVCProduct?){
        retProductClosure = closure
        productBean = beanProduct;
        dataId = productBean!.dataId
    }
    
    //Building
    private var buildingBean: WBNewBuildingBean?
    var retBuildingClosure:callBackActivityDetailVCBuilding?
    func initWithClosureBuilding(beanBuilding:WBNewBuildingBean, closure:callBackActivityDetailVCBuilding?){
        retBuildingClosure = closure
        buildingBean = beanBuilding;
        dataId = buildingBean!.dataId
    }
    
    //Like
    private var likeBean: WBActivityProductLikeBean?
    var retLikeClosure:callBackActivityDetailVCLikeData?
    func initWithClosureLike(beanLike:WBActivityProductLikeBean, closure:callBackActivityDetailVCLikeData?){
        retLikeClosure = closure
        likeBean = beanLike;
        dataId = likeBean!.dataId
    }
    
    //MyOrder
    private var orderBean: WBOrderInfoBean?
    var retOrderClosure:callBackActivityDetailVCOrder?
    func initWithClosureOrder(beanOrder:WBOrderInfoBean, closure:callBackActivityDetailVCOrder?){
        retOrderClosure = closure
        orderBean = beanOrder;
        dataId = orderBean!.dataId
        isShowQRCodeOrReabte = true
    }
    
    //DataId
    var retDetailIdClosure:callBackActivityDetailVCDetailId?
    func initWithClosureDetailId(detailDataId:String,orderBean: WBOrderInfoBean? = nil, closure:callBackActivityDetailVCDetailId?){
        retDetailIdClosure = closure
        dataId = detailDataId
        orderInfoBean = orderBean
    }
    
    var activityDetailBean:WBActivityDetailBean?
    var activityLikeBean:WBActivityProductLikeInfoBean?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "活动详情"
        tableView.backgroundColor = WBViewColor
        CSUIUtils.configNavBarBackWhiteButton(self, selector:#selector(WBActivityDetailVC.onBackNavAction))
        bottomPurchaseLable.layer.cornerRadius = 4
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] () -> Void in
            self!.refreshCurView()
            })
        (tableView.mj_header as! MJRefreshStateHeader).lastUpdatedTimeLabel!.hidden = true
        (tableView.mj_header as! MJRefreshStateHeader).stateLabel!.textColor = WBMJHeaderColor
        tableView.tableFooterView = UIView()
        
        updateActivityButtom()
        tableView.mj_header.beginRefreshing()
    }
    
    func onBackNavAction() {
        if navigationController?.viewControllers.count > 1 {
            navigationController?.popViewControllerAnimated(true)
        }else{
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor() ,NSFontAttributeName : UIFont.systemFontOfSize(18)]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Default;
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black;
        self.navigationController?.navigationBar.barTintColor = WBThemeColor
        self.navigationController?.view.backgroundColor = WBThemeColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor() ,NSFontAttributeName : UIFont.systemFontOfSize(18)]
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func refreshCurView() {
        requestActivityDetailContent()
    }
    
    func updateActivityTableView() {
        self.tableView.reloadData()
    }
    
    func updateActivityButtom() {
        guard let info = activityDetailBean else {
            bottomDescLable.text = ""
            return
        }
        
        if ("1" == activityDetailBean?.data.orderStatus) {
            buttomView.hidden = true
            bottomCons.constant = 0
        }else{
            bottomCons.constant = 50
            buttomView.hidden = false
        }
    
        bottomDescLable.text = "现金券价格\(info.data.price)"
    }
}

extension WBActivityDetailVC {
    private func requestActivityDetailContent() {
        SVProgressHUD.showWithStatus("拼命加载中...")
        let urlStr = WBNetManager.sharedInstance.getActivityDetailURL()
        print("商品详情:\(urlStr)")
        
        let dicPost = NSMutableDictionary(objects: [dataId], forKeys: ["id"])
        let token = WBUserManager.sharedInstance.appLocalToken()
        if !token.isEmpty {
            dicPost.setValue(token, forKey: "token")   
        }
        
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            if isSuccess {
                self.requestActivityProductLikeContent()
                
                self.activityDetailBean = WBActivityDetailBean(json: json)
                
                self.updateActivityTableView()
                self.updateActivityButtom()
                SVProgressHUD.dismiss()
                return
            }
            if isFailure {
            }
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }
            SVProgressHUD.showErrorWithStatus("网络错误~")
            SVProgressHUD.dismissWithDelay(2.0)
        }
    }
    
    private func requestActivityProductLikeContent() {
        let urlStr = WBNetManager.sharedInstance.getActivityProductLikeURL()
        print("浏览过该商品的人还看过:\(urlStr)")
        
        let dicPost = NSDictionary(objects: [dataId], forKeys: ["id"])
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }
            
            if isSuccess {
                self.activityLikeBean = WBActivityProductLikeInfoBean(json: json)
                self.updateActivityTableView()
                return
            }
            if isFailure {
            }
            SVProgressHUD.showErrorWithStatus("网络失败！")
        }
    }
    
}

extension WBActivityDetailVC {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            break
        case 2:
            if 0 != indexPath.row {
                cell.separatorInset = UIEdgeInsetsMake(0, UIScreen.mainScreen().bounds.width, 0, -UIScreen.mainScreen().bounds.width)
                if #available(iOS 8.0, *) {
                    cell.layoutMargins = UIEdgeInsetsMake(0, UIScreen.mainScreen().bounds.width, 0, -UIScreen.mainScreen().bounds.width)
                }
                return
            }
        case 3:
            break
        case 4:
            break
        default:
            break
        }
        cell.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if 0 == section {
            return 0
        }else if 4 == section{
        
            return 0
        }
        return 20
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 20))
        v.backgroundColor = UIColor.colorWithHexRGB(0xE2E2E3)
        return v
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (activityDetailBean != nil) ? (5+1) : 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let _ = orderInfoBean else {
                return (activityDetailBean != nil) ? (2 + ( (isShowQRCodeOrReabte && ("1" == activityDetailBean!.data.orderStatus || "2" == activityDetailBean!.data.orderStatus) ) ? 1 : 0 ) ) : 0
            }
            return (activityDetailBean != nil) ? (2 + ( ("1" == orderInfoBean!.status || "2" == orderInfoBean!.status) ? 1 : 0) ) : 0
        case 1:
            guard let _ = activityDetailBean else {
                return 0
            }
            return 1
        case 2:
            guard let _ = activityDetailBean else {
                return 0
            }
            return (1 + activityDetailBean!.data.info!.count)
        case 3:
            return (activityDetailBean != nil) ? 3 : 0
        case 4:
            guard let _ = activityLikeBean else {
                return 0
            }
            return activityLikeBean!.data.count + 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if 0 == indexPath.row {
                let activity = activityDetailBean!.data
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityBriefTBCell", forIndexPath: indexPath) as! WBActivityBriefTBCell
                cell.selectionStyle = .None
                cell.configureCell(activity)
                return cell
            }
            if 1 == indexPath.row {
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityRebateProcessTBCell", forIndexPath: indexPath) as! WBActivityRebateProcessTBCell
                cell.selectionStyle = .None
                return cell
            }
 
            if ((nil != activityDetailBean) && "1" == activityDetailBean!.data.orderStatus) || ((nil != orderInfoBean) && "1" == orderInfoBean!.status) {
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityOrderQRCodeTBCell", forIndexPath: indexPath) as! WBActivityOrderQRCodeTBCell
                cell.selectionStyle = .None
                var tradeCode = ""
                if (orderInfoBean != nil) {
                    tradeCode = orderInfoBean!.tradeCode
                }else{
                    tradeCode = activityDetailBean!.data.tradeCode
                }
                cell.configureCell(tradeCode)
                return cell
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityStartRebateTBCell", forIndexPath: indexPath) as! WBActivityStartRebateTBCell
            cell.startRebateButton.removeTarget(self, action: #selector(WBActivityDetailVC.onClickRetButtonAction(_:)), forControlEvents: .TouchUpInside)
            cell.startRebateButton.addTarget(self, action: #selector(WBActivityDetailVC.onClickRetButtonAction(_:)), forControlEvents: .TouchUpInside)
            cell.selectionStyle = .None
            return cell
      

        case 1:
            let activity = activityDetailBean!.data
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityRebatedDescTBCell", forIndexPath: indexPath) as! WBActivityRebatedDescTBCell
            cell.selectionStyle = .None
            
            let staTitle = "已有"
            let strDeal = activity.deal
            let endTitle = "用户成功返现"
            
            let attrStr = NSMutableAttributedString(string: "\(staTitle)\(strDeal)\(endTitle)")
            let range = NSRange(location: 0, length: staTitle.characters.count)
            attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexRGB(0x565060) , range: range)
            let rangeDeal = NSRange(location: staTitle.characters.count, length: strDeal.characters.count)
            attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexRGB(0xE95200) , range: rangeDeal)
            let rangeEnd = NSRange(location: staTitle.characters.count + staTitle.characters.count, length: endTitle.characters.count)
            attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexRGB(0x565060) , range: rangeEnd)
            cell.rebatedDescButton.setAttributedTitle(attrStr, forState: .Normal)
            return cell
            
        case 2:
            if 0 == indexPath.row {
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityInfoHeaderTBCell", forIndexPath: indexPath) as! WBActivityInfoHeaderTBCell
                cell.selectionStyle = .None
                cell.moreDetailButton.removeTarget(self, action: #selector(WBActivityDetailVC.onClickDetailActivity(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.moreDetailButton.addTarget(self, action: #selector(WBActivityDetailVC.onClickDetailActivity(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                return cell
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityInfoDescTBCell", forIndexPath: indexPath) as! WBActivityInfoDescTBCell
            cell.selectionStyle = .None
            configureCell(cell, atIndexPath: indexPath)
            //let beanArr = activityDetailBean!.data.info
            //cell.titleLabel.text = beanArr![indexPath.row - 1][0]
            //cell.dateLabel.text = beanArr![indexPath.row - 1][1]
            return cell
            
        case 3:
            
            
//            商户信息
            let shop = activityDetailBean!.shop
            if 0 == indexPath.row {
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityShopBriefTBCell", forIndexPath: indexPath) as! WBActivityShopBriefTBCell
                cell.selectionStyle = .None
                return cell
            }else if 1 == indexPath.row {
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityShopInfoTBCell", forIndexPath: indexPath) as! WBActivityShopInfoTBCell
                cell.selectionStyle = .None
                cell.titleLabel.text = shop.name
//                地址距离
//                cell.descLabel.text = WBUserManager.sharedInstance.getDistence(CLLocation(latitude: CLLocationDegrees(shop.mapX)!, longitude: CLLocationDegrees(shop.mapY)!))
                
                cell.descLabel.text = ""
                
                cell.callButton.removeTarget(self, action: #selector(WBActivityDetailVC.onCallPhone(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cell.callButton.addTarget(self, action: #selector(WBActivityDetailVC.onCallPhone(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                return cell
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityShopLocationTBCell", forIndexPath: indexPath) as! WBActivityShopLocationTBCell
            cell.selectionStyle = .None
            cell.locButton.setTitle(shop.address, forState: .Normal)
            return cell
            
        case 4:
            if 0 == indexPath.row {
                let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityMoreRebateBriefTBCell", forIndexPath: indexPath) as! WBActivityMoreRebateBriefTBCell
                cell.selectionStyle = .None
                return cell
            }
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBActivityRebateTBCell", forIndexPath: indexPath) as! WBActivityRebateTBCell
            cell.selectionStyle = .None
            let bean = activityLikeBean!.data[indexPath.row - 1]
            cell.configureShop(bean)
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func configureCell(cell: UITableViewCell ,atIndexPath indexPath: NSIndexPath) {
        cell.fd_enforceFrameLayout = false
        if (2 == indexPath.section) {
            let beanArr = activityDetailBean!.data.info
            let bean = beanArr![indexPath.row - 1]
            (cell as! WBActivityInfoDescTBCell).descBean = bean
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if 3 == indexPath.section {
            if 2 == indexPath.row {
                let shop = activityDetailBean!.shop
                let bean = CLLocationCoordinate2DMake(CLLocationDegrees(shop.mapX)!, CLLocationDegrees(shop.mapY)!)
                let vc = CSUIUtils.vcOfCommon("idtWBMapController") as! WBMapController
                vc.initWithClosureMap(bean, closure: { (isFinished) in
                })
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
        }
        if 4 == indexPath.section {
            if indexPath.row > 0 {
                let bean = activityLikeBean!.data[indexPath.row - 1]
                let vc = CSUIUtils.vcOfCommon("idtWBActivityDetailVC") as! WBActivityDetailVC
                vc.initWithClosureLike(bean, closure: { (isPurchase) in
                })
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
 
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if 0 == indexPath.row {
                return 94 + (330-94)*UIScreen.mainScreen().bounds.width/414
            }
            if 1 == indexPath.row {
                return 80
            }
            
            guard let _ = orderInfoBean else {
                if activityDetailBean != nil {
                    if "1" == activityDetailBean!.data.orderStatus {
                        return 300
                    }
                    if "2" == activityDetailBean!.data.orderStatus {
                        return 50
                    }
                }
                return 0
            }
            
            if "1" == orderInfoBean!.status {
                return 300
            }else if "1" == orderInfoBean!.status {
                return 50
            }
            
            return 0
            
        case 1:
            return 44
            
        case 2:
            if 0 == indexPath.row {
                return 44
            }
            return tableView.fd_heightForCellWithIdentifier("idtWBActivityInfoDescTBCell", cacheByIndexPath: indexPath, configuration: { ( cell: AnyObject!) in
                self.configureCell((cell as! WBActivityInfoDescTBCell), atIndexPath: indexPath)
            })
            //return 54
            
        case 3:
            if 0 == indexPath.row {
                return 44
            }else if 1 == indexPath.row {
                return 66
            }
            return 34
            
        case 4:
            if 0 == indexPath.row {
                return 44
            }
            return 88
            
        default:
            return 0
        }
    }
    
    
    func onClickRetButtonAction(sender: UIButton) {
        SVProgressHUD.showErrorWithStatus("不知道去哪里？")
    }
    
    @IBAction func onClickPurchaseButton(sender: AnyObject) {
        if !WBUserManager.sharedInstance.isUserLogined() {
            let vc = CSUIUtils.vcOfCommon("idtWBSignInVC") as! WBSignInVC
            vc.retLoginClosure = { [unowned self](isLogined: Bool) in
                if isLogined {
                    let vc = CSUIUtils.vcOfCommon("idtWBSubmitOrderVC") as! WBSubmitOrderVC
                    let bean = self.activityDetailBean!.data
                    vc.initWithClosureShop(bean) { (isPurchase) in
                        if isPurchase {
                        }
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return
            }
            let nav = WBBaseNavigationController(rootViewController: vc)
            self.presentViewController(nav, animated: true, completion: {
            })
        }else{
            guard let _ = activityDetailBean else {
                self.refreshCurView()
                return
            }
            let vc = CSUIUtils.vcOfCommon("idtWBSubmitOrderVC") as! WBSubmitOrderVC
            let bean = self.activityDetailBean!.data
            vc.initWithClosureShop(bean) { (isPurchase) in
                if isPurchase {
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onClickDetailActivity(sender: UIButton) {
        let vc = CSUIUtils.vcOfCommon("idtWBWebViewVC") as! WBWebViewVC
        vc.titleStr = "商品详情"
        vc.urlStr = activityDetailBean!.data.moreDetail
        let nav = WBBaseNavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: {
        })
    }
    
    func onCallPhone(send: UIButton) -> Void {
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(activityDetailBean!.shop.phone)")! )
    }
    
}
