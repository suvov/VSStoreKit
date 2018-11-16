//
//  AppDelegate.swift
//  Example
//
//  Created by Vladimir Shutyuk on 09/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import UIKit
import VSStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        StoreAccess.shared.purchaseCompletionHandler = { purchasedProductIdentifier in
            PurchasedProducts().markProductAsPurchased(purchasedProductIdentifier)
        }
        return true
    }
}
