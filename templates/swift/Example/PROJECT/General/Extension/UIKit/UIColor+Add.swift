//
//  UIColor+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r red: CGFloat, g green: CGFloat, b blue: CGFloat, a alpha: CGFloat = 1.0) {
        precondition(red >= 0 && red <= 255, "Invalid red component")
        precondition(green >= 0 && green <= 255, "Invalid green component")
        precondition(blue >= 0 && blue <= 255, "Invalid blue component")
        precondition(alpha >= 0 && alpha <= 1.0, "Invalid alpha component")
        
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    convenience init(gray: CGFloat, alpha: CGFloat = 1.0) {
        precondition(gray >= 0 && gray <= 255, "Invalid gray paramter")
        
        self.init(red: gray / 255.0, green: gray / 255.0, blue: gray / 255.0, alpha: alpha)
    }
}
