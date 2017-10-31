//
//  WBSubmitOrderNumberTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBSubmitOrderNumberTBCell: UITableViewCell {

    @IBOutlet weak var titleNameLable: UILabel!
    @IBOutlet weak var reduceButton: UIButton!
    @IBOutlet weak var textFieldView: UITextField!
    @IBOutlet weak var plusButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.borderColor = UIColor.colorWithHexRGB(0xDDDDDD).CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
