//
//  SheetBox.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

class SheetBox: BaseView {
    override func addSubview(_ view: UIView) {
        fatalError("please add the subview to contentView")
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let view = superview {
            let height = view.bounds.size.height
            self.snp.remakeConstraints { make in
                make.top.equalTo(height)
                make.left.right.equalTo(0)
            }
        }
    }
    override func setup() {
        super.setup()
        backgroundColor = UIColor.Main.theme
        
        contentView = UIView().then {
            $0.backgroundColor = .clear
            super.addSubview($0)
            $0.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: Screen.safeAreaB, right: 0))
            }
        }
    }
    
    func present(animations: ((SheetBox) -> Void)? = nil, completion: ((SheetBox, Bool) -> Void)? = nil) {
        guard let view = superview else {
            fatalError("must add to superview before call this method")
        }
        let superSize = view.bounds.size
        var size = bounds.size
        if size.isEmpty {
            layoutIfNeeded()
            size = bounds.size
        }
        frame = CGRect(x: 0, y: superSize.height, width: size.width, height: size.height)
        
        contentView.backgroundColor = .clear
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.animationDuration) {
                self.frame = self.frame.with {
                    $0.origin.y -= $0.height
                }
                animations?(self)
            } completion: { completion?(self, $0) }
        }
    }
    func dismiss(animations: ((SheetBox) -> Void)? = nil, completion: ((SheetBox, Bool) -> Void)? = nil) {
        UIView.animate(withDuration: animationDuration) {
            self.frame = self.frame.with {
                $0.origin.y += $0.height
            }
            animations?(self)
        } completion: { completion?(self, $0) }
    }
    var isPresented: Bool {
        guard let view = superview else { return false }
        return frame.origin.y < view.frame.height
    }
    var animationDuration: TimeInterval = 0.25
    private(set) unowned var contentView: UIView!
}
