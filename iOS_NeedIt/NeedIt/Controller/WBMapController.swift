//
//  WBMapController.swift
//  NeedIt
//
//  Created by Think on 16/4/6.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

typealias callBackWBMapController = (isFinished: Bool) -> Void

class WBMapController: WBBaseViewController,BMKMapViewDelegate {
    var _mapView: BMKMapView?
    private var bean2D:CLLocationCoordinate2D!
    var retMapClosure:callBackWBMapController?
    func initWithClosureMap(bean:CLLocationCoordinate2D,closure:callBackWBMapController?){
        retMapClosure = closure
        bean2D = bean
    }
    
    func onBackNavAction() {
        if navigationController?.viewControllers.count > 1 {
            navigationController?.popViewControllerAnimated(true)
        }else{
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "位置详情"
        CSUIUtils.configNavBarBackButton(self, selector:#selector(WBMapController.onBackNavAction))
        
        _mapView = BMKMapView(frame: self.view.bounds)
        self.view.addSubview(_mapView!)
        
        _mapView?.centerCoordinate = bean2D
        _mapView?.centerCoordinate
        _mapView?.trafficEnabled = false
        
        addCustomGesture()//添加自定义手势
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _mapView?.viewWillAppear()
        _mapView?.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapViewDidFinishLoading(mapView: BMKMapView!) {
    }
    
    // MARK: - 添加自定义手势 （若不自定义手势，不需要下面的代码）
    func addCustomGesture() {
        /*
         *注意：
         *添加自定义手势时，必须设置UIGestureRecognizer的cancelsTouchesInView 和 delaysTouchesEnded 属性设置为false，否则影响地图内部的手势处理
         */
        let tapGesturee = UITapGestureRecognizer(target: self, action: #selector(WBMapController.handleSingleTap(_:)))
        tapGesturee.cancelsTouchesInView = false
        tapGesturee.delaysTouchesEnded = false
        self.view.addGestureRecognizer(tapGesturee)
    }
    
    func handleSingleTap(tap: UITapGestureRecognizer) {
    }
    
}