//
//  Dictionary+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

extension Dictionary { 
    func pick(keys: Key...) -> [Key: Value] {
        var result: [Key: Value] = [:]
        keys.forEach { result[$0] = self[$0] }
        return result
    }
    func replaceKeys(using map: [Key: Key]) -> [Key: Value] {
        var result: [Key: Value] = [:]
        for item in self {
            guard let newKey = map[item.key] else { continue }
            result[newKey] = item.value
        }
        return result
    }
}
