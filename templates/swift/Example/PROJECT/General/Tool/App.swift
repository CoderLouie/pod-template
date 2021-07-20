//
//  App.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

enum App {
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
}
