//
//  WBMyWalletBriefTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBMyWalletBriefTBCell: UITableViewCell {

    @IBOutlet weak var showBackImageView: UIImageView!
    @IBOutlet weak var moneyLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showBackImageView.layer.cornerRadius = showBackImageView.bounds.width/2
        showBackImageView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
