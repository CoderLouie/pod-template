//
//  NotificationCenter+Add.swift
//  PROJECT
//
//  Created by USER_NAME on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation



public extension NotificationCenter {
    
    enum Event: String {
        case userLogout
        case languageDidChange
        
        fileprivate var notificationName: Notification.Name {
            Notification.Name("GO_" + rawValue)
        }
    }
    
    func post(event aEvent: Event, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        post(name: aEvent.notificationName, object: anObject, userInfo: aUserInfo)
    }
    
    func addObserver(_ observer: Any, selector aSelector: Selector, event aEvent: Event, object anObject: Any?) {
        addObserver(observer, selector: aSelector, name: aEvent.notificationName, object: anObject)
    }
}
