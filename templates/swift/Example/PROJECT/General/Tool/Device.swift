//
//  Device.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

enum Device {
    enum Language: Equatable {
        case en, zhHans, zhHant, other(String)
    }
    
    public static var currentLanguage: Language = {
        guard let code = Bundle.main.preferredLocalizations.first else {
            fatalError()
        }
        if code == "en" {
            return .en
        } else if code.hasPrefix("zh-") {
            // // zh-Hant\zh-HK\zh-TW
            return code.hasSuffix("Hans") ? .zhHans : .zhHant
        } else {
            return .other(code)
        }
    }()
}
