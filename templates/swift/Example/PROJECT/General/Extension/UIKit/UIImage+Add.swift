//
//  UIImage+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

public extension Bundle {
    static var preferredScales: [Int] = {
        let screenScale = UIScreen.main.scale
        if screenScale <= 1 { return [1, 2, 3] }
        if screenScale <= 2 { return [2, 3, 1] }
        return [3, 2, 1]
    }()
}

extension UIImage {
    func stretchableImage(anchor point: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> UIImage? {
        let tmp = size;
        return stretchableImage(withLeftCapWidth: Int(tmp.width * point.x), topCapHeight: Int(tmp.height * point.y))
    }
    
    func original() -> UIImage {
        self.withRenderingMode(.alwaysOriginal)
    }
    
    
    public convenience init?(loadFromFile path: String, in bundleClass: AnyClass? = nil) {
        guard !path.hasSuffix("/") else { return nil }
        let nspath = path as NSString
        
        let bundle = bundleClass.map { Bundle(for: $0) } ?? Bundle.main
        let res = nspath.deletingPathExtension
        let ext = nspath.pathExtension
        let exts = ext.isEmpty ? ["", "png", "jpeg", "jpg", "gif", "webp", "apng"] : [ext]
        
        for s in Bundle.preferredScales {
            let scaledName = res + "@\(s)x"
            for e in exts {
                if let path = bundle.path(forResource: scaledName, ofType: e),
                   let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    self.init(data: data, scale: CGFloat(s))
                    return
                }
            }
        }
        
        return nil
    }
}
