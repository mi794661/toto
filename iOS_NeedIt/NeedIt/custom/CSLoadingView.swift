//
//  CSLoadingView.swift
//  Delicious
//
//  Created by Think on 15/12/18.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class CSLoadingView: UIView {
    
    @IBOutlet weak var viewAfterLoading: UIView!
    @IBOutlet weak var viewStartLoading: UIView!
    @IBOutlet weak var viewCoverButton: UIButton!
    
    @IBOutlet weak var loadedTipsLabel: UILabel!
    @IBOutlet weak var loadedImageView: UIImageView!
    
    @IBOutlet weak var loadingGifImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let name = "加载动画"
        loadedTipsLabel.numberOfLines = 2
        guard let filePath = NSBundle.pathForResource(name, ofType: "gif", inDirectory: NSBundle.mainBundle().bundlePath) else {
            return
        }
        let imageData = NSData.dataWithContentsOfMappedFile(filePath) as! NSData
        loadingGifImageView.image = UIImage.sd_animatedGIFWithData(imageData)
        viewCoverButton.enabled = false
    }
    
    func showError(errText: String) {
        var infoText = errText
        if infoText.isEmpty {
            infoText = "出错啦~~"
        }
        viewCoverButton.enabled = true
        loadedTipsLabel.text = infoText
        viewAfterLoading.hidden = false
        viewStartLoading.hidden = true
    }
    
    func showLoading(tipsText: String,target: AnyObject?,select: Selector) {
        if tipsText.isEmpty {
            loadedTipsLabel.text = "loading......"
        }else{
            loadedTipsLabel.text = tipsText
        }
        viewAfterLoading.hidden = true
        viewStartLoading.hidden = false
        viewCoverButton.enabled = false

        if !(target is NSNull) {
            viewCoverButton.removeTarget(target, action:select ,forControlEvents:.TouchUpInside)
            viewCoverButton.addTarget(target, action:select ,forControlEvents:.TouchUpInside)
        }
    }
    
    func finishLoading() {
        removeFromSuperview()
    }
    
}
