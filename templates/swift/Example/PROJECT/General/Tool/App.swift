//
//  App.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

fileprivate extension DefaultsKeys {
    var appInstallTimestamp: DefaultsKey<TimeInterval> {
        .init("appInstallTimestamp", defaultValue: 0)
    }
    var appIsFirstLauch: DefaultsKey<Bool> {
        .init("appIsFirstLauch", defaultValue: true)
    }
}

enum App {
    struct Environment: OptionSet {
        let rawValue: Int
        init(rawValue: Int) {
            self.rawValue = rawValue
        }
        static var debug: Environment { .init(rawValue: 1 << 0) }
        static var release: Environment { .init(rawValue: 1 << 1) }
        static var development: Environment { .init(rawValue: 1 << 2) }
        static var distributed: Environment { .init(rawValue: 1 << 3) }
    }
    
    static var environment: Environment = {
        var envir: Environment = []
        #if DEBUG
        envir.formUnion(.debug)
        #else
        envir.formUnion(.release)
        #endif
        
        #if DEVELOPMENT
        envir.formUnion(.development)
        #else
        envir.formUnion(.distributed)
        #endif
        
        return envir
    }()
    
    public static var namespace: String {
        guard let namespace =  Bundle.main.infoDictionary?["CFBundleExecutable"] as? String else { return "" }
        return  namespace
    }
    
    public static var version: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public static var build: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    public static var name: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
     
    
    public static func gotoSetting() {
        let url = URL(string: UIApplication.openSettingsURLString)
        openURL(url)
    }
    
    public static func openURL(_ url: URL?, completion: ((Bool) -> Void)? = nil) {
        guard let url = url else { completion?(false); return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        } else {
            UIApplication.shared.openURL(url)
            completion?(true)
        }
    }
    
    public static var installTimestamp: TimeInterval {
        var installTime = Defaults[\.appInstallTimestamp]
        if installTime > 0 { return installTime }
        installTime = Date().timeIntervalSince1970
        Defaults[\.appInstallTimestamp] = installTime
        return installTime
    }
    public static var isFirstLaunch: Bool {
        let isFirst = Defaults[\.appIsFirstLauch]
        if isFirst { return true }
        Defaults[\.appIsFirstLauch] = false
        return false
    }
}
