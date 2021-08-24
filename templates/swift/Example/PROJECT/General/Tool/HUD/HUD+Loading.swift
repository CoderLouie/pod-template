//
//  HUD+Loading.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

// MARK: - Loading
fileprivate protocol LoadingAction {
    func show()
    func dismiss()
}
extension LoadingAction where Self: UIView {
    func show() {}
    func dismiss() { removeFromSuperview() }
}
fileprivate typealias LoadingViewAction = LoadingAction & UIView


#if canImport(Lottie)
import Lottie
#endif
extension HUD {
    
    fileprivate class IndicatorLoading: UIView, LoadingAction {
        convenience init(blurStyle: UIBlurEffect.Style, indicatorStyle: UIActivityIndicatorView.Style) {
            self.init(frame: UIScreen.main.bounds)
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle)).then {
                $0.layer.cornerRadius = 3.fit
                $0.layer.masksToBounds = true
                addSubview($0)
                $0.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            }
            
            UIActivityIndicatorView(style: indicatorStyle).do {
                $0.color = UIColor(gray: 0, alpha: 0.7)
                $0.startAnimating()
                blurView.contentView.addSubview($0)
                $0.snp.makeConstraints {
                    let margin = 25.fit
                    $0.edges.equalTo(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
                }
            }
        }
    }
    
    fileprivate class LottieLoading: UIView, LoadingAction {
        convenience init?(_ filePath: String) {
            guard let bundlePath = Bundle.main.path(forResource: "Loading", ofType: "bundle"),
                  let bundle = Bundle(path: bundlePath),
                  let animPath = bundle.path(forResource: filePath, ofType: "json") else {
                return nil
            }
            self.init(frame: UIScreen.main.bounds)
            backgroundColor = UIColor(gray: 0, alpha: 0.6)
            
            #if canImport(Lottie)
            AnimationView(filePath: animPath).do {
                $0.loopMode = .loop
                $0.contentMode = .scaleAspectFill
                addSubview($0)
                $0.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.width.height.equalTo(50.fit)
                }
                $0.play()
            }
            #endif 
        }
        func show() {
            UIView.animate(withDuration: 0.25) {
                self.alpha = 1.0
            }
        }
        func dismiss() {
            UIView.animate(withDuration: 0.25) {
                self.alpha = 0.0
            } completion: { _ in
                self.removeFromSuperview()
            }
        }
    }
    
    enum Loading {
        enum Style {
            case lottie
            case indicator(UIActivityIndicatorView.Style = .whiteLarge, blur: UIBlurEffect.Style = .light)
        }
        private static var previousLoadingView: LoadingViewAction?
        static func show(_ style: Style = .indicator()) {
            guard let window = HUD.window else { return }
            let loadingView: LoadingViewAction
            
            switch style {
            case .lottie:
                guard let view = LottieLoading("data") else { return }
                view.alpha = 0
                loadingView = view
            case let .indicator(indicatorStyle, blur: blurStyle):
                loadingView = IndicatorLoading(blurStyle: blurStyle, indicatorStyle: indicatorStyle)
            }
            
            previousLoadingView?.removeFromSuperview()
            window.addSubview(loadingView)
            loadingView.show()
            previousLoadingView = loadingView
        }
        static func dismiss() {
            previousLoadingView?.dismiss()
            previousLoadingView = nil
        }
        static var isShowing: Bool {
            previousLoadingView != nil
        } 
    }
}
