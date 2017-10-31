//
//  WBPayOrderPayNowTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/9.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBPayOrderPayNowTBCell: UITableViewCell {

    @IBOutlet weak var payNowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        payNowButton.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
