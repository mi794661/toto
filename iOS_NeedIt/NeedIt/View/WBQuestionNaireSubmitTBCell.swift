//
//  WBQuestionNaireSubmitTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/30.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBQuestionNaireSubmitTBCell: UITableViewCell {

    @IBOutlet weak var submitButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()    
        submitButton.layer.cornerRadius = 4
        submitButton.backgroundColor = UIColor.colorWithHexRGB(0xFB2B3C)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
