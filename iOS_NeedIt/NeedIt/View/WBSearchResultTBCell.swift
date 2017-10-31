//
//  WBSearchResultTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/24.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBSearchResultTBCell: UITableViewCell {
    
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var buyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.numberOfLines = 2
        buyButton.layer.cornerRadius = 4
        displayImageView.backgroundColor = UIColor.redColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(bean:WBDataBaseBean) -> Void {
        let imageStr = bean.img
        displayImageView.sd_setImageWithURL(NSURL(string: imageStr), placeholderImage: UIImage(named: "imageDefault"), options: SDWebImageOptions.RefreshCached) { (image, error, cachType, url) -> Void in
            if nil === image {
                //imageV.image = UIImage(named: "imageDefault")
            }else{
                self.displayImageView.image = image
                //imageV.backgroundColor = UIColor.whiteColor()
            }
        }
        titleLabel.text = bean.name
        activityLabel.text = "现金券价格\(bean.price)"
        
    }
}
