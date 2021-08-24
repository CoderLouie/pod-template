//
//  Value+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit


infix operator ~= : ComparisonPrecedence
/// 浮点数比较是否相等
func ~=<T>(lhs: T,rhs: T) -> Bool where T: FloatingPoint {
    return lhs == rhs || lhs.nextDown == rhs || lhs.nextUp == rhs
}

infix operator !~= : ComparisonPrecedence
/// 浮点数比较是否不相等
func !~=<T>(lhs: T, rhs: T) -> Bool where T: FloatingPoint {
    return !(lhs ~= rhs)
}

extension CGSize {
    var isEmpty: Bool {
        width == 0 || height == 0
    }
    
    func inset(_ inset: UIEdgeInsets) -> CGSize {
        CGSize(width: width + inset.left + inset.right, height: height + inset.top + inset.bottom)
    }
}
