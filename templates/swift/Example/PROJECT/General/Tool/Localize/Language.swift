//
//  Localize.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

public enum Language {
    public static func available(excludeBase: Bool = true) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if excludeBase == true,
           let indexOfBase = availableLanguages.firstIndex(of: "Base") {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    private static let CurrentLanguageKey = "CurrentLanguageKey"
    private static let DefaultLanguage = "en"
    //    private static let BaseLanguage = "Base"
    
    public private(set) static var current: String = {
        if let currentLanguage = UserDefaults.standard.object(forKey: CurrentLanguageKey) as? String {
            return currentLanguage
        }
        return `default`
    }()
    
    public static var `default`: String {
        var defaultLanguage: String = DefaultLanguage
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return defaultLanguage
        }
        let availableLanguages = available()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }
        return defaultLanguage
    }
    
    public static func resetCurrentToDefault() {
        setCurrent(to: `default`)
    }
    
    @discardableResult
    public static func setCurrent(to language: String) -> Bool {
        guard language != current,
              available().contains(language) else {
            return false
        }
        current = language
        UserDefaults.standard.set(language, forKey: CurrentLanguageKey)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(event: .languageDidChange, object: nil, userInfo: nil)
        return true
    }
    
    public static func displayName(for language: String, localized: Bool = false) -> String {
//        let locale = NSLocale(localeIdentifier: current)
        let locale = NSLocale(localeIdentifier: localized ? current : language)
        if let displayName = locale.displayName(forKey: .identifier, value: language) {
            return displayName
        }
        return "Not Support"
    }
}
