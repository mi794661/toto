//
//  CSAppGuideView.swift
//  Delicious
//
//  Created by Think on 16/1/28.
//  Copyright © 2016年 北京察知墨士品牌管理有限责任公司. All rights reserved.
//

import UIKit

typealias noneParamsCallFunc = Void -> Void

class CSAppGuideView: UIView, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var removedCallback:noneParamsCallFunc?
    
    private let guideCount = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        
        
        pageControl.hidden = true
        let height: Int = Int(UIScreen.mainScreen().bounds.height)
        var prevView: UIView? = nil
        for i in 1 ... guideCount {
            let imageName = "app_guide_\(i)_\(height)"
            let imgView = UIImageView(image: UIImage(named:imageName) )
            print("Name:\(imageName): \(imgView.image)")
            imgView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(imgView)
            
            scrollView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1, constant: 0))
            scrollView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1, constant: 0))
            
            scrollView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .CenterY, relatedBy: .Equal, toItem: scrollView, attribute: .CenterY, multiplier: 1, constant: 0))
            
            if let desView = prevView {
                scrollView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Leading, relatedBy: .Equal, toItem: desView, attribute: .Trailing, multiplier: 1, constant: 0))
            } else {
                scrollView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Leading, relatedBy: .Equal, toItem: scrollView, attribute: .Leading, multiplier: 1, constant: 0))
            }
            prevView = imgView
        }
        
        var rFrame = UIScreen.mainScreen().bounds
        let coverBnt = UIButton(frame: rFrame)
        rFrame.origin.x = 2*UIScreen.mainScreen().bounds.width
        coverBnt.frame = rFrame
        scrollView.addSubview(coverBnt)
        coverBnt.backgroundColor = UIColor.clearColor()
        coverBnt.addTarget(self, action: #selector(CSAppGuideView.clickCoverView), forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.delegate = self
        
        pageControl.numberOfPages = guideCount
        pageControl.currentPage = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSizeMake(frame.width * CGFloat(guideCount), frame.height)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset
        let index = offset.x / scrollView.frame.width
        pageControl.currentPage = Int(index)
        
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            let offsetX = scrollView.contentSize.width - offset.x
            let per = offsetX / scrollView.frame.width
            scrollView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(per)
            
            if offsetX < scrollView.frame.width - 80 {
                offset.x = scrollView.contentSize.width
                scrollView.setContentOffset(offset, animated: true)
                self.userInteractionEnabled = false
            }
        } else {
            scrollView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func clickCoverView() {
        self.userInteractionEnabled = true
        self.removeFromSuperview()
        removedCallback?()
    }
    
}
