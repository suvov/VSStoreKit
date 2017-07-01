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
        NotificationCenter.default.addObserver(self, selector: #selector(storeAccessDidUpdateState), name: .storeAccessDidUpdateState, object: nil)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .storeAccessDidUpdateState, object: nil)
    }
    
    func storeAccessDidUpdateState() {
        let state = StoreAccess.shared.state
        switch state {
        case .receivedProducts:
            receivedProducts()
        case .requestForProductsFailed:
            requestForProductsFailed()
        case .purchased:
            purchasedProduct()
        case .restored:
            restoredProduct()
        case .purchaseFailed:
            purchaseFailed()
        default:
            break
        }
    }
    
    // MARK:
    open func receivedProducts() {
        //
    }
    
    open func requestForProductsFailed() {
        //
    }
    
    open func purchasedProduct() {
        //
    }
    
    open func restoredProduct() {
        //
    }
    
    open func purchaseFailed() {
        //
    }
}
