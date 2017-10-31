//
//  WBBaseNavigationController.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//
// 导航类

import UIKit

class WBBaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    var isNeedSupportLandscape = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
        
        self.navigationBar.translucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor() ,NSFontAttributeName : UIFont.systemFontOfSize(18)]
        self.navigationBar.barStyle = UIBarStyle.Black;
      
        self.navigationBar.barTintColor = WBThemeColor//UIColor(red:0.102, green:0.698, blue:0.910, alpha:1)
        
//        self.navigationBar.barTintColor = UIColor.colorWithHexRGB(0x02ACCE)//UIColor(red:0.102, green:0.698, blue:0.910, alpha:1)

        
        self.view.backgroundColor = WBThemeColor//UIColor(red:0.102, green:0.698, blue:0.910, alpha:1)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1 {
            return false
        }
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if isNeedSupportLandscape {
            return .Default
        }
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return !isNeedSupportLandscape
    }
    
    override func shouldAutorotate() -> Bool {
        return !isNeedSupportLandscape
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if isNeedSupportLandscape {
            return UIInterfaceOrientationMask.Landscape
        }
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        if isNeedSupportLandscape {
            return UIInterfaceOrientation.LandscapeLeft
        }
        return UIInterfaceOrientation.Portrait
    }
    
}
