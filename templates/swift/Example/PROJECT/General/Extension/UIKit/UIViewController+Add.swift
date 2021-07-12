//
//  UIViewController+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

public extension UIViewController {
    enum AlertType {
        public typealias Handler = (Int, String) -> ()
        case `default`(_ title: String, _ handler: Handler?)
        case cancel(_ title: String, _ handler: Handler?)
        case destructive(_ title: String, _ handler: Handler?)
        func action(at idx: Int) -> UIAlertAction {
            switch self {
            case .default(let title, let handler):
                return .init(title: title, style: .default, handler: { _ in
                    handler?(idx, title)
                })
            case .cancel(let title, let handler):
                return .init(title: title, style: .cancel, handler: { _ in
                    handler?(idx, title)
                })
            case .destructive(let title, let handler):
                return .init(title: title, style: .destructive, handler: { _ in
                    handler?(idx, title)
                })
            }
        }
    } 
    @discardableResult
    func presentAlert(title: String?,
                      message: String?,
                      actions: AlertType...,
        preferedIndex: Int? = nil,
        completion: (() -> ())? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (idx, model) in actions.enumerated() {
            let action = model.action(at: idx)
            alertController.addAction(action)
            if idx == preferedIndex { alertController.preferredAction = action }
        }
        present(alertController, animated: true, completion: completion)
        return alertController
    }
}
