//
//  NSTimer+Extension.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import Foundation

private class Block<T> {
    let f : T
    init (_ f: T) { self.f = f }
}

extension NSTimer {
    static func csScheduledTimerWithTimeInterval(ti: NSTimeInterval, repeats: Bool, block: ()->()) -> NSTimer {
        return self.scheduledTimerWithTimeInterval(ti, target: self, selector: #selector(NSTimer.csBlcokInvoke(_:)), userInfo: Block(block), repeats: repeats)
    }
    
    static func csBlcokInvoke(timer: NSTimer) {
        if let block = timer.userInfo as? Block<()->()> {
            block.f()
        } else {
            timer.invalidate()
        }
    }
}
