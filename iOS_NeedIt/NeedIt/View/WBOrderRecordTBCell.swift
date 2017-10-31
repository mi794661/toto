//
//  WBOrderRecordTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//
//  订单列表视图
import UIKit

class WBOrderRecordTBCell: UITableViewCell {
    
    @IBOutlet weak var showView: UIView!
    @IBOutlet weak var orderDetailLabel: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var retDetailLable: UILabel!
    
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var retButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showView.layer.cornerRadius = 4
        retButton.layer.cornerRadius = 4
        titleLable.numberOfLines = 2
        showImageView.backgroundColor = UIColor.redColor()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(bean:WBOrderInfoBean) -> Void {
        orderDetailLabel.text = "订单编号: \(bean.tradeCode)"
        orderDetailLabel.textColor = UIColor.blackColor()
        titleLable.text = bean.name
        retDetailLable.text = bean.total
        let imageStr = bean.img
        
        showImageView.sd_setImageWithURL(NSURL(string: imageStr), placeholderImage: UIImage(named: "imageDefault"), options: SDWebImageOptions.RefreshCached) { (image, error, cachType, url) -> Void in
            if nil === image {
                //imageV.image = UIImage(named: "imageDefault")
            }else{
                self.showImageView.image = image
                //imageV.backgroundColor = UIColor.whiteColor()
            }
        }
//        showImageView.backgroundColor = UIColor.blackColor()
        if "0" == bean.status {
            retButton.setTitle("立即支付", forState: .Normal)
        }else if "1" == bean.status {
            retButton.setTitle("查看优惠码", forState: .Normal)
        }else if "2" == bean.status {
            retButton.setTitle("立即返现", forState: .Normal)
        }        
        //0的时候显示立即支付，1的时候显示查看优惠码，2的时候显示立即返现
        //状态是1或者2的时候，应该是支付成功的那个详情页的页面，但是现在还是最开始的那个未支付的详情页
    }
}
