//
//  LayoutView.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit
import SnapKit
 
open class LayoutView: UIView {
    private class LayoutLayer: CATransformLayer {
        override var backgroundColor: CGColor? {
            set {}
            get{ return nil }
        }
        override var isOpaque: Bool {
            set {}
            get { return false }
        }
    }
    public var contentInsets: UIEdgeInsets = .zero
    
    public override class var layerClass: AnyClass {
        return LayoutLayer.self
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    fileprivate func setup() { }
    open override func didMoveToSuperview() {
        if let _ = superview {
            self.snp.makeConstraints { make in
                make.width.height.equalTo(1).priority(100)
            }
        }
    }
    
    open var arrangedViews: [UIView] { return [] }
    public var arrangedViewsCount: Int { return arrangedViews.count }
}

open class FlexView: LayoutView {
    public enum CrossAlignment {
        case start
        case center
        case end
    }
    
    public var alignment: CrossAlignment = .start
    
    public init(_ alignment: CrossAlignment = .start, frame: CGRect = .zero) {
        self.alignment = alignment
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func addArrangedView(_ view: UIView, alignment: CrossAlignment? = nil) {
        insertArrangedView(view, at: arrangedViewsCount, alignment: alignment)
    }
    open func insertArrangedView(_ view: UIView, at index: Int, alignment: CrossAlignment? = nil) { }
    
    @discardableResult
    open func removeArrangedView<View: UIView>(_ view: View) -> View? {
        guard let idx = indexOfArrangedView(view) else { return nil }
        return removeArrangedView(at: idx)
    }
    @discardableResult
    open func removeArrangedView<View: UIView>(at index: Int) -> View? {
        let view = subviews[index]
        view.removeFromSuperview()
        return view as? View
    }
    
    open func indexOfArrangedView<View>(_ view: View) -> Int? where View : UIView {
        return subviews.firstIndex(of: view)
    }
    open override var arrangedViews: [UIView] {
        return subviews
    }
}

/// 垂直方向会自动根据内容大小布局，开发者只需做好水平方向上的布局
final public class FlexVView: FlexView {
    
    public override func insertArrangedView(_ view: UIView, at index: Int, alignment: FlexView.CrossAlignment? = nil) {
        insertSubview(view, at: index)
        let inset = contentInsets
        let align = alignment ?? self.alignment
        
        view.snp.makeConstraints { (make) in
            switch align {
                
            case .start:
                make.top.equalTo(inset.top)
                make.bottom.lessThanOrEqualTo(-inset.bottom)
            case .center:
                make.top.greaterThanOrEqualTo(inset.top)
                make.bottom.lessThanOrEqualTo(-inset.bottom)
                make.centerY.equalTo(self)
            case .end:
                make.top.greaterThanOrEqualTo(inset.top)
                make.bottom.equalTo(-inset.bottom)
            }
        }
    }
}

/// 水平方向会自动根据内容大小布局，开发者只需做好垂直方向上的布局
final public class FlexHView: FlexView {
    public override func insertArrangedView(_ view: UIView, at index: Int, alignment: FlexView.CrossAlignment? = nil) {
        insertSubview(view, at: index)
        let inset = contentInsets
        let align = alignment ?? self.alignment
        
        view.snp.makeConstraints { (make) in
            switch align {
                
            case .start:
                make.left.equalTo(inset.left)
                make.right.lessThanOrEqualTo(-inset.right)
            case .center:
                make.left.greaterThanOrEqualTo(inset.left)
                make.right.lessThanOrEqualTo(-inset.right)
                make.centerX.equalTo(self)
            case .end:
                make.left.greaterThanOrEqualTo(inset.left)
                make.right.equalTo(-inset.right)
            }
        }
    }
}


open class BoxView: FlexView {
    public var spacing: CGFloat = .zero
    
    open func addArrangedView(_ view: UIView, spacing: CGFloat? = nil, alignment: FlexView.CrossAlignment? = nil) {
        insertArrangedView(view, at: arrangedViewsCount, spacing: spacing, alignment: alignment)
    }
    open func insertArrangedView(_ view: UIView,
                                 at index: Int,
                                 spacing: CGFloat? = nil,
                                 alignment: FlexView.CrossAlignment? = nil) {
        
    }
    open override func insertArrangedView(_ view: UIView, at index: Int, alignment: FlexView.CrossAlignment? = nil) {
        insertArrangedView(view, at: index, spacing: spacing, alignment: alignment)
    }
    
