//
//  PurchasedProducts.swift
//  Example
//
//  Created by Vladimir Shutyuk on 09/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//  
//

/*
    Implementation of PurchasedProductsProtocol.
    Provides information about purchased products and saves what products were purchased.
    This implementation uses UserDefaults, but you may use Keychain or any other way of
    persisting information about purchases.
*/

import Foundation
import VSStoreKit


struct PurchasedProducts: PurchasedProductsProtocol {
    
    func isPurchasedProductWithIdentifier(_ identifier:String) -> Bool {
        return UserDefaults.standard.bool(forKey: identifier)
    }
    
    func markProductAsPurchased(_ identifier: String) {
        UserDefaults.standard.set(true, forKey: identifier)
    }
}
