//
//  WBQuestionNaireHeaderTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/30.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBQuestionNaireHeaderTBCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var orderDetailLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        orderDetailLabel.numberOfLines = 2
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(bean:WBOrderInfoBean) -> Void { 
        orderNumLabel.text = "订单编号:\(bean.tradeCode)"
        orderDetailLabel.text = bean.name
        let imageStr = bean.img
        
        coverImageView.sd_setImageWithURL(NSURL(string: imageStr), placeholderImage: UIImage(named: "imageDefault"), options: SDWebImageOptions.RefreshCached) { (image, error, cachType, url) -> Void in
            if nil === image {
                //imageV.image = UIImage(named: "imageDefault")
            }else{
                self.coverImageView.image = image
                //imageV.backgroundColor = UIColor.whiteColor()
            }
        }
        
    }
    
}
