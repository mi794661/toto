//
//  WBSearchNavView.swift
//  NeedIt
//
//  Created by Think on 16/4/1.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBSearchNavView: UIView {

    @IBOutlet weak var textInputFileld: UITextField!

    override func awakeFromNib() {
        textInputFileld.backgroundColor = UIColor.whiteColor()
        textInputFileld.layer.cornerRadius = 4
        textInputFileld.layer.borderColor = UIColor.colorWithHexRGB(0xD9D9D9).CGColor
        textInputFileld.layer.borderWidth = 1
        
        textInputFileld.leftViewMode = .Always
        let vL = UIImageView(frame: CGRect(x: (40-16)/2, y: (44-16)/2, width: 16, height: 16) )
        let bv = UIView(frame: CGRect(x: 2, y: 2, width: 40, height: 40) )
        vL.image = UIImage(named: "ss_icon")
        bv.addSubview(vL)
        textInputFileld.leftView = bv
    }
    
}
