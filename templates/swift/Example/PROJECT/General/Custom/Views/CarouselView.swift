//
//  CarouselView.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

// MARK: - CarouselViewDelegate
protocol CarouselViewDelegate: AnyObject {
    func carouselView(_ carouselView: CarouselView, didSelect cell: CarouselViewCell, at index: Int)
    func carouselView(_ carouselView: CarouselView, didDeselect cell: CarouselViewCell, at index: Int)
    func carouselView(_ carouselView: CarouselView, willAppear cell: CarouselViewCell, at index: Int)
    func carouselView(_ carouselView: CarouselView, willDisappear cell: CarouselViewCell, at index: Int)
}
extension CarouselViewDelegate {
    func carouselView(_ carouselView: CarouselView, didSelectRowAt index: Int) { }
    func carouselView(_ carouselView: CarouselView, didDeselectRowAt index: Int) { }
    func carouselView(_ carouselView: CarouselView, willAppear cell: CarouselViewCell, at index: Int) { }
    func carouselView(_ carouselView: CarouselView, willDisappear cell: CarouselViewCell, at index: Int) { }
}



// MARK: - CarouselViewCell

class CarouselViewCell: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() { }
}


// MARK: - CarouselView
/// 无限循环滚动控件
class CarouselView: UIView {
    
    public weak var delegate: CarouselViewDelegate?
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.delegate = self
        $0.contentInsetAdjustmentBehavior = .never
        addSubview($0)
    }
    
    /// 当前索引, 用于currentCell
    private(set) var currentIndex = 0
    private unowned var currentCell: CarouselViewCell!
    /// next索引, 用于nextCell
    private var nextIndex = -1
    private unowned var nextCell: CarouselViewCell!
    /// 数据源数量
    var itemsCount: Int = 0 {
        willSet {
            guard itemsCount == 0 else {
                fatalError("this property only can modify once")
            }
            guard newValue > 1 else {
                fatalError("the items count should be at least 2")
            }
        }
    }
    
    private var side: CGFloat = 0
    private var targetIndex: Int?
    
    private enum PanDirection {
        case none
        case left
        case fastLeft
        case right
        case fastRight
    }
    private var direction: PanDirection = .none {
        didSet {
            guard oldValue != direction else { return }
            guard direction != .none else { return }
            switch direction {
            case .left:
                nextIndex = targetIndex ?? (currentIndex + 1)
                if nextIndex >= itemsCount { nextIndex = 0 }
                nextCell.frame = nextCell.frame.with {
                    $0.origin.x = side * 2
                }
            case .fastLeft:
                reset()
            case .right:
                nextIndex = targetIndex ?? (currentIndex - 1)
                if nextIndex < 0 { nextIndex = itemsCount - 1 }
                nextCell.frame = nextCell.frame.with {
                    $0.origin.x = 0
                }
            case .fastRight:
                reset()
            case .none:  break
            }
            delegate?.carouselView(self, willDisappear: currentCell, at: currentIndex)
            delegate?.carouselView(self, willAppear: nextCell, at: nextIndex)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard scrollView.bounds.isEmpty else {
            return
        }
        let bounds = self.bounds
        let width = bounds.width
        side = width
        
        // scroll
        scrollView.frame = bounds
        scrollView.contentInset = .zero
        scrollView.contentSize = CGSize(width: width * 3, height: 0)
        scrollView.contentOffset = CGPoint(x: width, y: 0)
        
        // cells
        currentCell.frame = CGRect(origin: CGPoint(x: width, y: 0), size: bounds.size)
        nextCell.frame = CGRect(origin: CGPoint(x: width * 2, y: 0), size: bounds.size)
        delegate?.carouselView(self, didSelect: currentCell, at: currentIndex)
    }
}

// MARK: - Public Method
extension CarouselView {
    var isTracking: Bool { scrollView.isTracking }
    var isDragging: Bool { scrollView.isDragging }
    var isDecelerating: Bool { scrollView.isDecelerating }
    
    public var isScrollEnabled: Bool {
        get { scrollView.isScrollEnabled }
        set { scrollView.isScrollEnabled = newValue }
    }
    
    /// 滚动到指定位置
    func scrollToIndex(_ index: Int) {
        guard index >= 0 else { return }
        let idx = index % itemsCount
        guard currentIndex != idx else { return }
        targetIndex = idx
        if idx > currentIndex {
            forward()
        } else {
            backward()
        }
    }
    
    func forward() {
        scrollView.setContentOffset(CGPoint(x: side * 2, y: 0), animated: true)
    }
    func backward() {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    /// 注册cell
    func register<T: CarouselViewCell>(_ cellClass: T.Type) {
        currentCell = T().then {
            $0.clipsToBounds = true
            scrollView.addSubview($0)
        }
        nextCell = T().then {
            $0.clipsToBounds = true
            scrollView.addSubview($0)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension CarouselView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingDidEnd()
    }
    private func scrollingDidEnd() {
        direction = .none
        let index = scrollView.contentOffset.x / side
        if index == 1 { return }
        
        delegate?.carouselView(self, didDeselect: currentCell, at: currentIndex)
        delegate?.carouselView(self, didSelect: nextCell, at: nextIndex)
        
        reset()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize != .zero else {
            return
        }
        let offsetX = scrollView.contentOffset.x
        
//        Console.log("CarouselView \(offsetX)")
        if offsetX > side {
            direction = .left
            if offsetX > side * 2.05 {
                direction = .fastLeft
            }
        } else if offsetX < side {
            direction = .right
            if offsetX < -side * 0.05 {
                direction = .fastRight
            }
        } else {
            direction = .none
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollingDidEnd()
    }
     
    private func reset() {
        (currentIndex, nextIndex) = (nextIndex, currentIndex)
         
        (currentCell.frame, nextCell.frame) = (nextCell.frame, currentCell.frame)
         
        (currentCell, nextCell) = (nextCell, currentCell)
        scrollView.contentOffset = CGPoint(x: side, y: 0)
        targetIndex = nil
    }
}
