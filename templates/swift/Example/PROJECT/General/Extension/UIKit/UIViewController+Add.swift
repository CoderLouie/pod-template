//
//  UIViewController+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

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
