//
//  StoreAccess.swift
//  VSStore
//
//  Created by Vladimir Shutyuk on 10/04/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
import StoreKit


public class StoreAccess: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    public typealias PurchaseCompletionHandler = (_ purchasedProductIdentifier: String) -> ()
    
    fileprivate var products: [SKProduct]?
    
    public var purchaseCompletion: PurchaseCompletionHandler?
    
    
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
        NotificationCenter.default.post(name: .storeAccessReceivedProducts, object: self)
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        NotificationCenter.default.post(name: .storeAccessRequestFailed, object: self)
        print("*** Error loading products \(error)")
    }
    
    // MARK: SKPaymentTransactionObserver
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completePurchaseForTransaction(transaction)
                NotificationCenter.default.post(name: .storeAccessDidPurchase, object: self)
            case .restored:
                completePurchaseForTransaction(transaction)
                NotificationCenter.default.post(name: .storeAccessDidRestorePurchases, object: self)
            case .failed:
                failedTransaction(transaction)
            case .deferred:
                NotificationCenter.default.post(name: .storeAccessTransactionDeferred, object: self)
            case .purchasing:
                NotificationCenter.default.post(name: .storeAccessPurchasing, object: self)
            }
        }
    }
    
    // MARK: Helpers
    private func completePurchaseForTransaction(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        let identifier = transaction.payment.productIdentifier
        markFinishedTransactionForProductWithIdentifier(identifier)
    }
    
    private func markFinishedTransactionForProductWithIdentifier(_ identifier: String) {
        if let completion = purchaseCompletion {
            completion(identifier)
        } 
    }
    
    private func failedTransaction(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        if let error = transaction.error as? SKError {
            NotificationCenter.default.post(name: .storeAccessDidFailPurchasing, object: self, userInfo: [StoreAccess.storeAccessDidFailPurchasingSKErrorKey: error])
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
        NotificationCenter.default.post(name: .storeAccessPurchaseAttempt, object: self, userInfo: [StoreAccess.storeAccessPurchaseAttemptProductIdentifierKey: identifier])
    }
    
    public func restorePurchases() {
        assert(purchaseCompletion != nil, "*** No transaction completion handler in Store Access")
        NotificationCenter.default.post(name: .storeAccessRestoringPurchases, object: self)
        SKPaymentQueue.default().restoreCompletedTransactions()
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
