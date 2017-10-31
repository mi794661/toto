//
//  WBSignInLoginTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBSignInLoginTBCell: UITableViewCell {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loginButton.layer.cornerRadius = 4
        loginButton.backgroundColor = UIColor.colorWithHexRGB(0x02ACCE)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
