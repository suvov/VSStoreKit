//
//  StoreAccess+Notifications.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 01/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation


public extension Notification.Name {
    
    public static let storeAccessReceivedProducts = Notification.Name("storeAccessReceivedProducts")
    public static let storeAccessRequestFailed = Notification.Name("storeAccessRequestFailed")
    
    public static let storeAccessPurchaseAttempt = Notification.Name("storeAccessPurchaseAttempt")
    
    public static let storeAccessPurchasing = Notification.Name("storeAccessPurchasing")
    public static let storeAccessDidPurchase = Notification.Name("storeAccessDidPurchase")
    public static let storeAccessDidFailPurchasing = Notification.Name("storeAccessDidFailPurchasing")
    
    public static let storeAccessRestoringPurchases = Notification.Name("storeAccessRestoringPurchases")
    public static let storeAccessDidRestorePurchases = Notification.Name("storeAccessDidRestorePurchases")
    
    public static let storeAccessTransactionDeferred = Notification.Name("storeAccessTransactionDeferred")
}

public extension StoreAccess {
    
    public static let storeAccessPurchaseAttemptProductIdentifierKey = "storeAccessPurchaseAttemptProductIdentifierKey"
    public static let storeAccessDidFailPurchasingSKErrorKey = "storeAccessDidFailPurchasingSKErrorKey"
}

