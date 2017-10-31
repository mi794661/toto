//
//  WBActivityInfoDescTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/10.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBActivityInfoDescTBCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.numberOfLines = 0
        dateLabel.numberOfLines = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var descBean: [String]! {
        didSet{
            titleLabel.text = descBean[0]
            dateLabel.text = descBean[1]
        }
    }
}
