//
//  CSUIUtils.swift
//  Delicious
//
//  Created by Think on 15/11/14.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

class CSUIUtils: NSObject {
    
    static let ColorAppTint = UIColor.colorWithHexRGB(0xFFE001)
    static let ColorTitleLable = UIColor.colorWithHexRGB(0x202020)
    static let ColorContentLable = UIColor.colorWithHexRGB(0x999999)
    static let ColorRedLable = UIColor.colorWithHexRGB(0xE64346)
    static let ColorBlackLable = UIColor.colorWithHexRGB(0x3E3D3B)
    static let ColorBlackGroundView = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1)
    static let ColorCircleEdgeLineView = UIColor(red:0.63, green:0.63, blue:0.63, alpha:1)
    
    
    static func vcOfMain(vcId: String) ->UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(vcId)
    }

    static func vcOfHome(vcId: String) ->UIViewController {
        return UIStoryboard(name: "Home", bundle: nil).instantiateViewControllerWithIdentifier(vcId)
    }

    static func vcOfTask(vcId: String) ->UIViewController {
        return UIStoryboard(name: "Task", bundle: nil).instantiateViewControllerWithIdentifier(vcId)
    }
    
    static func vcOfMessage(vcId: String) ->UIViewController {
        return UIStoryboard(name: "Message", bundle: nil).instantiateViewControllerWithIdentifier(vcId)
    }
    
    static func vcOfMine(vcId: String) ->UIViewController {
        return UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier(vcId)
    }

    static func vcOfCommon(vcId: String) ->UIViewController {
        return UIStoryboard(name: "Common", bundle: nil).instantiateViewControllerWithIdentifier(vcId)
    }

    static func generateBackButton() -> UIButton {
        let button = NSBundle.mainBundle().loadNibNamed("WBNavBackButton", owner: nil, options: nil)[0] as! UIButton
        return button
    }

    static func generatePersonButton() -> UIButton {
        let button = NSBundle.mainBundle().loadNibNamed("CSNavPersonButton", owner: nil, options: nil)[0] as! UIButton
        return button
    }

    static func generateNavRightButton() -> UIButton {
        let button = NSBundle.mainBundle().loadNibNamed("WBNavRightButton", owner: nil, options: nil)[0] as! UIButton
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return button
    }
    
    static func configNavBarBackWhiteButton(target: UIViewController, selector: Selector) {
        let button = generateBackButton()
        button.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "hdxq_nav_icon"), forState: .Normal)
        button.setImage(UIImage(named: "hdxq_nav_icon"), forState: .Highlighted)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -16
        target.navigationItem.leftBarButtonItems = [negativeSpacer, UIBarButtonItem(customView: button)]
    }
    
    static func configNavBarBackButton(target: UIViewController, selector: Selector) {
        let button = generateBackButton()
        button.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -16
        target.navigationItem.leftBarButtonItems = [negativeSpacer, UIBarButtonItem(customView: button)]
    }
    
    static func configNavRightBarButton(titleName: String, target: UIViewController, selector: Selector) {
        let button = generateNavRightButton()
        if(titleName.characters.count > 3) {
            var r = button.bounds
            r.size.width += 30
            button.frame = r
        }
        
        button.setTitle(titleName, forState: .Normal)
        button.setTitle(titleName, forState: .Highlighted)
        button.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -4)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -16
        target.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button), negativeSpacer]
    }
  
}
