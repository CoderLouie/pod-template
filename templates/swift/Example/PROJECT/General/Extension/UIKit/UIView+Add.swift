//
//  UIView+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

public extension UIView { 
    func subview<T: UIView>(where cond: (T) -> Bool, reverse: Bool = true) -> T? {
        var views = [self]
        var index = 0
        repeat {
            let view = views[index]
            if let type = view as? T, cond(type) { return type }
            index += 1
            views.insert(contentsOf: reverse ? view.subviews.reversed() : view.subviews, at: index)
        } while index < views.count
        return nil
    }
    
    func embedInScrollView(_ scrollDirection: UIScrollView.ScrollDirection = .vertical,
                           _ contentConfig: (UIView) -> Void,
                           _ scrollConfig: ((UIScrollView) -> Void)? = nil) -> UIView {
        let box = UIScrollView().then { s in
            s.showsVerticalScrollIndicator = false
            s.showsHorizontalScrollIndicator = false
            s.contentInsetAdjustmentBehavior = .never
            s.backgroundColor = .clear
            scrollConfig?(s)
            addSubview(s)
            s.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        return UIView().then {
            contentConfig($0)
            box.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalTo(box)
                if scrollDirection == .vertical {
                    make.width.equalToSuperview()
                } else {
                    make.height.equalToSuperview()
                }
            }
        }
    }
}

public protocol ViewAddition {}
public extension ViewAddition where Self: UIView {
    
    func layoutFinish(_ closure: @escaping (Self) -> Void) {
        var n = 0
        func recursive() {
            if !bounds.isEmpty ||
                n > 1 {
                closure(self)
                return
            }
            n += 1
            DispatchQueue.main.async {
                recursive()
            }
        }
        recursive()
    }
}
extension UIView: ViewAddition {}
