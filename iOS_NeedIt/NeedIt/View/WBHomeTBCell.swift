//
//  WBHomeTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/11.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class WBHomeTBCell: UITableViewCell {
    
    @IBOutlet weak var showView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var targetImageView: UIImageView!
    
    @IBOutlet weak var rebateInfoView: UIView!
    @IBOutlet weak var rebateBackImageView: UIImageView!
    @IBOutlet weak var rebateInfoLabel: UILabel!
    
    @IBOutlet weak var activityDescView: UIView!
    @IBOutlet weak var activityDescLabel: UILabel!
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var dateDescLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topView.backgroundColor = UIColor.clearColor()
        activityDescLabel.numberOfLines = 2
        showView.layer.cornerRadius = 5
        followButton.layer.cornerRadius = 2
        
        followButton.backgroundColor = UIColor.colorWithHexRGB(0xFF6D15)
        
        targetImageView.backgroundColor = UIColor.clearColor()
        
        let w = UIScreen.mainScreen().bounds.width
        let r = CGRect(x: 0, y: 0, width: w-16, height: (300-64)*w/414)
        let maskPath = UIBezierPath(roundedRect: r, byRoundingCorners:[UIRectCorner.TopLeft,UIRectCorner.TopRight], cornerRadii: CGSizeMake(4,4))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = r
        maskLayer.path = maskPath.CGPath
        targetImageView.layer.mask = maskLayer
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureShopCell(bean:WBNewShopBean) -> Void {
        let imageStr = bean.img
        targetImageView.sd_setImageWithURL(NSURL(string: imageStr), placeholderImage: UIImage(named: "imageDefault"), options: SDWebImageOptions.RefreshCached) { (image, error, cachType, url) -> Void in
            if nil === image {
                //imageV.image = UIImage(named: "imageDefault")
            }else{
                self.targetImageView.image = image
                //imageV.backgroundColor = UIColor.whiteColor()
            }
        }
        rebateInfoLabel.text = bean.toAccount
        activityDescLabel.text = bean.name
        titleNameLabel.text = "现金券价格\(bean.price)"
        dateDescLabel.text = "有效期:\(bean.time)"
    }
    
    
    func configureProductCell(bean:WBNewProductBean) -> Void {
        let imageStr = bean.img
        targetImageView.sd_setImageWithURL(NSURL(string: imageStr), placeholderImage: UIImage(named: "imageDefault"), options: SDWebImageOptions.RefreshCached) { (image, error, cachType, url) -> Void in
            if nil === image {
                //imageV.image = UIImage(named: "imageDefault")
            }else{
                self.targetImageView.image = image
                //imageV.backgroundColor = UIColor.whiteColor()
            }
        }
        rebateInfoLabel.text = bean.toAccount
        activityDescLabel.text = bean.name
        titleNameLabel.text = "现金券价格\(bean.price)"
        dateDescLabel.text = "有效期:\(bean.time)"
    }
    
    func configureBuildingCell(bean:WBNewBuildingBean) -> Void {
        let imageStr = bean.img
        targetImageView.sd_setImageWithURL(NSURL(string: imageStr), placeholderImage: UIImage(named: "imageDefault"), options: SDWebImageOptions.RefreshCached) { (image, error, cachType, url) -> Void in
            if nil === image {
                //imageV.image = UIImage(named: "imageDefault")
            }else{
                self.targetImageView.image = image
                //imageV.backgroundColor = UIColor.whiteColor()
            }
        }
        rebateInfoLabel.text = bean.toAccount
        activityDescLabel.text = bean.name
        titleNameLabel.text = "现金券价格\(bean.price)"
        dateDescLabel.text = "有效期:\(bean.time)"
    }
    
}
