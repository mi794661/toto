//
//  WBMainTabBarController.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBMainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        var vcs = [UIViewController]();
        vcs.append(CSUIUtils.vcOfHome("idtWBHomeNavigationController"))
        vcs.append(CSUIUtils.vcOfTask("idtWBTaskNavigationController"))
        vcs.append(CSUIUtils.vcOfMessage("idtWBMessageNavigationController"))
        vcs.append(CSUIUtils.vcOfMine("idtWBMineNavigationController"))
        
        self.setViewControllers(vcs, animated: false);
        
        self.selectedIndex = 0
        
        configAppGuideContentView()
        
        // 为了ios7
        self.tabBar.items![0].selectedImage = UIImage(named: "tab_home_s")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBar.items![1].selectedImage = UIImage(named: "tab_task_s")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBar.items![2].selectedImage = UIImage(named: "tab_message_s")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBar.items![3].selectedImage = UIImage(named: "tab_mine_s")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBar.items![0].image = UIImage(named: "tab_home_n")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBar.items![1].image = UIImage(named: "tab_task_n")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBar.items![2].image = UIImage(named: "tab_message_n")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBar.items![3].image = UIImage(named: "tab_mine_n")?.imageWithRenderingMode(.AlwaysOriginal)
        self.tabBar.items![0].title = "首页"
        self.tabBar.items![1].title = "任务库"
        self.tabBar.items![2].title = "消息"
        self.tabBar.items![3].title = "我的"
        
//        let backgroundImage = UIImage.imageFromColor(UIColor.whiteColor())
        let backgroundImage = UIImage.imageFromColor(UIColor.colorWithHexRGB(0xF5F5F5))
        self.tabBar.backgroundImage = backgroundImage
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: WBThemeColor], forState: .Selected)
        
        self.modalPresentationStyle = .CurrentContext;
        self.performSelector(#selector(WBMainTabBarController.doUpdateUserLocate), withObject: self, afterDelay: 1.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let controller = self.selectedViewController {
            return controller.preferredStatusBarStyle()
        }
        return .LightContent
    }
    
    var willChoosedIndex:Int = 0
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        willChoosedIndex = tabBarController.selectedIndex
        if 0 == willChoosedIndex {
            if !WBUserManager.sharedInstance.isUserLogined() {
                let navCur = viewController as! WBBaseNavigationController
                if navCur.viewControllers[0].isKindOfClass(WBMineVC) {
                    //willChoosedIndex = 3
                    return true
                }else if navCur.viewControllers[0].isKindOfClass(WBMessageVC) {
                    willChoosedIndex = 2
                }else if navCur.viewControllers[0].isKindOfClass(WBTaskVC) {
                    willChoosedIndex = 1
                }else{
                    willChoosedIndex = 0
                }
                let vc = CSUIUtils.vcOfCommon("idtWBSignInVC") as! WBSignInVC
                vc.retLoginClosure = { [unowned self](isLogined: Bool) in
                    if isLogined {
                        self.selectedIndex = self.willChoosedIndex
                    }
                    return
                }
                let nav = WBBaseNavigationController(rootViewController: vc)
                self.presentViewController(nav, animated: true, completion: {
                })
                return false
            }
        }
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
    }
    
    private lazy var locationManager:CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    private var isLocatedUserLocation:Bool =  false
    func doUpdateUserLocate() {
        var isLocatedOpen = false
        if CLLocationManager.locationServicesEnabled() {
            if (CLAuthorizationStatus.Denied == CLLocationManager.authorizationStatus()) {
            }else{
                isLocatedOpen = true
            }
        }
        
        if isLocatedOpen {
            if #available(iOS 8.0, *) {
                locationManager.requestWhenInUseAuthorization()
            } else {
                // Fallback on earlier versions
            }
            locationManager.startUpdatingLocationWithUpdateBlock({ (locMan:CLLocationManager!, loc: CLLocation!, err: NSError!, obj) -> Void in
                if self.isLocatedUserLocation {
                    locMan.stopUpdatingLocation()
                }
                
                if (nil === loc) {
                }else{
                    if !self.isLocatedUserLocation {
                        self.isLocatedUserLocation = true
                        let loc = CLLocation(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
                        WBUserManager.sharedInstance.userLocation = loc
                        locMan.stopUpdatingLocation()
                        print("获取到经纬度信息:\(loc.coordinate.latitude)  -> \(loc.coordinate.longitude)")
                        
                        let geocoder = CLGeocoder()
                        geocoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks: [CLPlacemark]?, error : NSError?) in
                            print("\(error)")
                            if((placemarks) != nil){
                                let place = placemarks![0]
                                var cityName = place.locality
                                if (cityName ?? "" ).isEmpty {
                                    cityName = place.administrativeArea
                                }
                                WBUserManager.sharedInstance.updateAppLocalCity(cityName!)
                                NSNotificationCenter.defaultCenter().postNotificationName(CSNSNotification_UserLocation_Update, object: nil)
                            }
                        })
                        
                        
                        
                    }
                }
                
            })
            
        }else{
        }
    }
    
}

extension WBMainTabBarController {
    private func configAppGuideContentView() -> Bool {
        var hasOverView = false
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey("has_show_app_guide") {
            if let view = NSBundle.mainBundle().loadNibNamed("CSAppGuideView", owner: nil, options: nil)[0] as? CSAppGuideView {
                self.view.addSubview(view)
                view.frame = self.view.frame
                //view.removedCallback = { [weak self] in
                    //self?.waitLoading()
                //}
                userDefaults.setBool(true, forKey: "has_show_app_guide")
                hasOverView = true
            }
        }
        return hasOverView
    }
    
    func gotoPay(bean: WBOrderInfoBean){
        print("进入支付:\(bean.dataId)")
        let vc = CSUIUtils.vcOfCommon("idtWBPayOrderVC") as! WBPayOrderVC
        vc.initWithClosurePayWithOrderInfo(bean, closure: { (isPaied) in
            if (isPaied) {
            }
        })
        let nav = WBBaseNavigationController(rootViewController: vc)
        presentViewController(nav, animated: false, completion: {
        })
    }
    
    func gotoActivityDetail(dataId: String,bean: WBOrderInfoBean? = nil ) {
        print("进入详情:\(dataId)")
        let vc = CSUIUtils.vcOfCommon("idtWBActivityDetailVC") as! WBActivityDetailVC
        vc.initWithClosureDetailId(dataId, orderBean: bean) { (isPurchase) in
        }
        let nav = WBBaseBlackNavigationController(rootViewController: vc)
        presentViewController(nav, animated: false, completion: {
        })
    }
    
    func gotoRebateVC(dataId: String){
        print("进入返利:\(dataId)")
        self.selectedIndex = 1
        
    }
    
}
