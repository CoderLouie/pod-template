//
//  UIColor+Config.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

public extension UIColor {
    enum Tabbar {
        public static var title: UIColor { UIColor(hex: 0x6D6D6D)! }
    }
    enum Navbar { 
        public static func bg(alpha: CGFloat = 1.0) -> UIColor { UIColor(r: 0, g: 0, b: 0, a: alpha) }
    }
    enum Main {
        public static var theme: UIColor { UIColor(r: 0, g: 0, b: 0) }
        public static var gradients: [UIColor] {
            [UIColor(red: 0.17, green: 0.94, blue: 1, alpha: 1.00),
             UIColor(red: 1, green: 0.92, blue: 0.22, alpha: 1.00)]
        }
    }
     
    static var mask: UIColor {
        UIColor.black.withAlphaComponent(0.6)
    }
}