    @discardableResult
    open func showArrangedView<View: UIView>(_ view: View) -> View? {
        guard let idx = indexOfArrangedView(view) else { return nil }
        return showArrangedView(at: idx)
    }
    @discardableResult
    open func hiddenArrangedView<View: UIView>(_ view: View) -> View? {
        guard let idx = indexOfArrangedView(view) else { return nil }
        return hiddenArrangedView(at: idx)
    }
    @discardableResult
    open func showArrangedView<View: UIView>(at index: Int) -> View {
        return subviews[index] as! View
    }
    @discardableResult
    open func hiddenArrangedView<View: UIView>(at index: Int) -> View {
        return subviews[index] as! View
    }
}

final public class BoxHView: BoxView {
    private var items: [BoxHItem] = []
    private var rightConstraint: Constraint?
    
    public override var arrangedViews: [UIView] {
        return items.map { $0.view }
    }
    public override var arrangedViewsCount: Int {
        return items.count
    }
    public override func indexOfArrangedView<View>(_ view: View) -> Int? where View : UIView {
        items.firstIndex { $0.view === view }
    }
    
    public override func insertArrangedView(_ view: UIView,
                                            at index: Int,
                                            spacing: CGFloat? = nil,
                                            alignment: FlexView.CrossAlignment? = nil) {
        let count = items.count
        precondition(index <= count)
        insertSubview(view, at: index)
        
        let inset = contentInsets
        let align = alignment ?? self.alignment
        let space = spacing ?? self.spacing
        
        let item = BoxHItem(view: view)
        item.makeVCons(alignment: align, inset: inset)
        item.margin = index == 0 ? 0 : space
        
        if view.isHidden {
            let prevView: UIView? = index == 0 ? nil : items[index - 1].view
            view.snp.makeConstraints { (make) in
                if let prevView = prevView {
                    item.left = make.left.equalTo(prevView.snp.right).offset(space).constraint
                } else {
                    item.left = make.left.equalTo(inset.left).constraint
                }
            }
            item.uninstall()
        } else {
            let next = _firstNoHiddenItem(from: index)
            if next?.margin == 0 { next?.margin = space }
            
            let prev = _lastNoHiddenItem(from: index - 1)
            _reconnect(from: next, to: prev, through: item)
        }
        items.insert(item, at: index)
    }
    
    public override func removeArrangedView<View>(at index: Int) -> View? where View : UIView {
        let count = items.count
        precondition(index < count)
        
        let item = items[index]
        item.uninstall()
        
        let view = item.view
        view.removeFromSuperview()
        items.remove(at: index)

        let next = _firstNoHiddenItem(from: index)
        
        let prev = _lastNoHiddenItem(from: index - 1)
        _reconnect(from: next, to: prev, skipOver: item)
        
        return view as? View
    }
    
    public override func hiddenArrangedView<View>(at index: Int) -> View where View : UIView {
        let count = items.count
        precondition(index < count)
        
        let item = items[index]
        
        let view = item.view
        if view.isHidden { return view as! View }
        
        view.isHidden = true
        item.uninstall()
        
        let next = _firstNoHiddenItem(from: index + 1)
        let prev = _lastNoHiddenItem(from: index - 1)
        _reconnect(from: next, to: prev, skipOver: item)
        
        return view as! View
    }
    
    public override func showArrangedView<View>(at index: Int) -> View where View : UIView {
        let count = items.count
        precondition(index < count)
        
        let item = items[index]
        
        let view = item.view
        if !view.isHidden { return view as! View }
        
        view.isHidden = false
        item.installVCons()
        
        let next = _firstNoHiddenItem(from: index + 1)
        let prev = _lastNoHiddenItem(from: index - 1)
        _reconnect(from: next, to: prev, through: item)
        
        return view as! View
    }
    /*
    before: prevItem <- nextItem
    after: prevItem <- item <- nextItem
    */
    private func _reconnect(from nextItem: BoxHItem?, to prevItem: BoxHItem?, through item: BoxHItem) {
        let inset = contentInsets
        let view = item.view
        if let nextItem = nextItem {
            nextItem.left?.deactivate()
            let nextView = nextItem.view
            nextView.snp.makeConstraints { (make) in
                nextItem.left = make.left.equalTo(view.snp.right).offset(nextItem.margin).constraint
            }
            view.snp.makeConstraints { (make) in
                if let prevView = prevItem?.view {
                    item.left = make.left.equalTo(prevView.snp.right).offset(item.margin).constraint
                } else {
                    item.left = make.left.equalTo(inset.left).constraint
                }
            }
        } else {
            let prevView = prevItem?.view
            rightConstraint?.deactivate()
            
            view.snp.makeConstraints { (make) in
                if let prevView = prevView {
                    item.left = make.left.equalTo(prevView.snp.right).offset(item.margin).constraint
                } else {
                    item.left = make.left.equalTo(inset.left).constraint
                }
                rightConstraint = make.right.equalTo(-inset.right).constraint
            }
        }
    }
    /*
    before: prevItem <- item <- nextItem
    after: prevItem <- nextItem
    */
    private func _reconnect(from nextItem: BoxHItem?, to prevItem: BoxHItem?, skipOver item: BoxHItem) {
        let inset = contentInsets
        if let nextItem = nextItem {
            nextItem.left?.deactivate()
            nextItem.view.snp.makeConstraints { (make) in
                if let prevView = prevItem?.view {
                    nextItem.left = make.left.equalTo(prevView.snp.right).offset(nextItem.margin).constraint
                } else {
                    nextItem.left = make.left.equalTo(inset.left).constraint
                }
            }
        } else {
            rightConstraint?.deactivate()
            if let prevView = prevItem?.view {
                prevView.snp.makeConstraints { (make) in
                    rightConstraint = make.right.equalTo(-inset.right).constraint
                }
            } else {
                rightConstraint = nil
            }
        }
    }
    
