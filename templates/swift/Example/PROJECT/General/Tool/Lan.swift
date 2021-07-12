//
//  Lan.swift
//  GifMaker
//
//  Created by 李阳 on 2021/5/17.
//

import UIKit
 
 
public enum Lan {
    public enum Home: String, LocalizedStringConvertible {
        case cutout
        case burst
        case photo
        public static var keyPrefix: String? { return "home_item" }
    }
}

