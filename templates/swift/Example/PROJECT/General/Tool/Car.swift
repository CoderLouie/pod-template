//
//  Car.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

@objcMembers class Car: NSObject {
    
    var price: Double
    var band: String
    init(price: Double, band: String) {
        self.price = price
        self.band = band
    }
    func run() {
        print(price, band, "run")
    }
    static func run() {
        print("Car run")
    } 
}

extension Car {
    func test() {
        print(price, band, "test")
        
    }
    
}
