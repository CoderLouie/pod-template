//
//  Console.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation
 

public enum Console {
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm:ss.SSSZZZ"
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    static var timeString: String {
        return Self.logFormatter.string(from: Date())
    }
    static var debugLogEnable: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    // 18:25:35.473 ATViewController.swift 26 deinit
    static func log(_ items: Any...,
                  separator: String = " ",
                 terminator: String = "\n",
                       file: NSString = #file,
                       line: Int = #line,
                         fn: String = #function) {
        guard Console.debugLogEnable else { return }
        var prefix = "\(timeString) \(file.lastPathComponent) \(line) \(fn)"
        if prefix.hasSuffix("()") { prefix = String(prefix.dropLast(2)) }
        prefix.append(":")
        let content = items.map { String(describing: $0) }.joined(separator: separator)
        print(prefix, content, terminator: terminator)
    }
    static func logFunc(file: NSString = #file,
                        line: Int = #line,
                        fn: String = #function) {
        guard Console.debugLogEnable else { return }
        var prefix = "\(timeString) \(file.lastPathComponent) \(line) \(fn)"
        if prefix.hasSuffix("()") { prefix = String(prefix.dropLast(2)) }
        print(prefix)
    }
    
    static func short(_ items: Any...,
                  separator: String = " ",
                 terminator: String = "\n") {
        guard Console.debugLogEnable else { return }
        let prefix = "\(timeString)"
        let content = items.map { String(describing: $0) }.joined(separator: separator)
        print(prefix, content, terminator: terminator)
    }
     
    /// 重要的日志记录，测试人员和开发人员查看
    // 18:25:35.473 ATViewController.swift 26
    static func trace(_ items: Any...,
                  separator: String = " ",
                 terminator: String = "\n",
                       file: NSString = #file,
                       line: Int = #line ) {
        guard App.logEnable else { return }
        let content = items.map { String(describing: $0) }.joined(separator: separator)
        NSLog(content)
    }
    
    /// 测试某段代码执行耗时
    static func benchmark(_ work: @escaping () -> Void, completion: @escaping (Double) -> Void) {
        OCBenchmark(work, completion)
    }
}
