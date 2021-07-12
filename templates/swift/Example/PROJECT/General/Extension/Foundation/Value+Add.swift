//
//  Value+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation


infix operator ~= : ComparisonPrecedence
/// 浮点数比较是否相等
func ~=<T>(lhs: T,rhs: T) -> Bool where T: FloatingPoint {
    return lhs == rhs || lhs.nextDown == rhs || lhs.nextUp == rhs
}
