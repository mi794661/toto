//
//  WBFinancialRecordsTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBFinancialRecordsTBCell: UITableViewCell {
    
    @IBOutlet weak var dateDetailLabel: UILabel!
    @IBOutlet weak var detailNumLable: UILabel!
    @IBOutlet weak var typeClassLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailNumLable.textColor = WBRedColor
        typeClassLable.textColor = WBGreenColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(bean:WBFinancialRecordBean) -> Void {
        //1=返现（UI红色字）
        //2=提现（UI绿色字）
        var infoStr = ""
        if 1 == bean.type {
            typeClassLable.text = "返现"
            typeClassLable.textColor = UIColor.colorWithHexRGB(0x6FBE4D)
            detailNumLable.textColor = UIColor.colorWithHexRGB(0x6FBE4D)
            infoStr = "+\(bean.total)"
        }else{
            typeClassLable.text = "提现"
            typeClassLable.textColor = UIColor.colorWithHexRGB(0xE95200)
            detailNumLable.textColor = UIColor.colorWithHexRGB(0xE95200)
            infoStr = "-\(bean.total)"
        }
        
        detailNumLable.text = infoStr
        dateDetailLabel.text = bean.time
        
    }
    
    
}
