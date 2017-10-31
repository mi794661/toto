//
//  WBScanQRCodeVC.swift
//  NeedIt
//
//  Created by Think on 16/3/31.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBScanQRCodeVC: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var scanLineView: UIImageView!
    
    private var num:Int = 0
    private var upOrdown:Bool = false
    private var timer:NSTimer?
    
    
    private var device: AVCaptureDevice?
    private var input: AVCaptureDeviceInput?
    private var output: AVCaptureMetadataOutput?
    private var session: AVCaptureSession?
    private var preview: AVCaptureVideoPreviewLayer?
    
    private var tradeCodeDeal: String?
    private var isExceDeal: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        //if (AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) != nil) {
        //    dispatch_async(dispatch_get_main_queue(), {
        //        self.setUpCamera()
        //    })
        //}
        //else{
        //    let alertView = UIAlertView(title: "提醒", message: "手机系统不支持扫描", delegate: nil, cancelButtonTitle: "确认")
        //    alertView.show()
        //}
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) != nil) {
            
            dispatch_async(dispatch_get_main_queue(), {
                self.setUpCamera()
            })
            
        }else{
            let alertView = UIAlertView(title: "提醒", message: "手机系统不支持扫描", delegate: nil, cancelButtonTitle: "确认")
            alertView.show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onBackNavAction() {
        tearDownCamera()
        if navigationController?.viewControllers.count > 1 {
            navigationController?.popViewControllerAnimated(true)
        }else{
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }
    
}

extension WBScanQRCodeVC: AVCaptureMetadataOutputObjectsDelegate {
    func tearDownCamera() {
        timer?.invalidate()
        session?.stopRunning()
        preview?.removeFromSuperlayer()
    }
    
    func setUpCamera() {
        device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if let inputTmp = try? AVCaptureDeviceInput(device: device) {
            input = inputTmp
            
            output = AVCaptureMetadataOutput()
            output?.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            session = AVCaptureSession()
            session?.canSetSessionPreset(AVCaptureSessionPresetHigh)
            
            
            if ((session?.canAddInput(input)) != nil) {
                session?.addInput(input)
            }
            if session!.canAddOutput(output) {
                session?.addOutput(output)
            }
            //条码类型，AVMetadataObjectTypeQRCode
            output!.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            //Preview
            preview = AVCaptureVideoPreviewLayer.init(session: session)
            preview!.videoGravity = AVLayerVideoGravityResizeAspectFill;
            preview!.frame = CGRectMake(0, 0, videoView.frame.size.width, videoView.frame.size.height);
            videoView.layer.insertSublayer(preview!, atIndex: 0)
            
            //start
            session?.startRunning()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: #selector(WBScanQRCodeVC.scanLineAnimation), userInfo: nil, repeats: true)
        
    }
    
    func scanLineAnimation() -> Void {
        let rScanView = scanView.frame
        var rScanLine = scanLineView.frame
        if (upOrdown == false) {
            num += 1
            rScanLine.origin.y += CGFloat( CGFloat(num*15)/CGFloat(1.0*UIScreen.mainScreen().bounds.height) )
            scanLineView.frame = rScanLine
            if rScanLine.origin.y >= rScanView.height - 5 {//+rScanView.origin.y
                upOrdown = true
                num = 0
            }
        }
        else {
            num -= 1
            rScanLine.origin.y += CGFloat( CGFloat(num*15)/CGFloat(1.0*UIScreen.mainScreen().bounds.height) )
            scanLineView.frame = rScanLine
            if rScanLine.origin.y <= 0 + 5 {//if 0 == num {
                num = 0
                upOrdown = false
            }
        }
        
    }
    
    func initView() {
        navigationItem.title = "扫一扫交易"
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBQuestionNaireVC.onBackNavAction))
        scanView.backgroundColor = UIColor.clearColor()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            print("扫描返回:\(metadataObject.stringValue)")
            
            guard let code = tradeCodeDeal else {
                tradeCodeDeal = metadataObject.stringValue
                self.requestQuestionAnswerContent(self.tradeCodeDeal!)
                return
            }
            if (metadataObject.stringValue as NSString).isEqualToString(code) {
            }else{
                if !isExceDeal {
                    tradeCodeDeal = metadataObject.stringValue
                    requestQuestionAnswerContent(tradeCodeDeal!)
                }
            }
            
        }else{
            print("扫描ing....")
        }
    }
    
    
    private func requestQuestionAnswerContent(code: String) {
        SVProgressHUD.showWithStatus("正在处理....")
        
        let urlStr = WBNetManager.sharedInstance.getOrderDealURL()
        print("成交:\(urlStr)")//{"qid": "2","oid": "5","token": "1581132815511111458563578"}
        let token = WBUserManager.sharedInstance.appLocalToken()
        let tradeCode = code
        let dicPost = NSDictionary(objects: [token, tradeCode], forKeys: ["token","trade_code"])
        WBNetManager.sharedInstance.requestByPost(urlStr, params:(dicPost as NSDictionary).JSONString() ) { (isSuccess, isFailure, json, error) -> Void in
            self.isExceDeal = false
            
            let retObj = WBParseNetBase(json: json)
            if isSuccess {
                if retObj.isDataOk() {
                    //SVProgressHUD.showSuccessWithStatus(retObj.msg ?? "交易成功~" )
                    SVProgressHUD.showSuccessWithStatus("交易成功~")
                    SVProgressHUD.dismissWithDelay(1.5)
                    self.isExceDeal = false
                    return
                }
            }
            if isFailure {
            }
            
            SVProgressHUD.showErrorWithStatus(retObj.msg ?? "交易失败~" )
            SVProgressHUD.dismissWithDelay(1.5)
        }
    }
}
