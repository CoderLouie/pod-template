//
//  HUD.swift
//  VideoCutter
//
//  Created by liyang on 07/20/2021.
//  Copyright (c) 2021 gomo. All rights reserved.
//

import UIKit

enum HUD {
    static var window: UIWindow? {
        UIApplication.shared.delegate?.window ?? nil
    }
    class BaseView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func setup () {}
    }
    
     final class MaskView: UIView {
        enum Style {
            case plain
            case blur(UIBlurEffect.Style)
        }
        var tapAction: ((MaskView) -> Void)?
        convenience init(style: Style, tapAction: ((MaskView) -> Void)? = nil) {
            self.init(frame: .zero)
            self.tapAction = tapAction
            if case let .blur(s) = style {
                backgroundColor = UIColor(gray: 255, alpha: 0.3)
                let blurView = UIVisualEffectView(effect: UIBlurEffect(style: s))
                blurView.alpha = 0.99
                blurView.frame = bounds
                insertSubview(blurView, at: 0)
            } else {
                backgroundColor = UIColor(gray: 0, alpha: 0.4)
            }
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            tapAction?(self)
        }
    } 
}

