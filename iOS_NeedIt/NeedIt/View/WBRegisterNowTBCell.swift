//
//  WBRegisterNowTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBRegisterNowTBCell: UITableViewCell {
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        signInButton.layer.cornerRadius = 4
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}