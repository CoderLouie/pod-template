//
//  Device.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

enum Device {
    static var language: String { 
        return Locale.current.identifier
    }
}