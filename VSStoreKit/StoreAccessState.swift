//
//  StoreAccessState.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 01/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import StoreKit

/**
 Represents the current state of Store Access object. This is an extended version of SKPaymentTransactionState.
 */
public enum StoreAccessState {
    
    /// Unknown (initial) state
    case unknown
    
    /// Store access is requesting products from the store.
    case requestingProducts
    
    /// Store access has received products from the store.
    case receivedProducts
    
    /**
     A request for products failed.
     
     - parameter error: The error that caused the request to fail.
     */
    case requestForProductsFailed(error: Error)
    
    /**
     Store access attempting to purchase product.
     
     - parameter productIdentifier: Identifier of a product being purchased.
     */
    case purchaseAttempt(productIdentifier: String)
    
    /// Making payments is not allowed for the user.
    case cannotMakePayments
    
    /// Store access is purchasing product.
    case purchasing
    
    /// Store access has purchased product.
    case purchased
    
    /// Store access is restoring previous purchases.
    case restoringPurchases
    
    
    /// Store access has restored previous purchases.
    case restored
    
    /**
     Purchase of a product failed.
     - parameter skError: An object describing the error that occurred while purchasing product.
     */
    case purchaseFailed(skError: SKError?)
    
    /// Processing product purchase. For more information please check out: https://developer.apple.com/documentation/storekit/skpaymenttransactionstate/1411277-deferred
    case purchaseDeferred
}
