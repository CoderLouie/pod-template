//
//  UIView+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

public extension UIView { 
    func subview<T: UIView>(where cond: (T) -> Bool, reverse: Bool = true) -> T? {
        var views = [self]
        var index = 0
        repeat {
            let view = views[index]
            if let type = view as? T, cond(type) { return type }
            index += 1
            views.insert(contentsOf: reverse ? view.subviews.reversed() : view.subviews, at: index)
        } while index < views.count
        return nil
    }
}

