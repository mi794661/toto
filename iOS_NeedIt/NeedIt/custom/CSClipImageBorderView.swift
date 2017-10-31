//
//  CSClipImageBorderView.swift
//  Delicious
//
//  Created by Think on 16/1/27.
//  Copyright © 2016年 北京察知墨士品牌管理有限责任公司. All rights reserved.
//

import UIKit

class CSClipImageBorderView: UIView {
    
    var _cropRect: CGRect!
    var _imageView: UIImageView!
    
    override func awakeFromNib() {
        //super.awakeFromNib()
        opaque = false
        layer.opacity = 0.7
        backgroundColor = UIColor.clearColor()
        _imageView = UIImageView(frame: bounds)
        addSubview(_imageView)
        
        let screenW = UIScreen.mainScreen().bounds.size.width
        let wNeed = screenW
        let hNeed = (screenW*550)/1242
        _cropRect = CGRectMake(0, 50, wNeed, hNeed)
    }
    
    override func layoutSubviews() {
        _imageView.frame = self.bounds
        setCropRect(_cropRect)
    }
    
    func setCropRect(cropRect: CGRect) {
        _cropRect = cropRect;
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        UIColor.blackColor().setFill()
        UIRectFill(self.bounds)
        CGContextSetStrokeColorWithColor(context,  UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor)
        CGContextStrokeRect(context, _cropRect)
        UIColor.clearColor().setFill()
        UIRectFill(CGRectInset(_cropRect, 0, 0))
        _imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
}
