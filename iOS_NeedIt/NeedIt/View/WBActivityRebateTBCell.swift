//
//  WBActivityRebateTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/10.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBActivityRebateTBCell: UITableViewCell {
    
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.numberOfLines = 2
        tagImageView.backgroundColor = UIColor.lightGrayColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureShop(bean:WBActivityProductLikeBean) -> Void {
        let imageStr = bean.img
        tagImageView.sd_setImageWithURL(NSURL(string: imageStr), placeholderImage: UIImage(named: "imageDefault"), options: SDWebImageOptions.RefreshCached) { (image, error, cachType, url) -> Void in
            if nil === image {
                //imageV.image = UIImage(named: "imageDefault")
            }else{
                self.tagImageView.image = image
                //imageV.backgroundColor = UIColor.whiteColor()
            }
        }
        titleLabel.text = bean.name
        descLabel.text = "现金券价格\(bean.price)"
        
    }
    
}