    private func _firstNoHiddenItem(from index: Int? = nil) -> BoxHItem? {
        return items[(index ?? 0)...].first { !$0.view.isHidden }
    }
    private func _lastNoHiddenItem(from index: Int? = nil) -> BoxHItem? {
        return items[...(index ?? items.count - 1)].last { !$0.view.isHidden }
    }
    
    private class BoxHItem {
        var margin: CGFloat = .zero
        var left: Constraint?
        var top: Constraint?
        var centerY: Constraint?
        var bottom: Constraint?
        
        unowned let view: UIView
        init(view: UIView) {
            self.view = view
        }
        func installCons() {
            left?.activate()
            installVCons()
        }
        func installVCons() {
            top?.activate()
            centerY?.activate()
            bottom?.activate()
        }
        func uninstall() {
            left?.deactivate()
            top?.deactivate()
            centerY?.deactivate()
            bottom?.deactivate()
        }
        func makeVCons(alignment: FlexView.CrossAlignment, inset: UIEdgeInsets) {
            view.snp.makeConstraints { (make) in
                switch(alignment) {
                    
                case .start:
                    top = make.top.equalTo(inset.top).constraint
                    bottom = make.bottom.lessThanOrEqualTo(-inset.bottom).constraint
                case .center:
                    top = make.top.greaterThanOrEqualTo(inset.top).constraint
                    bottom = make.bottom.lessThanOrEqualTo(-inset.bottom).constraint
                    centerY = make.centerY.equalTo(view.superview!).constraint
                case .end:
                    top = make.top.greaterThanOrEqualTo(inset.top).constraint
                    bottom = make.bottom.equalTo(-inset.bottom).constraint
                }
            }
        }
    }
}


final public class BoxVView: BoxView {
    private var items: [BoxVItem] = []
    private var bottomConstraint: Constraint?
    
    public override var arrangedViews: [UIView] {
        return items.map { $0.view }
    }
    public override var arrangedViewsCount: Int {
        return items.count
    }
    public override func indexOfArrangedView<View>(_ view: View) -> Int? where View : UIView {
        items.firstIndex { $0.view === view }
    }
    
    public override func insertArrangedView(_ view: UIView,
                                            at index: Int,
                                            spacing: CGFloat? = nil,
                                            alignment: FlexView.CrossAlignment? = nil) {
        let count = items.count
        precondition(index <= count)
        insertSubview(view, at: index)
        
        let inset = contentInsets
        let align = alignment ?? self.alignment
        let space = spacing ?? self.spacing
        
        let item = BoxVItem(view: view)
        item.makeHCons(alignment: align, inset: inset)
        item.margin = index == 0 ? 0 : space
        
        if view.isHidden {
            let prevView: UIView? = index == 0 ? nil : items[index - 1].view
            view.snp.makeConstraints { (make) in
                if let prevView = prevView {
                    item.top = make.top.equalTo(prevView.snp.bottom).offset(space).constraint
                } else {
                    item.top = make.left.equalTo(inset.top).constraint
                }
            }
            item.uninstall()
        } else {
            let next = _firstNoHiddenItem(from: index)
            if next?.margin == 0 { next?.margin = space }
            
            let prev = _lastNoHiddenItem(from: index - 1)
            _reconnect(from: next, to: prev, through: item)
        }
        items.insert(item, at: index)
    }
    
    public override func removeArrangedView<View>(at index: Int) -> View? where View : UIView {
        let count = items.count
        precondition(index < count)
        
        let item = items[index]
        item.uninstall()
        
        let view = item.view
        view.removeFromSuperview()
        items.remove(at: index)

        let next = _firstNoHiddenItem(from: index)
        
        let prev = _lastNoHiddenItem(from: index - 1)
        _reconnect(from: next, to: prev, skipOver: item)
        
        return view as? View
    }
    
