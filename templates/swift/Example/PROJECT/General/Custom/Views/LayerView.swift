//
//  LayerView.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

public final class LayerView<Layer>: UIView where Layer: CALayer {
    public let base: Layer
    public init(_ base: Layer, frame: CGRect = .zero) {
        precondition(base.superlayer == nil)
        
        self.base = base
        super.init(frame: frame)
        layer.insertSublayer(base, at: 0)
    }
    public convenience init(_ maker: () -> Layer) {
        self.init(maker())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        base.frame = bounds
    }
}
