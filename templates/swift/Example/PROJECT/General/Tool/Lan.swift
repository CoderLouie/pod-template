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
    
    enum Gif: String, GifLocalizedKeyRepresentable {
        case recommend
        
        public var localizeKey: String { "gif_" + rawValue }
    }
}

protocol GifLocalizedKeyRepresentable: LocalizedKeyRepresentable { }

extension GifLocalizedKeyRepresentable {
    public var tableName: String? { "Gif" }
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