    public override func hiddenArrangedView<View>(at index: Int) -> View where View : UIView {
        let count = items.count
        precondition(index < count)
        
        let item = items[index]
        
        let view = item.view
        if view.isHidden { return view as! View }
        
        view.isHidden = true
        item.uninstall()
        
        let next = _firstNoHiddenItem(from: index + 1)
        let prev = _lastNoHiddenItem(from: index - 1)
        _reconnect(from: next, to: prev, skipOver: item)
        
        return view as! View
    }
    
    public override func showArrangedView<View>(at index: Int) -> View where View : UIView {
        let count = items.count
        precondition(index < count)
        
        let item = items[index]
        
        let view = item.view
        if !view.isHidden { return view as! View }
        
        view.isHidden = false
        item.installHCons()
        
        let next = _firstNoHiddenItem(from: index + 1)
        let prev = _lastNoHiddenItem(from: index - 1)
        _reconnect(from: next, to: prev, through: item)
        
        return view as! View
    }
    /*
    before: prevItem <- nextItem
    after: prevItem <- item <- nextItem
    */
    private func _reconnect(from nextItem: BoxVItem?, to prevItem: BoxVItem?, through item: BoxVItem) {
        let inset = contentInsets
        let view = item.view
        if let nextItem = nextItem {
            nextItem.top?.deactivate()
            let nextView = nextItem.view
            nextView.snp.makeConstraints { (make) in
                nextItem.top = make.top.equalTo(view.snp.bottom).offset(nextItem.margin).constraint
            }
            view.snp.makeConstraints { (make) in
                if let prevView = prevItem?.view {
                    item.top = make.top.equalTo(prevView.snp.bottom).offset(item.margin).constraint
                } else {
                    item.top = make.left.equalTo(inset.top).constraint
                }
            }
        } else {
            let prevView = prevItem?.view
            bottomConstraint?.deactivate()
            
            view.snp.makeConstraints { (make) in
                if let prevView = prevView {
                    item.top = make.top.equalTo(prevView.snp.bottom).offset(item.margin).constraint
                } else {
                    item.top = make.top.equalTo(inset.top).constraint
                }
                bottomConstraint = make.bottom.equalTo(-inset.bottom).constraint
            }
        }
    }
    /*
    before: prevItem <- item <- nextItem
    after: prevItem <- nextItem
    */
    private func _reconnect(from nextItem: BoxVItem?, to prevItem: BoxVItem?, skipOver item: BoxVItem) {
        let inset = contentInsets
        if let nextItem = nextItem {
            nextItem.top?.deactivate()
            nextItem.view.snp.makeConstraints { (make) in
                if let prevView = prevItem?.view {
                    nextItem.top = make.top.equalTo(prevView.snp.bottom).offset(nextItem.margin).constraint
                } else {
                    nextItem.top = make.top.equalTo(inset.top).constraint
                }
            }
        } else {
            bottomConstraint?.deactivate()
            if let prevView = prevItem?.view {
                prevView.snp.makeConstraints { (make) in
                    bottomConstraint = make.bottom.equalTo(-inset.bottom).constraint
                }
            } else {
                bottomConstraint = nil
            }
        }
    }
    
    private func _firstNoHiddenItem(from index: Int? = nil) -> BoxVItem? {
        return items[(index ?? 0)...].first { !$0.view.isHidden }
    }
    private func _lastNoHiddenItem(from index: Int? = nil) -> BoxVItem? {
        return items[...(index ?? items.count - 1)].last { !$0.view.isHidden }
    }
    
    private class BoxVItem {
        var margin: CGFloat = .zero
        var top: Constraint?
        var left: Constraint?
        var centerX: Constraint?
        var right: Constraint?
        
        unowned let view: UIView
        init(view: UIView) {
            self.view = view
        }
        func installCons() {
            top?.activate()
            installHCons()
        }
        func installHCons() {
            left?.activate()
            centerX?.activate()
            right?.activate()
        }
        func uninstall() {
            top?.deactivate()
            left?.deactivate()
            centerX?.deactivate()
            right?.deactivate()
        }
        func makeHCons(alignment: FlexView.CrossAlignment, inset: UIEdgeInsets) {
            view.snp.makeConstraints { (make) in
                switch(alignment) {
                    
                case .start:
                    left = make.left.equalTo(inset.left).constraint
                    right = make.right.lessThanOrEqualTo(-inset.right).constraint
                case .center:
                    left = make.left.greaterThanOrEqualTo(inset.left).constraint
                    right = make.right.lessThanOrEqualTo(-inset.right).constraint
                    centerX = make.centerX.equalTo(view.superview!).constraint
                case .end:
                    left = make.left.greaterThanOrEqualTo(inset.left).constraint
                    right = make.right.equalTo(-inset.right).constraint
                }
            }
        }
    }
}
