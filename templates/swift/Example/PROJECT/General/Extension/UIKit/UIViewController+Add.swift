//
//  UIViewController+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit


public extension UIViewController {
    func front() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.front()
        } else if let nav = self as? UINavigationController,
                  let visible = nav.visibleViewController {
            return visible.front()
        } else if let tab = self as? UITabBarController,
                  let selected = tab.selectedViewController {
            return selected.front()
        } else {
            for vc in self.children.reversed() {
                if vc.view.window != nil {
                    return vc.front()
                }
            }
            return self
        }
    }
}

// MARK: - Alert
public extension UIViewController {
    
    @discardableResult
    func present(style: UIAlertController.Style = .alert,
                 make: (UIAlertController) -> Void,
                 completion: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style) 
        make(alertController)
        present(alertController, animated: true, completion: completion)
        return alertController
    }
}

public extension UIAlertController {
    
    @discardableResult
    func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        addAction(action)
        return action
    }
}
