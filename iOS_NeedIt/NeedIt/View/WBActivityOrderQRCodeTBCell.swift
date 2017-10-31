//
//  WBActivityOrderQRCodeTBCell.swift
//  NeedIt
//
//  Created by Think on 16/4/5.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBActivityOrderQRCodeTBCell: UITableViewCell {
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(tradeCode:String) -> Void {
        qrImageView.image = QRCode.qrImageForString(tradeCode, imageSize: qrImageView.bounds.size.width)
    }
    
    
}
