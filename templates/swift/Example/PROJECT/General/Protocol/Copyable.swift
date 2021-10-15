//
//  Copyable.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

protocol Copyable: AnyObject {
    associatedtype T
    
    func copyable() -> T
}

extension Copyable where Self: NSObject {
    func copyable() -> Self {
        copy() as! Self
    }
}

extension Copyable where Self: DataConvertible {
    func copyable() -> Self {
        guard let data = try? encode(),
              let copied = try? Self.decode(with: data) else {
            fatalError()
        }
        return copied
    }
}
