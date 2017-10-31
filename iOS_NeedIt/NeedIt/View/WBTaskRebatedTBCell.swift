//
//  WBTaskRebatedTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBTaskRebatedTBCell: UITableViewCell {
    
    @IBOutlet weak var showView: UIView!
    
    @IBOutlet weak var titleNameLable: UILabel!
    @IBOutlet weak var rebateInfoLable: UILabel!
    @IBOutlet weak var orderSourceLabel: UILabel!
    
    @IBOutlet weak var rebateImageView: UIImageView!
    @IBOutlet weak var coverView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showView.layer.cornerRadius = 5
        coverView.layer.cornerRadius = 5
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureCell(bean:WBRebateBean) -> Void {
        if 1 == bean.type {
            titleNameLable.text = "观看视频"
            rebateInfoLable.text = bean.name
            orderSourceLabel.text = bean.product
        }else{
            titleNameLable.text = "问卷调查"
            rebateInfoLable.text = ""
            orderSourceLabel.text = bean.name
        }
        
        orderSourceLabel.text = bean.product
        let imageStr = bean.img
        
        rebateImageView.sd_setImageWithURL(NSURL(string: imageStr), placeholderImage: UIImage(named: "imageDefault"), options: SDWebImageOptions.RefreshCached) { (image, error, cachType, url) -> Void in
            if nil === image {
                //imageV.image = UIImage(named: "imageDefault")
            }else{
                self.rebateImageView.image = image
                //imageV.backgroundColor = UIColor.whiteColor()
            }
        }
        
    }
    
}
