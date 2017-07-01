//
//  StoreViewController.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 07/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import UIKit


open class StoreViewController: UIViewController {
    
    // MARK: Lifecycle
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToStoreAccessNotifications()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromStoreAccessNotifications()
    }
    
    // MARK: Store notifications
    private func subscribeToStoreAccessNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.productsReceived), name: .storeAccessReceivedProducts, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.requestForProductsFailed), name: .storeAccessRequestFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.productPurchased), name: .storeAccessDidPurchase, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.productRestored), name: .storeAccessDidRestorePurchases, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.productPurchaseFailed), name: .storeAccessDidFailPurchasing, object: nil)
    }
    
    private func unsubscribeFromStoreAccessNotifications() {
        NotificationCenter.default.removeObserver(self, name: .storeAccessReceivedProducts, object: nil)
        NotificationCenter.default.removeObserver(self, name: .storeAccessRequestFailed, object: nil)
        NotificationCenter.default.removeObserver(self, name: .storeAccessDidPurchase, object: nil)
        NotificationCenter.default.removeObserver(self, name: .storeAccessDidRestorePurchases, object: nil)
        NotificationCenter.default.removeObserver(self, name: .storeAccessDidFailPurchasing, object: nil)
    }
    
    // MARK:
    open func productsReceived() {
        //
    }
    
    open func requestForProductsFailed() {
        //
    }
    
    open func productPurchased() {
        //
    }
    
    open func productRestored() {
        //
    }
    
    open func productPurchaseFailed(_ notification: Notification?) {
        //
    }
}
