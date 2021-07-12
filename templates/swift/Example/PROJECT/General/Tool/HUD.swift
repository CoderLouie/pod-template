//
//  HUD.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

/*
enum HUD {
    fileprivate class BaseView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setup () {}
    }
    
    fileprivate final class MaskView: UIView {
        enum Style {
            case plain
            case blur(UIBlurEffect.Style)
        }
        
        convenience init(style: Style) {
            self.init(frame: UIScreen.main.bounds)
            backgroundColor = UIColor(gray: 255, alpha: 0.3)
            if case let .blur(s) = style {
                let blurView = UIVisualEffectView(effect: UIBlurEffect(style: s))
                blurView.alpha = 0.99
                blurView.frame = bounds
                insertSubview(blurView, at: 0)
            }
        }
        
        func show() {
            guard let window = UIApplication.shared.delegate?.window else { return }
            window?.addSubview(self)
        }
        func dismiss() {
            removeFromSuperview()
        }
    }
}

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

import Lottie
extension HUD {
    enum Loading {
        enum Style {
            case lottie
            case indicator(UIActivityIndicatorView.Style = .whiteLarge, blur: UIBlurEffect.Style = .light)
        }
        private static var previousLoadingView: LoadingViewAction?
        static func show(_ style: Style = .lottie) {
            guard let w = UIApplication.shared.delegate?.window, let window = w else { return }
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
        
        fileprivate class IndicatorLoading: UIView, LoadingAction {
            convenience init(blurStyle: UIBlurEffect.Style, indicatorStyle: UIActivityIndicatorView.Style) {
                self.init(frame: UIScreen.main.bounds)
                let blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
                blurView.alpha = 0.99
                blurView.frame = bounds
                addSubview(blurView)
                
                let indicator = UIActivityIndicatorView(activityIndicatorStyle: indicatorStyle)
                indicator.startAnimating()
                addSubview(indicator)
                indicator.snp.makeConstraints {
                    $0.center.equalToSuperview()
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
    }
}

// MARK: - Tips
extension HUD {
    enum Tips {
        enum Position {
            case belowStatusBar
            case belowNavBar
            case center
            case aboveTabbar
            case aboveHomeIndicator
        }
        private static var previousTips: UIView?
        static func show(_ title: String, _ position: Position = .center, completion: (() -> Void)? = nil) {
            guard let w = UIApplication.shared.delegate?.window, let window = w else { return }
            let margin = 10.fit
            let box = UIView()
            box.backgroundColor = UIColor(hex: "1c1c1c", alpha: 0.8)
            box.layer.cornerRadius = 4.fit
            box.clipsToBounds = true
            
            let label = UILabel()
            label.text  = title
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 12.fit)
            label.numberOfLines = 0
            label.textAlignment = .center
            
            box.addSubview(label)
            label.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
                make.width.lessThanOrEqualTo(window.bounds.size.width - 6 * margin)
            }
            
            previousTips?.removeFromSuperview()
            previousTips = box
            window.addSubview(box)
            box.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                switch position {
                case .belowStatusBar:
                    make.top.equalTo(Screen.safeAreaT)
                case .belowNavBar:
                    make.top.equalTo(Screen.navbarH)
                case .center:
                    make.centerY.equalToSuperview()
                case .aboveTabbar:
                    make.bottom.equalTo(-Screen.tabbarH)
                case .aboveHomeIndicator:
                    make.bottom.equalTo(-Screen.safeAreaB)
                }
            }
            DispatchQueue.main.after(2) {
                box.removeFromSuperview()
                completion?()
                previousTips = nil
            }
        }
        
        static var isShowing: Bool {
            previousTips != nil
        }
    }
}


// MARK: - Progress

extension HUD {
    enum Progress {
        final class ProgressView<R>: UIView {
            
            enum Action {
                case timeout(interval: TimeInterval, tips: String?, position: HUD.Tips.Position = .center)
                case prepare(tips: String)
                enum Progress {
                    case system
                    case custom(Int)
                }
                case progress(type: Progress)
                case finish(value: R)
                case stop(error: String?, position: HUD.Tips.Position = .center)
            }
            private enum Status {
                case prepare
                case progress
                case dismissing
            }
            typealias ProgressTitle = (Int) -> String
            typealias ActionControl = (Action) -> Void
            
            override init(frame: CGRect) {
                super.init(frame: frame)
                setup()
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            private func setup() {
                self.frame = UIScreen.main.bounds
                backgroundColor = UIColor(hex: "ffffff", alpha: 0.3)
                UIVisualEffectView(effect: UIBlurEffect(style: .dark)).do {
                    $0.alpha = 0.99
                    $0.frame = bounds
                    addSubview($0)
                }
                UIView().do { box in
                    addSubview(box)
                    box.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                        make.left.right.equalToSuperview()
                    }
                    
                    trackView = UIView().then {
                        $0.layer.cornerRadius = 3.fit
                        $0.clipsToBounds = true
                        $0.backgroundColor = UIColor(hex: "ffffff", alpha: 0.3)
                        
                        box.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.top.equalTo(0)
                            make.left.equalTo(100.fit)
                            make.right.equalTo(-100.fit)
                            make.height.equalTo(6.fit)
                        }
                    }
                    progressView = UIView().then {
                        $0.layer.cornerRadius = 3.fit
                        $0.clipsToBounds = true
                        $0.backgroundColor = .white
                        
                        trackView.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.left.top.bottom.equalToSuperview()
                            make.width.equalTo(0)
                        }
                    }
                    titleLabel = UILabel().then {
                        $0.textColor = .white
                        $0.font = UIFont.systemFont(ofSize: 15.fit, weight: .medium)
                        $0.text = " "
                        box.addSubview($0)
                        $0.snp.makeConstraints { make in
                            make.top.equalTo(trackView.snp.bottom).offset(9)
                            make.bottom.equalTo(0)
                            make.centerX.equalToSuperview()
                        }
                    }
                    
                }
            }
            func show(title: ProgressTitle?,
                      action: (@escaping ActionControl) -> Void,
                      done: ((R) -> Void)?)  {
                guard let window = UIApplication.shared.delegate?.window else { return }
                self.progressTitle = title
                action(doAction(_:))
                doneHandler = done
                window?.addSubview(self)
            }
            deinit {
                NSLog("ProgressView deinit")
            }
            private func doAction(_ result: Action) {
                if case let .timeout(interval: interval, tips: tips, position: pos) = result {
                    DispatchQueue.main.after(interval) {[weak self] in
                        guard self?.status != .dismissing else { return }
                        self?.doAction(.stop(error: tips, position: pos))
                    }
                    return
                }
                switch result {
                case let .prepare(tips: tips):
                    titleLabel.text = tips
                case let .progress(type: type):
                    guard status != .dismissing else { return }
                    switch type {
                    case .system:
                        // 如果已经开始过进度，则重置进度
                        if progress > 0 {
                            progress = 0; index = 0
                        }
                        createTimer(interval: 0.1,
                                    selector: #selector(progeressFast))
                    case let .custom(progress):
                        // 确保不受定时器影响
                        removeTimer()
                        if progress < 100 { self.progress = progress }
                    }
                case let .finish(value: value):
                    guard status != .dismissing else { return }
                    status = .dismissing
                    progress = 100
                    DispatchQueue.main.after(1) {
                        self.doneHandler?(value)
                        self.dismiss()
                    }
                case let .stop(error: tips, position: pos):
                    guard status != .dismissing else { return }
                    status = .dismissing
                    guard let tip = tips else {
                        dismiss()
                        return
                    }
                    removeTimer()
                    HUD.Tips.show(tip, pos) {
                        self.dismiss()
                    }
                default: break
                }
            }
            private func dismiss() {
                removeTimer()
                removeFromSuperview()
            }
            private func removeTimer() {
                self.timer?.invalidate()
                self.timer = nil
            }
            private func createTimer(interval: TimeInterval, selector: Selector) {
                removeTimer()
                let timer = Timer(timeInterval: interval, target: self, selector: selector, userInfo: nil, repeats: true)
                RunLoop.current.add(timer, forMode: .common)
                self.timer = timer
            }
            @objc private func progeressFast() {
                if index < steps.count {
                    progress = steps[index]
                    index += 1
                } else {
                    createTimer(interval: 1, selector: #selector(progeressSlow))
                }
            }
            @objc private func progeressSlow() {
                if progress < 99 { progress += 1 }
            }
            private var status: Status = .prepare
            private var index: Int = 0
            private unowned var trackView: UIView!
            private unowned var progressView: UIView!
            private(set) unowned var titleLabel: UILabel!
            
            private var progressTitle: ProgressTitle?
            private var doneHandler: ((R) -> Void)?
            private var timer: Timer?
            
            private var progress: Int = 0 {
                didSet {
                    titleLabel.text = progressTitle?(progress)
                    progressView.snp.updateConstraints { make in
                        make.width.equalTo(trackView.bounds.size.width * (CGFloat(progress) / 100.0))
                    }
                    
                }
            }
            private lazy var steps: [Int] = {
                var steps: [Int] = []
                for i in 0..<20 {
                    if i == 19 { steps.append(95) }
                    else { steps.append(i * 5 + (Int(arc4random())%5)) }
                }
                return steps
            }()
        }
        
        
        static func show<R>(resultType: R.Type,
                            title: (ProgressView<R>.ProgressTitle)?,
                            action: (@escaping ProgressView<R>.ActionControl) -> Void,
                            done: ((R) -> Void)?) {
            let view = ProgressView<R>()
            view.show(title: title,
                      action: action,
                      done: done)
        }
    }
}

*/
