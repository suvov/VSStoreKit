//
//  StoreAccessState.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 01/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import StoreKit


public enum StoreAccessState {
    
    case unknown
    
    case requestingProducts
    
    case receivedProducts
    
    case requestForProductsFailed(Error)
    
    case purchaseAttempt(String)
    
    case purchasing
    
    case purchased
    
    case restoringPurchases
    
    case restored
    
    case purchaseFailed(SKError?)
    
    case transactionDeferred
}
