//
//  WBActivityStartRebateTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/10.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBActivityStartRebateTBCell: UITableViewCell {

    @IBOutlet weak var startRebateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startRebateButton.layer.cornerRadius = 4
        startRebateButton.setTitle("开始返现", forState: .Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
