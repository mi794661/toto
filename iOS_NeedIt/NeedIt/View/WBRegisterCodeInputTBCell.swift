//
//  WBRegisterCodeInputTBCell.swift
//  NeedIt
//
//  Created by Think on 16/3/8.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import UIKit

private let maxRegisterCodeCount = 60

class WBRegisterCodeInputTBCell: UITableViewCell {
    var callFunc: noneParamsCallFunc?
    
    @IBOutlet weak var nameInputTextView: UITextField!
    @IBOutlet weak var requestCode: UIButton!
    
    private var isFirstEnter = true
    private weak var timer: NSTimer? = nil
    private var countdownValue = maxRegisterCodeCount
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameInputTextView.backgroundColor = UIColor.whiteColor()
        nameInputTextView.layer.cornerRadius = 4
        nameInputTextView.layer.borderColor = UIColor.colorWithHexRGB(0xD9D9D9).CGColor
        nameInputTextView.layer.borderWidth = 1
        
        nameInputTextView.leftViewMode = .Always
        let vL = UIView(frame: CGRect(x: 2, y: 0, width: 10, height: nameInputTextView.bounds.height) )
        nameInputTextView.leftView = vL
    }
    
    @IBAction func onSendAction(sender: UIButton) {
        startCountdown()
        
        if let call = self.callFunc {
            call()
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCaptchaCell(needCountdownFirst:Bool) {        
        requestCode.setTitle("获取验证码", forState: .Normal)
        
        if isFirstEnter {
            if needCountdownFirst {
                startCountdown()
            }
            isFirstEnter = false
        }
    }
    
    func startCountdown() {
        countdownValue = maxRegisterCodeCount
        requestCode.enabled = false
        requestCode.setTitle("重新获取(\(countdownValue)s)", forState: .Normal)
        
        if let t = timer {
            t.fire()
        } else {
            timer = NSTimer.csScheduledTimerWithTimeInterval(1, repeats: true) { [weak self] () -> () in
                if let weakSelf = self {
                    weakSelf.onCountdown()
                }
            }
        }
    }
    
    func resetCountdown() {
        requestCode.enabled = true
        timer?.invalidate()
        requestCode.setTitle("获取验证码", forState: .Normal)
    }
    
    private func onCountdown() {
        countdownValue -= 1
        if countdownValue <= 0 {
            resetCountdown()
        } else {
            requestCode.setTitle("重新获取(\(countdownValue)s)", forState: .Normal)
        }
    }
    
}
