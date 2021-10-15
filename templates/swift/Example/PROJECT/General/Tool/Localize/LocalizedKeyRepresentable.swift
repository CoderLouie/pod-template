//
//  LocalizedStringConvertible.swift
//  VideoCutter
//
//  Created by liyang on 07/20/2021.
//  Copyright (c) 2021 gomo. All rights reserved.
//

import UIKit

public protocol LocalizedKeyRepresentable {
    var localizeKey: String { get }
    
    var tableName: String? { get }
    static var bundle: Bundle { get }
}
public extension LocalizedKeyRepresentable {
    var localized: String {
        NSLocalizedString(localizeKey, tableName: tableName, bundle: Self.bundle, value:"", comment:"")
    }
    
    func localizedFormat(with args: CVarArg...) -> String {
        String(format: localized, arguments: args)
    }
    var tableName: String? { nil }
    static var bundle: Bundle { .main }
}


extension LocalizedKeyRepresentable where Self: RawRepresentable, Self.RawValue == String {
    public var localizeKey: String {
        return rawValue
    }
}

extension String: LocalizedKeyRepresentable {
    public var localizeKey: String { self }
}



public struct LocalizedKey: LocalizedKeyRepresentable {
    public var localizeKey: String { key }
    public var tableName: String? { tableFileName }
    public private(set) var key: String
    public private(set) var tableFileName: String
    init(_ key: String, _ tableFileName: String) {
        self.key = key
        self.tableFileName = tableFileName
    }
}
extension String {
    var gif: LocalizedKey {
        LocalizedKey(self, "Gif")
    }
}



extension UILabel {
    public var localizeKey: LocalizedKeyRepresentable? {
        get { return nil }
        set { text = newValue?.localized }
    }
}
extension UIButton {
    public func setLocalizeKey(_ title: LocalizedKeyRepresentable, for state: UIControl.State) {
        setTitle(title.localized, for: state)
    }
}

extension UIBarItem {
    public var localizeKey: LocalizedKeyRepresentable? {
        get { return nil }
        set { title = newValue?.localized }
    }
}

extension UINavigationItem {
    public var localizeKey: LocalizedKeyRepresentable? {
        get { return nil }
        set { title = newValue?.localized }
    }
}
extension UITextField {
    public var localizeKey: LocalizedKeyRepresentable? {
        get { nil }
        set { placeholder = newValue?.localized }
    }
}
