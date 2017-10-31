//
//  WBMyWalletInputTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBMyWalletInputTBCell: UITableViewCell {

    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textInputField.backgroundColor = UIColor.whiteColor()
        textInputField.layer.cornerRadius = 4
        textInputField.layer.borderColor = UIColor.colorWithHexRGB(0xD9D9D9).CGColor
        textInputField.layer.borderWidth = 1
        
        textInputField.leftViewMode = .Always
        let vL = UIView(frame: CGRect(x: 10, y: 0, width: 80 + 10, height: textInputField.bounds.height) )
        vL.backgroundColor = UIColor.clearColor()
        textInputField.leftView = vL
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
