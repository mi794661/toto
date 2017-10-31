//
//  WBPlayRebateVideoVC.swift
//  NeedIt
//
//  Created by Think on 16/3/31.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

typealias callBackPlayRebateVideoVC = (isFinished: Bool) -> Void

class WBPlayRebateVideoVC: UIViewController {
    
    private var beanRebate:WBRebateBean!
    var retPlayRebateVideoClosure:callBackPlayRebateVideoVC?
    func initWithClosurePlayRebateVideo(bean:WBRebateBean,closure:callBackPlayRebateVideoVC?){
        retPlayRebateVideoClosure = closure
        beanRebate = bean
    }
    
    @IBOutlet weak var displayVideoView: UIView!
    @IBOutlet weak var sliderDisView: UISlider!
    @IBOutlet weak var timeDisLabel: UILabel!
    
    private var avPlayer:AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPlayUIView()
        doPlayAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.view.backgroundColor = UIColor.blackColor()
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
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    @IBAction func onClickBackButton(sender: AnyObject) {
        doExitVC()
    }
    
    func doExitVC() {
        unInitPlayUIView()
        self.dismissViewControllerAnimated(true) {
        }
    }
}

extension WBPlayRebateVideoVC {
    func unInitPlayUIView() {
        avPlayer.pause()
        for v in displayVideoView.subviews {
            v.removeFromSuperview()
        }
        removeNotification()
    }
    
    func initPlayUIView() {
        avPlayer = AVPlayer(URL: NSURL(string: beanRebate.url)! )
        let playerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = displayVideoView.layer.bounds;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        displayVideoView.layer.addSublayer(playerLayer)
    }
    
    func doPlayAction() {
        avPlayer.pause()
        avPlayer.play()
        
        removeNotification()
        addNotification()
        let playerItem = avPlayer.currentItem
        avPlayer.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: dispatch_get_main_queue()) { (time : CMTime) in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(playerItem!.duration)
            let pastDate = NSDate(timeIntervalSince1970: (total - current))
            self.timeDisLabel.text = self.getTimeByDate(pastDate, current:(total - current))
            
            let per = Float(current/total)
            self.sliderDisView.setValue( per, animated: false)
        }
    }
    
    func getTimeByDate(date:NSDate ,current:Float64) -> String {
        let formatter = NSDateFormatter()
        if current/3600 >= 1 {
            formatter.dateFormat = "HH:mm:ss"
            
        }
        else{
            formatter.dateFormat = "mm:ss"
        }
        return formatter.stringFromDate(date)
    }
    
    func removeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WBPlayRebateVideoVC.playbackFinished(_:)),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification, object: avPlayer.currentItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WBPlayRebateVideoVC.didBecomeActive(_:)),
                                                         name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func playbackFinished(noctice:NSNotification) {
        print("执行申请返利操作:")
        requestVideoRebateContent()
    }
    
    func didBecomeActive(noctice:NSNotification) {
        doPlayAction()
    }
    
}

extension WBPlayRebateVideoVC {
    private func requestVideoRebateContent() {
        let urlStr = WBNetManager.sharedInstance.getVideoRebateURL()
        print("视频（完整观看后）返利:\(urlStr)")
        let token = WBUserManager.sharedInstance.appLocalToken()
        let dicPost = NSDictionary(objects: [token,beanRebate.oid,beanRebate.dataId], forKeys: ["token","oid","vid"])
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            let lBean = WBParseNetBase(json: json)
            if isSuccess {
                if 1 == lBean.code {
                    self.doExitVC()
                    SVProgressHUD.showSuccessWithStatus("成功返利~")
                }
                return
            }
            if isFailure {
            }
            let msg = lBean.msg.isEmpty ? "网络失败~" : lBean.msg
            SVProgressHUD.showErrorWithStatus(msg)
            
            if 16 == lBean.code {
                self.doPlayAction()
            }
            
        }
    }
    
}
