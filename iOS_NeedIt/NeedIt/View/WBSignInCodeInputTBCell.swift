//
//  WBSignInCodeInputTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBSignInCodeInputTBCell: UITableViewCell {
    
    @IBOutlet weak var codeInputTextView: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        codeInputTextView.backgroundColor = UIColor.whiteColor()
        codeInputTextView.layer.cornerRadius = 4
        codeInputTextView.layer.borderColor = UIColor.colorWithHexRGB(0xD9D9D9).CGColor
        codeInputTextView.layer.borderWidth = 1
        
        codeInputTextView.leftViewMode = .Always
        let vL = UIView(frame: CGRect(x: 2, y: 0, width: 10, height: codeInputTextView.bounds.height) )
        codeInputTextView.leftView = vL
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
