//
//  PaddingLabel.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

public class PaddingLabel: UILabel {
    public var textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10).fit
 
    public override func drawText(in rect: CGRect) {
        return super.drawText(in: rect.inset(by: textContainerInset))
    }

    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let inset = textContainerInset
        return CGSize(width: size.width + inset.left + inset.right, height: size.height + inset.top + inset.bottom)
    }
}

public class PaddingButton: UIButton {
    public var containerInset = UIEdgeInsets(top: 0, left: 10.fit, bottom: 0, right: 10.fit)
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let inset = containerInset
        return CGSize(width: size.width + inset.left + inset.right, height: size.height + inset.top + inset.bottom)
    }
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        intrinsicContentSize
    }
}
