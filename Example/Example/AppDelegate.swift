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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        StoreAccess.shared.purchaseCompletion = { purchasedProductIdentifier in
            PurchasedProducts().markProductAsPurchased(purchasedProductIdentifier)
        }
        return true
    }
}
