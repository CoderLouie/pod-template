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
    
    enum CropArea {
        case top, left, bottom, right
    }
    func cropAspectFit(at area: CropArea = .top,
                       size fitSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(fitSize, true, 0)
        defer { UIGraphicsEndImageContext() }
        switch area {
        case .top:
            let height = fitSize.width * size.height / size.width
            self.draw(in: CGRect(x: 0, y: 0, width: fitSize.width, height: height))
        case .bottom:
            let height = fitSize.width * size.height / size.width
            self.draw(in: CGRect(x: 0, y: size.height - height, width: fitSize.width, height: height))
            break
        case .left:
            break
        case .right:
            break
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    public convenience init?(fileNamed name: String,
                             in bundleClass: AnyClass? = nil) {
        guard !name.hasSuffix("/") else { return nil }
        let nspath = name as NSString
        
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
        self.init(named: name)
    }
}
