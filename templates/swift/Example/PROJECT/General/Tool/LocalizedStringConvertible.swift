//
//  LocalizedStringConvertible.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit


public protocol LocalizedStringConvertible {
    var key: String { get }
    var value: String { get }
    
    static var keyPrefix: String? { get }
}
public extension LocalizedStringConvertible {
    var value: String {
        NSLocalizedString(key, tableName:nil, bundle:Bundle.main, value:"", comment:"")
    }
    static var keyPrefix: String? {
        return String(describing: self)
    }
}
extension LocalizedStringConvertible where Self: RawRepresentable, Self.RawValue == String {
    public var key: String {
        if let prefix = Self.keyPrefix {
            return "\(prefix.lowercased())_\(rawValue)"
        }
        return rawValue
    }
    public func format(with args: CVarArg...) -> String {
        String(format: value, arguments: args)
    }
}
extension String {
    public var localized: String {
        NSLocalizedString(self, tableName:nil, bundle:Bundle.main, value:"", comment:"")
    }
    public func localized(with args: CVarArg...) -> String {
        String(format: self.localized, arguments: args)
    }
}


extension UILabel {
    public var localText: LocalizedStringConvertible? {
        get { return nil }
        set { text = newValue?.value }
    }
}
extension UIButton {
    public func setLocalTitle(_ title: LocalizedStringConvertible, for state: UIControl.State) {
        setTitle(title.value, for: state)
    }
}

extension UIBarItem {
    public var localTitle: LocalizedStringConvertible? {
        get { return nil }
        set { title = newValue?.value }
    }
}

extension UINavigationItem {
    public var localTitle: LocalizedStringConvertible? {
        get { return nil }
        set { title = newValue?.value }
    }
}
