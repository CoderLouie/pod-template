//
//  Date+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

public extension Date {
    init?(components: (inout DateComponents) -> Void) {
        let calendar = Calendar(identifier: Calendar.current.identifier)
        var cmps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday], from: Date())
        components(&cmps)
        guard let date = calendar.date(from: cmps) else { return nil }
        self = date
    }
}
