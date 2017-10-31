//
//  WBRegisterProtocolTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBRegisterProtocolTBCell: UITableViewCell {
    
    @IBOutlet weak var protocolButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let name = "我已阅读并同意 "
        let type = "需要么 服务条款"
        let attrStr = NSMutableAttributedString(string: "\(name)\(type)")
        let range = NSRange(location: 0, length: name.characters.count)
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorWithHexRGB(0x6A6A6A) , range: range)
        let rangeProtolol = NSRange(location: name.characters.count, length: type.characters.count)
        attrStr.addAttribute(NSForegroundColorAttributeName, value: WBThemeColor , range: rangeProtolol)
        protocolButton.setAttributedTitle(attrStr, forState: .Normal)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
