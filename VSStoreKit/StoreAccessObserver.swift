//
//  StoreAccessObserver.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 09/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import StoreKit


public class StoreAccessObserver: NSObject {
    
    public typealias EmptyBlock = (() -> Void)
    public typealias ErrorBlock =  ((Error) -> Void)
    public typealias StringBlock = ((String) -> Void)
    public typealias SKErrorBlock = ((SKError?) -> Void)
    
    
    public var unknownStateHandler: EmptyBlock?
    
    public var requestingProductsStateHandler: EmptyBlock?
    
    public var receivedProductsStateHandler: EmptyBlock?
    
    public var requestForProductsFailedStateHandler: ErrorBlock?
    
    public var purchaseAttemptStateHandler: StringBlock?
    
    public var purchasingStateHandler: EmptyBlock?
    
    public var purchasedStateHandler: EmptyBlock?
    
    public var restoringPurchasesStateHandler: EmptyBlock?
    
    public var restoredPurchasesStateHandler: EmptyBlock?
    
    public var purchaseFailedStateHandler: SKErrorBlock?
    
    public var purchaseDeferredStateHandler: EmptyBlock?

 
    override public init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(storeAccessDidUpdateState), name: .storeAccessDidUpdateState, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .storeAccessDidUpdateState, object: nil)
    }
    
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
