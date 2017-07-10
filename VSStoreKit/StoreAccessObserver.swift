//
//  StoreAccessObserver.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 09/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import StoreKit

/// `StoreAccessObserver` observes `StoreAccess` state. Client may react to state change of it's interest by providing handler closure.
public class StoreAccessObserver: NSObject {
    
    // MARK: Typealiases
    
    /// A block that takes no parameters and returns nothing
    public typealias EmptyBlock = (() -> Void)
    
    /// A block with Error parameter.
    public typealias ErrorBlock =  ((Error) -> Void)
    
    /// A block with String parameter.
    public typealias StringBlock = ((String) -> Void)
    
    /// A block with SKError? parameter.
    public typealias SKErrorBlock = ((SKError?) -> Void)
    
    // MARK: Store Access state change handlers
    
    /// `Store Access` state has changed to .unknown
    public var unknownStateHandler: EmptyBlock?
    
    /// `Store Access` state has changed to .requestingProducts
    public var requestingProductsStateHandler: EmptyBlock?
    
    /// `Store Access` state has changed to .receivedProducts
    public var receivedProductsStateHandler: EmptyBlock?
    
    /// `Store Access` state has changed to .requestForProductsFailed
    public var requestForProductsFailedStateHandler: ErrorBlock?
    
    /// `Store Access` state has changed to .purchaseAttempt
    public var purchaseAttemptStateHandler: StringBlock?
    
    /// `Store Access` state has changed to .purchasingState
    public var purchasingStateHandler: EmptyBlock?
    
    /// `Store Access` state has changed to .purchasedState
    public var purchasedStateHandler: EmptyBlock?
    
    /// `Store Access` state has changed to .restoringPurchases
    public var restoringPurchasesStateHandler: EmptyBlock?
    
    /// `Store Access` state has changed to .restoredPurchases
    public var restoredPurchasesStateHandler: EmptyBlock?
    
    /// `Store Access` state has changed to .purchaseFailed
    public var purchaseFailedStateHandler: SKErrorBlock?
    
    /// `Store Access` state has changed to .purchaseDeferred
    public var purchaseDeferredStateHandler: EmptyBlock?

    /// :nodoc:
    override public init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(storeAccessDidUpdateState), name: .storeAccessDidUpdateState, object: nil)
    }
    
    /// :nodoc:
    deinit {
        NotificationCenter.default.removeObserver(self, name: .storeAccessDidUpdateState, object: nil)
    }
    
    /// :nodoc:
    func storeAccessDidUpdateState(_ notification: Notification?) {
        guard let state = notification?.userInfo?[StoreAccessStateUserInfoKey] as? StoreAccessState else { return }
        switch state {
        case .unknown:
            unknownStateHandler?()
        case .requestingProducts:
            requestingProductsStateHandler?()
        case .receivedProducts:
            receivedProductsStateHandler?()
        case .requestForProductsFailed(let error):
            requestForProductsFailedStateHandler?(error)
        case .purchaseAttempt(let productIdentifier):
            purchaseAttemptStateHandler?(productIdentifier)
        case .purchasing:
            purchasingStateHandler?()
        case .purchased:
            purchasedStateHandler?()
        case .restoringPurchases:
            restoringPurchasesStateHandler?()
        case .restored:
            restoredPurchasesStateHandler?()
        case .purchaseFailed(let skError):
            purchaseFailedStateHandler?(skError)
        case .purchaseDeferred:
            purchaseDeferredStateHandler?()
        }
    }
}
