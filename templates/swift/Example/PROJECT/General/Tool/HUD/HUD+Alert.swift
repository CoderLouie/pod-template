//
//  HUD+Alert.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

// MARK: - Alert
extension HUD {
    final class AlertView: HUD.BaseView {
        enum ActionStyle {
            case black, white
        }
        
        internal override func setup() {
            self.frame = UIScreen.main.bounds
            backgroundColor = UIColor(gray: 0, alpha: 0.4)
            let margin = 30.fit
            let contentView = UIView().then {
                $0.backgroundColor = .white
                addSubview($0)
                $0.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.left.equalTo(margin)
                    make.right.equalTo(-margin)
                }
            }
            
            msgLabel = UILabel().then {
                $0.textAlignment = .center
                $0.font = UIFont.systemFont(ofSize: 18).fit
                $0.numberOfLines = 0
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(margin)
                    make.left.equalTo(20.fit)
                    make.right.equalTo(-20.fit)
                }
            }
            actionContent = UIView().then {
                contentView.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.width.equalTo(msgLabel)
                    make.top.equalTo(msgLabel.snp.bottom).offset(margin)
                    make.bottom.equalTo(-20.fit)
                }
            }
        }
        func addAction(_ title: String,
                       config: (UIButton) -> Void,
                       closure: (() -> Void)? = nil) {
            UIButton().do {
                config($0)
                guard $0.allTargets.isEmpty else {
                    fatalError("use the closure param")
                }
                $0.addBlock(for: .touchUpInside) { [weak self] _ in
                    self?.removeFromSuperview()
                    closure?()
                }
                actionContent.addSubview($0)
                $0.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                    make.height.equalTo(49.fitH)
                    let n = actionContent.subviews.count - 1
                    if n == 0 {
                        make.top.equalTo(0)
                    } else {
                        let last = actionContent.subviews[n - 1]
                        make.top.equalTo(last.snp.bottom).offset(5.fit)
                    }
                }
            }
        }
        func addAction(_ title: String,
                       style: ActionStyle = .black,
                       closure: (() -> Void)? = nil) {
            addAction(title) {
                switch style {
                case .black:
                    $0.backgroundColor = .black
                    $0.titleLabel?.font = UIFont.systemFont(ofSize: 18).fit
                    $0.setTitleColor(.white, for: .normal)
                case .white:
                    $0.backgroundColor = .white
                    $0.titleLabel?.font = UIFont.systemFont(ofSize: 16).fit
                    $0.setTitleColor(.black, for: .normal)
                }
                $0.setTitle(title, for: .normal)
            } closure: {
                closure?()
            }
        } 
        
        fileprivate private(set) unowned var msgLabel: UILabel!
        fileprivate private(set) unowned var actionContent: UIView!
    }
    
    enum Alert {
         
        static func show(_ message: String,
                         actions: (AlertView) -> Void) {
            guard let window = HUD.window else { return }
            let view = AlertView()
            view.msgLabel.text = message
            actions(view)
            guard let last = view.actionContent.subviews.last else {
                fatalError("must add at least one action button")
            }
            last.snp.makeConstraints { make in
                make.bottom.equalTo(0)
            }
            window.addSubview(view)
        }
        static func show(_ message: String,
                         actionTitle: String = Lan.HUD.alert_ok.localized,
                         action: (() -> Void)? = nil) {
            show(message) {
                $0.addAction(actionTitle, style: .black, closure: action)
            }
        }
        static func showExitAlert(_ forceExit: (() -> Void)? = nil) {
            show(Lan.HUD.gif_exit_tips.localized) {
                $0.addAction(Lan.HUD.alert_stay.localized, style: .black)
                $0.addAction(Lan.HUD.alert_exit_force.localized, style: .white, closure: forceExit)
            }
        }
    }
}
