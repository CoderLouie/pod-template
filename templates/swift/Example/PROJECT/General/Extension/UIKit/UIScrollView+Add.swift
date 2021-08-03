//
//  UIScrollView+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit

public extension UIScrollView {
    var insertT: CGFloat {
        get { contentInset.top }
        set { contentInset.top = newValue }
    }
    var insertB: CGFloat {
        get { contentInset.bottom }
        set { contentInset.bottom = newValue }
    }
    var insertL: CGFloat {
        get { contentInset.left }
        set { contentInset.left = newValue }
    }
    var insertR: CGFloat {
        get { contentInset.right }
        set { contentInset.right = newValue }
    }
    
    
    var offsetT: CGFloat {
        get { contentOffset.y }
        set { contentOffset.y = newValue }
    }
    var offsetB: CGFloat {
        get { contentOffset.y + frame.size.height }
        set { contentOffset.y = newValue - frame.size.height }
    }
    var offsetL: CGFloat {
        get { contentOffset.x }
        set { contentOffset.x = newValue }
    }
    var offsetR: CGFloat {
        get { contentOffset.x + frame.size.width }
        set { contentOffset.x = newValue - frame.size.width }
    }
    
    
    var contentW: CGFloat {
        get { contentSize.width }
        set { contentSize.width = newValue }
    }
    var contentH: CGFloat {
        get { contentSize.height }
        set { contentSize.height = newValue }
    }
    
    var visibleW: CGFloat {
        contentInset.left + contentSize.width + contentInset.right
    }
    var visibleH: CGFloat {
        contentInset.top + contentSize.height + contentInset.bottom
    }
    
    var offsetMinT: CGFloat {
        -contentInset.top
    }
    var offsetMaxT: CGFloat {
        offsetMaxB - frame.size.height
    }
    var offsetMinB: CGFloat {
        offsetMinT + frame.size.height
    }
    var offsetMaxB: CGFloat {
        contentSize.height + contentInset.bottom
    }
    var offsetMinL: CGFloat {
        -contentInset.left
    }
    var offsetMaxL: CGFloat {
        offsetMinR - frame.size.width
    }
    var offsetMinR: CGFloat {
        offsetMinL + frame.size.width
    }
    var offsetMaxR: CGFloat {
        contentSize.width + contentInset.right
    }
    
    var atTopPosition: Bool {
        offsetT == offsetMinT
    }
    var atBottomPosition: Bool {
        offsetT == offsetMaxT
    }
    var atLeftPosition: Bool {
        offsetL == offsetMinL
    }
    var atRightPosition: Bool {
        offsetL == offsetMaxL
    }
}

public extension UIScrollView {
    enum ScrollDirection {
        case horizontal
        case vertical
    }
    
    func pageIndex(at direction: ScrollDirection = .horizontal) -> Int {
        switch direction {
        case .horizontal:
            let width = frame.size.width
            return Int((contentOffset.x + width * 0.5) / width)
        case .vertical:
            let height = frame.size.height
            return Int((contentOffset.y + height * 0.5) / height)
        }
    }
    
    func roll(distance: CGFloat, at direction: ScrollDirection = .horizontal,  animated: Bool = true) {
        var offset = contentOffset
        switch direction {
        case .horizontal:
            offset.x += distance
        case .vertical:
            offset.y += distance
        }
        setContentOffset(offset, animated: animated)
    }
    func roll(toPageIndex index: Int, at direction: ScrollDirection = .horizontal, animated: Bool = true) {
        let size = frame.size
        var offset: CGPoint = .zero
        switch direction {
        case .horizontal:
            offset.x = size.width * CGFloat(index)
        case .vertical:
            offset.y = size.height * CGFloat(index)
        }
        setContentOffset(offset, animated: animated)
    }
    
    struct PanDirection: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        public static var unknown: PanDirection { .init(rawValue: 0) }
        public static var up: PanDirection { .init(rawValue: 1 << 0) }
        public static var down: PanDirection { .init(rawValue: 1 << 1) }
        public static var left: PanDirection { .init(rawValue: 1 << 2) }
        public static var right: PanDirection { .init(rawValue: 1 << 3) }
    }
    
    var panDirection: PanDirection {
        var directions: PanDirection = .unknown
        let point = panGestureRecognizer.translation(in: superview) 
        if point.y > 0 {
            directions.formUnion(.up)
        }
        if point.y < 0 {
            directions.formUnion(.down)
        }
        if point.x < 0 {
            directions.formUnion(.left)
        }
        if point.x > 0 {
            directions.formUnion(.right)
        }
        return directions
    }
}
