//
//  Lan.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import UIKit
 
 
public enum Lan { }

public extension Lan {
    
    enum Main: String, LocalizedKeyRepresentable {
        case cutout
        case burst
        case photo
        
        public var localizeKey: String { "main_" + rawValue }
    }
}

public extension Lan {
    
    enum Video: String, LocalizedKeyRepresentable {
        case recommend
        
        public var localizeKey: String { "video_" + rawValue }
        public static var tableName: String? { "Video" }
    }
}

public extension Lan {
    
    enum Gif: String, LocalizedKeyRepresentable {
        case recommend
        
        public var localizeKey: String { "gif_" + rawValue }
        public static var tableName: String? { "Gif" }
    }
}


