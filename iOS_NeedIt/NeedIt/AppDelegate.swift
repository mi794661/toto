//
//  AppDelegate.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate {

    var window: UIWindow?
    var _mapManager: BMKMapManager?
    
    //MARK: - BMKGeneralDelegate
    func onGetNetworkState(iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功");
        }
        else{
            NSLog("联网失败，错误代码：Error\(iError)");
        }
    }
    
    func onGetPermissionState(iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功");
        }
        else{
            NSLog("授权失败，错误代码：Error\(iError)");
        }
    }

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        WXApi.registerApp(WB_WeiXinKey, withDescription: WB_AppName)
        
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("aBCkm7EfckvKNQVqD8HgjIWHQ0l5f0A9", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if (url.host == "safepay"){
            //跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDic : [NSObject : AnyObject]!) -> Void in
                print("result =\(resultDic)");
            })
        }
        let isSuc = WXApi.handleOpenURL(url, delegate: WXApiManager.sharedManager())
        print("url:\(url)isSuc:\(isSuc == true)")
        return isSuc
    }

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let isSuc = WXApi.handleOpenURL(url, delegate: WXApiManager.sharedManager())
        print("url:\(url)isSuc:\(isSuc == true)")
        return isSuc
    }
    
}

