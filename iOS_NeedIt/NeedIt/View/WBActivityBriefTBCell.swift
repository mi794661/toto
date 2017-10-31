//
//  WBActivityBriefTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/10.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//
//详情

import UIKit

class WBActivityBriefTBCell: UITableViewCell {

    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var rebateInfoLabel: UILabel!
    @IBOutlet weak var rebateTimeLabel: UILabel!
    @IBOutlet weak var rebateOrgInfoLabel: UILabel!
    
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rebateTimeLabel.layer.cornerRadius = 2
        rebateTimeLabel.layer.backgroundColor = WBRedColor.CGColor
        
        statusImageView.hidden = true
        statusImageView.image = UIImage(named: "ywcdd_icon_yzf")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(bean:WBActivityInfoBean) -> Void {
        let imageStr = bean.img
        activityImageView.sd_setImageWithURL(NSURL(string: imageStr), placeholderImage: UIImage(named: "imageDefault"), options: SDWebImageOptions.RefreshCached) { (image, error, cachType, url) -> Void in
            if nil === image {
                //imageV.image = UIImage(named: "imageDefault")
            }else{
                self.activityImageView.image = image
                //imageV.backgroundColor = UIColor.whiteColor()
            }
        }
        
        activityNameLabel.text = bean.name
        rebateInfoLabel.text = "现金券价格\(bean.price)"
        rebateTimeLabel.text = " \(bean.toAccount) "
        rebateOrgInfoLabel.text = "剩余库存: \(bean.surplus)"//"(\(bean.surplus)/\(bean.storage))"
        
        if "1" == bean.orderStatus {
            statusImageView.hidden = false
        }
        
    }
    
    
}
