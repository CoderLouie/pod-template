//
//  Archivable.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

/// 可持久化的
public protocol Persistencable: DataCodable { }

extension Persistencable {
    @discardableResult
    func save(toFile path: String) -> Bool {
        do {
            let data = try encode()
            try data.write(to: URL(fileURLWithPath: path), options: .atomic)
            return true
        } catch {
            return false
        }
    }
    static func load(fromFile path: String) -> Self? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try decode(with: data)
        } catch {
            return nil
        }
    }
} 


