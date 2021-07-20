//
//  UIImage+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

extension UIImage {
    func stretchableImage(anchor point: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> UIImage? {
        let tmp = size;
        return stretchableImage(withLeftCapWidth: Int(tmp.width * point.x), topCapHeight: Int(tmp.height * point.y))
    }
    
    func original() -> UIImage {
        self.withRenderingMode(.alwaysOriginal)
    }
}
