//
//  WBHomeNavView.swift
//  NeedIt
//
//  Created by Think on 16/3/11.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

// 首页导航栏


import UIKit

class WBHomeNavView: UIView {

    @IBOutlet weak var scrollTitleLabel: MarqueeLabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    

    override func awakeFromNib() {
        scrollTitleLabel.marqueeType = .MLContinuous
        scrollTitleLabel.textAlignment = .Left
        scrollTitleLabel.lineBreakMode = .ByTruncatingHead
        scrollTitleLabel.scrollDuration = 15.0
        scrollTitleLabel.animationCurve = .CurveEaseInOut
        scrollTitleLabel.fadeLength = 10.0
        scrollTitleLabel.leadingBuffer = 30.0
        scrollTitleLabel.trailingBuffer = 20.0

        
        locationButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
}
