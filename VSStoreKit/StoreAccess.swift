//
//  StoreAccess.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 10/04/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import StoreKit


public class StoreAccess: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    public typealias PurchaseCompletionHandler = (_ purchasedProductIdentifier: String) -> ()

    public var purchaseCompletion: PurchaseCompletionHandler?
    
    public fileprivate(set) var state: StoreAccessState = .unknown {
        didSet {
            NotificationCenter.default.post(name: .storeAccessDidUpdateState, object: self, userInfo: [StoreAccessStateUserInfoKey: state])
        }
    }
    
    fileprivate var products: [SKProduct]?

    
    // MARK:
    public class var shared: StoreAccess {
         struct Static {
            static let instance = StoreAccess()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    // MARK: SKProductsRequestDelegate
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        state = .receivedProducts
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        state = .requestForProductsFailed(error)
        print("*** Error loading products \(error)")
    }
    
    // MARK: SKPaymentTransactionObserver
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                state = .purchased
                completePurchaseForTransaction(transaction)
            case .restored:
                state = .restored
                completePurchaseForTransaction(transaction)
            case .failed:
                state = .purchaseFailed(transaction.error as? SKError)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                state = .transactionDeferred
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
        if let completion = purchaseCompletion {
            completion(identifier)
        } 
    }
}

extension StoreAccess: StoreProductsProtocol {
    
    public func requestProductsWithIdentifiers(_ identifiers: Set<String>) {
        let productRequest = SKProductsRequest(productIdentifiers: identifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
    public var productsReceived: Bool {
        if let products = products, products.count > 0 {
            return true
        }
        return false
    }
    
    public func localizedNameForProductWithIdentifier(_ identifier: String) -> String? {
        if let product = productWithIdentifier(identifier) {
            return product.localizedTitle
        }
        return nil
    }
    
    public func localizedPriceForProductWithIdentifier(_ identifier: String) -> String? {
        if let product = productWithIdentifier(identifier) {
            return localizedPriceForProduct(product)
        }
        return nil
    }
    
    public func localizedDescriptionForProductWithIdentifier(_ identifier: String) -> String? {
        if let product = productWithIdentifier(identifier) {
            return product.localizedDescription
        }
        return nil
    }
    
    public func purchaseProductWithIdentifier(_ identifier: String) {
        assert(purchaseCompletion != nil, "*** No transaction completion handler in Store Access.")
        guard let product = productWithIdentifier(identifier) else { return }
        SKPaymentQueue.default().add(SKPayment(product: product))
        state = .purchaseAttempt(identifier)
    }
    
    public func restorePurchases() {
        assert(purchaseCompletion != nil, "*** No transaction completion handler in Store Access")
        SKPaymentQueue.default().restoreCompletedTransactions()
        state = .restoringPurchases
    }
    
    // MARK:
    private func productWithIdentifier(_ identifier: String) -> SKProduct? {
        guard let products = products else { return nil }
        return products.first(where: { $0.productIdentifier == identifier })
    }
    
    private func localizedPriceForProduct(_ product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
}
