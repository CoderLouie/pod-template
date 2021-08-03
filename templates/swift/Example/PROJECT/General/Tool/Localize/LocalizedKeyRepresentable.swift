//
//  LocalizedStringConvertible.swift
//  VideoCutter
//
//  Created by liyang on 07/20/2021.
//  Copyright (c) 2021 gomo. All rights reserved.
//

import UIKit

/*
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
*/
public protocol LocalizedKeyRepresentable {
    var localizeKey: String { get }
    
    static var tableName: String? { get }
    static var bundle: Bundle { get }
}
public extension LocalizedKeyRepresentable {
    var localized: String {
        NSLocalizedString(localizeKey, tableName: Self.tableName, bundle: Self.bundle, value:"", comment:"")
    }
    
//    func localized(using tableName: String? = nil, in bundle: Bundle? = nil) -> String {
//        let bundle: Bundle = bundle ?? .main
//        let targetPath = bundle.path(forResource: Language.current, ofType: "lproj") ?? bundle.path(forResource: Language.BaseLanguage, ofType: "lproj")
//        guard let path = targetPath,
//              let bundle = Bundle(path: path) else { return localizeKey }
//        return bundle.localizedString(forKey: localizeKey, value: nil, table: tableName)
//    }
    
    func localizedFormat(with args: CVarArg...) -> String {
        String(format: localized, arguments: args)
    }
//    func localizedFormat(with args: CVarArg..., using tableName: String?, in bundle: Bundle? = nil) -> String {
//        String(format: localized(using: tableName, in: bundle), arguments: args)
//    }
    static var tableName: String? { nil }
    static var bundle: Bundle { .main }
}


extension LocalizedKeyRepresentable where Self: RawRepresentable, Self.RawValue == String {
    public var localizeKey: String {
        return rawValue
    }
}


//extension String: LocalizedKeyRepresentable {
//    public var localizeKey: String { self }
//}


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
