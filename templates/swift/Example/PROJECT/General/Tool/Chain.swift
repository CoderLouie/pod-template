//
//  Chain.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

@dynamicMemberLookup
/// 用于实现链式调用
struct Chain<Target> {
    let target: Target
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Target, Value>) -> (Value) -> Chain<Target> {
        var target = self.target
        return {
            target[keyPath: keyPath] = $0
            return Chain(target: target)
        }
    }
}
