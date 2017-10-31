//
//  NSObject+Extension.swift
//  Delicious
//
//  Created by Think on 15/11/26.
//  Copyright © 2016年 智慧宝盒科技有限公司. All rights reserved.
//

import Foundation

private var UITABLEVIEW_ID_NUMBER_PROPERTY = 11

extension NSObject {
    var strongRef: AnyObject {
        get{
            return objc_getAssociatedObject(self, &UITABLEVIEW_ID_NUMBER_PROPERTY)
        }
        set{
            objc_setAssociatedObject(self, &UITABLEVIEW_ID_NUMBER_PROPERTY, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
