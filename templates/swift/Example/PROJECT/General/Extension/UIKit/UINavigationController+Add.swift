//
//  UINavigationController+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

public extension UINavigationController {
    
    @discardableResult
    func popToViewController(where predicate: (UIViewController) -> Bool, animated: Bool = true) -> [UIViewController]? {
        guard let target = viewControllers.last(where: predicate) else { return nil }
        return popToViewController(target, animated: animated) 
    }
}
