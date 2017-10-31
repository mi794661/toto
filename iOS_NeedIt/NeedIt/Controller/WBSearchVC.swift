//
//  WBSearchVC.swift
//  NeedIt
//
//  Created by Think on 16/3/24.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBSearchVC: WBBaseTableViewController {
    private var textField: UITextField? = nil
    private var searchNav: WBSearchNavView!
    
    private var hotKeyBeanList = [WBSearchKeyBean]()
    private var resultBeanList = [WBDataBaseBean]()
    
    private var showType:Int = 0 { //0  HotKey; 1 NoMathed; 2 Matched
        didSet {
            if  0 == self.showType {
                self.tableView.scrollEnabled = false
            }else if 1 == self.showType {
                self.tableView.scrollEnabled = true
            }else {
                self.tableView.scrollEnabled = true
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CSUIUtils.configNavBarBackWhiteButton(self, selector:#selector(WBSearchVC.onBackNavAction))
        
        //.Nav
        var rShow = self.navigationController?.navigationBar.bounds
        let vShow = NSBundle.mainBundle().loadNibNamed("WBSearchNavView", owner: nil, options: nil)[0] as! WBSearchNavView
        rShow!.origin.x = 40 + 10
        rShow!.size.width -= (40 + 20)
        vShow.frame = rShow!
        self.navigationController?.navigationBar.addSubview(vShow)
        searchNav = vShow
        searchNav.textInputFileld.delegate = self
        
        let yPos = (self.navigationController?.navigationBar.frame.origin.x)! + (self.navigationController?.navigationBar.bounds.height)!
        let line = UIImageView(frame: CGRect(x: 0, y:yPos, width: UIScreen.mainScreen().bounds.width, height: 1))
        line.backgroundColor = UIColor.colorWithHexRGB(0xCCCCCC)
        self.navigationController?.navigationBar.addSubview(line)
        
        tableView.tableFooterView = UIView()
        
        requestHotKeyContent()
    }
    
    func onBackNavAction() {
        textField?.resignFirstResponder()
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
    
}

extension WBSearchVC: UITextFieldDelegate {
    @IBAction func onTapAction(sender: AnyObject) {
        hideKeyboard()
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
        print("当前:\(textField.text)")
        let strToSearch = textField.text
        if strToSearch!.isEmpty {
        }
        self.textField = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let strToSearch = textField.text
        if strToSearch!.isEmpty {
            return true
        }
        requestSearchKeyContent(strToSearch!)
        return true
    }
}

extension WBSearchVC: CellWBSearchKeyWordTBDelegate {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section {
            if 1 == showType {
                return 1
            }
            return 0
        }else if 1 == section {
            if 0 == showType  {
                return 1
            }
            return 0
        }
        if 2 == showType || 1 == showType  {
            return resultBeanList.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if 0 == indexPath.section {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSearchPromoteTBCell", forIndexPath: indexPath) as! WBSearchPromoteTBCell
            cell.selectionStyle = .None
            return cell
        }
        if 1 == indexPath.section {
            let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSearchKeyWordTBCell", forIndexPath: indexPath) as! WBSearchKeyWordTBCell
            cell.configureCell(hotKeyBeanList)
            cell.cellDelegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("idtWBSearchResultTBCell", forIndexPath: indexPath) as! WBSearchResultTBCell
        cell.selectionStyle = .None
        let bean = resultBeanList[indexPath.row]
        cell.configureCell(bean)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if 0 == indexPath.section {
            return 44
        }
        if 1 == indexPath.section {
            return UIScreen.mainScreen().bounds.height - ((self.navigationController?.navigationBar.frame.origin.y)! + (self.navigationController?.navigationBar.frame.size.height)!)
        }
        return 116
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if 0 == indexPath.section {
        }
        if 2 == indexPath.section {
            let bean = resultBeanList[indexPath.row]
            print("进入|\(bean.name):\(bean.dataId)")
            
            let vc = CSUIUtils.vcOfCommon("idtWBActivityDetailVC") as! WBActivityDetailVC
            vc.initWithClosureDetailId(bean.dataId) { (isPurchase) in
            }
            let nav = WBBaseBlackNavigationController(rootViewController: vc)
            self.presentViewController(nav, animated: false, completion: {
            })
        }
    }
    
    func callBackSelectItem(indexPath:NSIndexPath) {
        let bean = hotKeyBeanList[indexPath.section*4 + indexPath.row]
        print("名称:\(bean.slogan)")
        searchNav.textInputFileld?.text = bean.slogan
        requestSearchKeyContent(bean.slogan)
    }
}

extension WBSearchVC {
    private func requestHotKeyContent() {
        let urlStr = WBNetManager.sharedInstance.getHotKeyURL()
        print("热词::\(urlStr)")
        WBNetManager.sharedInstance.requestByPost(urlStr, params:nil) { (isSuccess, isFailure, json, error) -> Void in
            let retoBJ = WBParseNetBase(json: json)
            if isSuccess {
                var numRec = 0
                if retoBJ.isDataOk() {
                    if retoBJ.data.isKindOfClass(NSNull){
                    }else{
                        self.resultBeanList.removeAll()
                        let retArr = retoBJ.data as! NSArray
                        numRec = retArr.count
                        if numRec > 0 {
                            for obj in retArr {
                                self.hotKeyBeanList.append( WBSearchKeyBean(json: JSON(obj)) )
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
                return
            }
            if isFailure {
            }
            self.showType = 0
            SVProgressHUD.showErrorWithStatus(retoBJ.msg ?? "网络失败~")
        }
    }
    
    private func requestSearchKeyContent(searchStr: String) {
        let urlStr = WBNetManager.sharedInstance.getSearchKeyURL()
        print("搜索关键字:\(urlStr):\(searchStr)")
        let dicPost = NSDictionary(objects: [searchStr], forKeys: ["search"])
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            let retoBJ = WBParseNetBase(json: json)
            if isSuccess {
                var numRec = 0
                if retoBJ.isDataOk() {
                    if retoBJ.data.isKindOfClass(NSNull){
                    }else{
                        self.resultBeanList.removeAll()
                        let retArr = retoBJ.data as! NSArray
                        numRec = retArr.count
                        if numRec > 0 {
                            for obj in retArr {
                                self.resultBeanList.append( WBDataBaseBean(json: JSON(obj)) )
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
                
                self.showType = 2
                return
                
            }
            if isFailure {
            }
            
            if 8 == retoBJ.code {
                if retoBJ.data.isKindOfClass(NSNull){
                }else{
                    self.resultBeanList.removeAll()
                    let retArr = retoBJ.data as! NSArray
                    var numRec = 0
                    numRec = retArr.count
                    if numRec > 0 {
                        for obj in retArr {
                            self.resultBeanList.append( WBDataBaseBean(json: JSON(obj)) )
                        }
                    }
                    self.tableView.reloadData()
                }
                self.showType = 1
                
            }else{
                SVProgressHUD.showErrorWithStatus(retoBJ.msg ?? "网络失败~")
            }
            
        }
    }
    
}
