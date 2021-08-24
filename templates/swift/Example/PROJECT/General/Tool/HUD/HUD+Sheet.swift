//
//  HUD+Sheet.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

// MARK: - Sheet
/*
 [用UIPresentationController来写一个简洁漂亮的底部弹出控件](https://juejin.cn/post/6844903568026124296)
 */ 

extension HUD {
    class SheetView<R>: HUD.BaseView {
        typealias DoneAction = (R?) -> Void
        
        override func setup() {
            super.setup()
            backgroundColor = .clear
            
            boxView = UIView().then {
                addSubview($0)
            }
            contentView = UIView().then {
                $0.backgroundColor = .white
                boxView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: Screen.safeAreaB, right: 0))
                }
            }
        }
        @objc func close() {
            dismiss()
        }
        @objc func done() {
            dismiss()
            doneClosure?(value)
        }
        func show(on view: UIView) {
            self.frame = view.bounds
            view.addSubview(self)
            boxView.snp.makeConstraints { make in
                make.top.equalTo(Screen.height)
                make.left.right.equalTo(0)
            }
            layoutIfNeeded()
            let size = boxView.bounds.size
            boxView.frame = CGRect(x: 0, y: Screen.height, width: size.width, height: size.height)
            
            
            boxView.backgroundColor = contentView.backgroundColor
            contentView.backgroundColor = .clear
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.animationDuration) {
                    self.backgroundColor = UIColor(gray: 0, alpha: 0.4)
                    self.boxView.frame = self.boxView.frame.with {
                        $0.origin.y -= size.height
                    }
                } completion: { _ in
                }
            }
        }
        func dismiss(_ completion: (() -> Void)? = nil) {
            UIView.animate(withDuration: animationDuration) {
                self.backgroundColor = .clear
                self.boxView.frame = self.boxView.frame.with {
                    $0.origin.y = Screen.height
                }
            } completion: { _ in
                self.removeFromSuperview()
                completion?()
            }
        }
        var value: R? {
            get { nil }
            set { }
        }
        var doneClosure: DoneAction?
        var animationDuration: TimeInterval { 0.25 }
        unowned var contentView: UIView!
        private unowned var boxView: UIView!
    }
    
    enum Sheet {
        static func show<R>(_ type: SheetView<R>.Type,
                            initializedValue: R?,
                            done: ((R?) -> Void)? = nil) {
            guard let window = HUD.window else { return }
            let pick = type.init()
            
            if let value = initializedValue { pick.value = value }
            pick.doneClosure = done
            pick.show(on: window)
        }
    }
}


class DateSheet: HUD.SheetView<Date> {
    override func setup() {
        super.setup()
        let toolHeight = 44.fitH
        toolView = UIView().then {
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.top.right.equalTo(0)
                make.height.equalTo(toolHeight)
            }
        }
        
        let createButton = { (title: String, action: Selector) -> UIButton in
            UIButton().then {
                self.toolView.addSubview($0)
                $0.setTitleColor(.systemBlue, for: .normal)
                $0.setTitle(title, for: .normal)
                $0.addTarget(self, action: action, for: .touchUpInside)
                $0.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                }
            }
        }
        createButton("Cancel", #selector(close)).do {
            $0.snp.makeConstraints { make in
                make.left.equalTo(15.fit)
            }
        }
        createButton("Sure", #selector(done)).do {
            $0.snp.makeConstraints { make in
                make.right.equalTo(-15.fit)
            }
        }
        
        datePicker = UIDatePicker().then {
            if #available(iOS 13.4, *) {
                $0.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.height.equalTo(300.fitH)
                make.left.right.bottom.equalTo(0)
                make.top.equalTo(toolHeight)
            }
        }
    }
    override var value: Date? {
        get { datePicker.date }
        set {
            if let value = newValue {
                datePicker.date = value
            }
        }
    }
    private unowned var toolView: UIView!
    private unowned var datePicker: UIDatePicker!
}
