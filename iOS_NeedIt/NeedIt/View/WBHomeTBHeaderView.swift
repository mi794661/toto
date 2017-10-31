//
//  WBHomeTBHeaderView.swift
//  NeedIt
//
//  Created by Think on 16/3/11.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

typealias noneParamsHomeHeaderFooterViewCallFunc = (isIndex: Int) -> Void

class WBHomeTBHeaderView: UITableViewHeaderFooterView {
    var callFunc: noneParamsHomeHeaderFooterViewCallFunc?
    
    @IBOutlet weak var newShopButton: UIButton!
    @IBOutlet weak var newProductButton: UIButton!
    @IBOutlet weak var newbuildingButton: UIButton!
    
    @IBOutlet weak var slideBottomImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slideBottomImageView.layer.cornerRadius = 2
        newShopButton.selected = true
        
        newShopButton.setTitleColor(UIColor.colorWithHexRGB(0x666666), forState: .Normal)
        newProductButton.setTitleColor(UIColor.colorWithHexRGB(0x666666), forState: .Normal)
        newbuildingButton.setTitleColor(UIColor.colorWithHexRGB(0x666666), forState: .Normal)
        newShopButton.setTitleColor(UIColor.colorWithHexRGB(0x1AB2E8)
            , forState:.Selected)
        newProductButton.setTitleColor(WBThemeColor, forState:.Selected)


    }
    
    func slideSectionViewButton(sender: AnyObject) -> Void {
        var center = slideBottomImageView.center
        let rect = slideBottomImageView.frame
        let nowFrame:CGRect = rect
        var targetFrame:CGRect = rect
        
        switch sender.tag {
        case 1001:
            newShopButton.selected = true
            newProductButton.selected = false
            newbuildingButton.selected = false
            
            center.x =  bounds.width/6
            targetFrame = CGRectMake(abs(center.x - rect.size.width * 0.5), center.y - rect.size.height * 0.5, rect.size.width, rect.size.height )
            break
        case 1002:
            newShopButton.selected = false
            newProductButton.selected = true
            newbuildingButton.selected = false
            
            center.x =  bounds.width/2
            targetFrame = CGRectMake(abs(center.x - rect.size.width * 0.5), center.y - rect.size.height * 0.5, rect.size.width, rect.size.height )
            break
        case 1003:
            newShopButton.selected = false
            newProductButton.selected = false
            newbuildingButton.selected = true
            
            center.x = bounds.width*5/6
            targetFrame = CGRectMake(abs(center.x - rect.size.width * 0.5), center.y - rect.size.height * 0.5, rect.size.width, rect.size.height )
            break
        default:
            break
        }
        UIView.animateWithDuration(4.25,
                                   animations: { () -> Void in
                                    self.slideBottomImageView.frame = nowFrame
        }) { (isFinished) -> Void in
            if isFinished {
                self.slideBottomImageView.frame = targetFrame
            }
        }
    }
    
    @IBAction func onClickSectionViewButton(sender: AnyObject) {
        var isLeft = 0
        
        switch sender.tag {
        case 1001:
            newShopButton.selected = true
            newProductButton.selected = false
            newbuildingButton.selected = false

            isLeft = 0
            break
        case 1002:
            newShopButton.selected = false
            newProductButton.selected = true
            newbuildingButton.selected = false
            isLeft = 1
            break
        case 1003:
                /*
            newShopButton.selected = false
            newProductButton.selected = false
            newbuildingButton.selected = true
                */
            isLeft = 2 
            break
 
        default:
            break
        }
        if let call = self.callFunc {
            call(isIndex: isLeft)
        }
        
    }
    
    
}
