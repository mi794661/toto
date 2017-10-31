//
//  CSInputSendView.swift
//  Delicious
//
//  Created by Think on 15/12/31.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class CSInputSendView: UIView {
    
    @IBOutlet weak var textInputView: UITextView!
    @IBOutlet weak var viewCoverButton: UIButton!
    
    @IBOutlet weak var topLineView: UIImageView!
    @IBOutlet weak var buttomLineView: UIImageView!
    
    @IBOutlet weak var topLineViewConns: NSLayoutConstraint!
    @IBOutlet weak var buttomLineViewConns: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textInputView.layer.cornerRadius = 8
        textInputView.layer.borderWidth = 0.5
        textInputView.layer.borderColor = CSUIUtils.ColorCircleEdgeLineView.CGColor
        textInputView.returnKeyType = .Send
        let co = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1)
        textInputView.backgroundColor = co
        backgroundColor = co
        
        topLineView.backgroundColor = UIColor(red:0.79, green:0.79, blue:0.79, alpha:1)
        buttomLineView.backgroundColor = UIColor(red:0.79, green:0.79, blue:0.79, alpha:1)
        topLineViewConns.constant = 0.4
        buttomLineViewConns.constant = 0.4
    }
    
}