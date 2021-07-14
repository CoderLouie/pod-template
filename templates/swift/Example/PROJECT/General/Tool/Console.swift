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
        formatter.dateFormat = "HH:mm:ss.SSSZZZ"
        return formatter
    }()
    static var timeString: String {
        return Self.logFormatter.string(from: Date())
    }
    
    static func log(_ items: Any...,
                  separator: String = " ",
                 terminator: String = "\n",
                       file: NSString = #file,
                       line: Int = #line,
                         fn: String = #function) {
        #if DEBUG
        var prefix = "\(timeString) \(file.lastPathComponent) \(line) \(fn)"
        if prefix.hasSuffix("()") { prefix = String(prefix.dropLast(2)) }
        prefix.append(":")
        let content = items.map { String(describing: $0) }.joined(separator: separator)
        print(prefix, content, terminator: terminator)
        #endif
    }
    static func logFunc(file: NSString = #file,
                        line: Int = #line,
                        fn: String = #function) {
        #if DEBUG
        var prefix = "\(timeString) \(file.lastPathComponent) \(line) \(fn)"
        if prefix.hasSuffix("()") { prefix = String(prefix.dropLast(2)) }
        print(prefix)
        #endif
    }
    
    static func timelog(_ items: Any...,
                  separator: String = " ",
                 terminator: String = "\n") {
        #if DEBUG
        let prefix = "\(timeString)"
        let content = items.map { String(describing: $0) }.joined(separator: separator)
        print(prefix, content, terminator: terminator)
        #endif
    }
    
    // YYKitMacro
    static func benchmark(_ work: @escaping () -> Void, completion: @escaping (Double) -> Void) {
        OCBenchmark(work, completion) 
    }
}
