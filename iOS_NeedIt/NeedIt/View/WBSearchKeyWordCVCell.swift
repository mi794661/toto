//
//  WBSearchKeyWordCVCell.swift
//  NeedIt
//
//  Created by Think on 16/3/24.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBSearchKeyWordCVCell: UICollectionViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.backgroundColor = UIColor.colorWithHexRGB(0xF1F2F6).CGColor
        self.layer.cornerRadius = 3
    }
}
