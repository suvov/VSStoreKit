//
//  StoreAccess.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 10/04/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import StoreKit

/**
 `StoreAccess` is responsible for requesting products from the store, providing information about products by conforming to `StoreProductsDataSource`, purchasing products and restoring previous purchases.
 */
public class StoreAccess: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // MARK: Typealiases
    
    /**
     Provides identifier for product that was purchased or restored.
     
     - parameter purchasedProductIdentifier: Identifier for product that was purchased.
    */
    public typealias PurchaseCompletionBlock = (_ purchasedProductIdentifier: String) -> ()

    /**
     A closure that is executed when product purchased.
     
     - warning: If this is nil, `StoreAccess` won't be able to purchase product or restore purchases.
     */
    public var purchaseCompletionHandler: PurchaseCompletionBlock?
    
    
    /// Current `StoreAccess` state.
    public fileprivate(set) var state: StoreAccessState = .unknown {
        didSet {
            NotificationCenter.default.post(name: .storeAccessDidUpdateState, object: self, userInfo: [StoreAccessStateUserInfoKey: state])
        }
    }
    
    fileprivate var products: [SKProduct]?

    
    /// `StoreAccess` singleton.
    public class var shared: StoreAccess {
         struct Static {
            static let instance = StoreAccess()
        }
        return Static.instance
    }
    
    /// :nodoc:
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    /**
     Starts a request for products with provided identifiers.
     
     - paramater identifiers: Set of identifiers for products to be requested.
     */
    public func requestProductsWithIdentifiers(_ identifiers: Set<String>) {
        let productRequest = SKProductsRequest(productIdentifiers: identifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
    /**
     Start purchasing product with provided identifier.
     
     - paramater identifier: Identifier for product to be purchased.
     */
    public func purchaseProductWithIdentifier(_ identifier: String) {
        assert(purchaseCompletionHandler != nil, "*** No transaction completion handler in Store Access.")
        guard SKPaymentQueue.canMakePayments() else {
            state = .cannotMakePayments
            return
        }
        guard let product = productWithIdentifier(identifier) else { return }
        SKPaymentQueue.default().add(SKPayment(product: product))
        state = .purchaseAttempt(productIdentifier: identifier)
    }
    
    /// Start restoring previous purchases.
    public func restorePurchases() {
        assert(purchaseCompletionHandler != nil, "*** No transaction completion handler in Store Access")
        SKPaymentQueue.default().restoreCompletedTransactions()
        state = .restoringPurchases
    }
    
    // MARK: SKProductsRequestDelegate
    /// :nodoc:
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        state = .receivedProducts
    }
    
    /// :nodoc:
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        state = .requestForProductsFailed(error: error)
        print("*** Error loading products \(error)")
    }
    
    // MARK: SKPaymentTransactionObserver
    /// :nodoc:
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completePurchaseForTransaction(transaction)
                state = .purchased
            case .restored:
                completePurchaseForTransaction(transaction)
                state = .restored
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                state = .purchaseFailed(skError: transaction.error as? SKError)
            case .deferred:
                state = .purchaseDeferred
            case .purchasing:
                state = .purchasing
            }
        }
    }
    
    // MARK: Helpers
    private func completePurchaseForTransaction(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        markFinishedTransactionForProductWithIdentifier(transaction.payment.productIdentifier)
    }
    
    private func markFinishedTransactionForProductWithIdentifier(_ identifier: String) {
        if let completion = purchaseCompletionHandler {
            completion(identifier)
        } 
    }
    
    fileprivate func productWithIdentifier(_ identifier: String) -> SKProduct? {
        guard let products = products else { return nil }
        return products.first(where: { $0.productIdentifier == identifier })
    }
}

extension StoreAccess: StoreProductsDataSource {
    
    /// :nodoc:
    public var productsReceived: Bool {
        if let products = products, products.count > 0 {
            return true
        }
        return false
    }
    
    /// :nodoc:
    public func localizedNameForProductWithIdentifier(_ identifier: String) -> String? {
        if let product = productWithIdentifier(identifier) {
            return product.localizedTitle
        }
        return nil
    }
    
    /// :nodoc:
    public func localizedPriceForProductWithIdentifier(_ identifier: String) -> String? {
        if let product = productWithIdentifier(identifier) {
            return localizedPriceForProduct(product)
        }
        return nil
    }
    
    /// :nodoc:
    public func localizedDescriptionForProductWithIdentifier(_ identifier: String) -> String? {
        if let product = productWithIdentifier(identifier) {
            return product.localizedDescription
        }
        return nil
    }
    
    /// :nodoc:
    public func priceForProductWithIdentifier(_ identifier: String) -> NSDecimalNumber? {
        if let product = productWithIdentifier(identifier) {
            return product.price
        }
        return nil
    }
    
    // MARK:
    private func localizedPriceForProduct(_ product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
}
