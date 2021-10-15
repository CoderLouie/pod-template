//
//  DispatchQueue+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Dispatch 

public extension DispatchQueue {
    /// Execute the provided closure after a `TimeInterval`.
    ///
    /// - Parameters:
    ///   - delay:   `TimeInterval` to delay execution.
    ///   - closure: Closure to execute.
    @discardableResult
    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: closure)
        asyncAfter(deadline: .now() + delay, execute: item)
        return item
    }
    
    private static var _onceTracker: Set<String> = []
    
    class func once(file: String = #file, function: String = #function, line: Int = #line, block: () -> Void) {
        let token = [file, function, String(line)].joined(separator: ":")
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) { return }
        
        _onceTracker.insert(token)
        block()
    }
}
