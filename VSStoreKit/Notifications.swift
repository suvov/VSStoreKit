//
//  Notifications.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 01/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation


internal extension Notification.Name {
    
    internal static let storeAccessDidUpdateState = Notification.Name("storeAccessDidUpdateState")
}

internal let StoreAccessStateUserInfoKey = "StoreAccessStateUserInfoKey"
