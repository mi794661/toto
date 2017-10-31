//
//  WBSignInNameInputTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBSignInNameInputTBCell: UITableViewCell {
    
    @IBOutlet weak var nameInputTextView: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameInputTextView.backgroundColor = UIColor.whiteColor()
        nameInputTextView.layer.cornerRadius = 4
        nameInputTextView.layer.borderColor = UIColor.colorWithHexRGB(0xD9D9D9).CGColor
        nameInputTextView.layer.borderWidth = 1
        
        nameInputTextView.leftViewMode = .Always
        let vL = UIView(frame: CGRect(x: 2, y: 0, width: 10, height: nameInputTextView.bounds.height) )
        nameInputTextView.leftView = vL
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
