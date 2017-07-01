//
//  ProductsDataSource.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 07/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation


public enum ProductState {
    
    case retrieving
    
    case retrieved
    
    case purchased
}

public class ProductsDataSource {
    
    private let localProducts: LocalProductsProtocol
    private let storeAccess: StoreAccessProtocol
    private let purchasedProducts: PurchasedProductsProtocol
    
    public init(localProducts: LocalProductsProtocol, storeAccess: StoreAccessProtocol, purchasedProducts: PurchasedProductsProtocol) {
        self.localProducts = localProducts
        self.storeAccess = storeAccess
        self.purchasedProducts = purchasedProducts
    }
    
    public var numProducts: Int {
        return localProducts.productsCount
    }
    
    public func localizedNameForProductAtIndex(_ index: Int) -> String {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if storeAccess.productsReceived, let name = storeAccess.localizedNameForProductWithIdentifier(productIdentifier) {
            return name
        } else {
            return NSLocalizedString(localProducts.nameForProductAtIndex(index), comment: "")
        }
    }
    
    public func localizedDescriptionForProductAtIndex(_ index: Int) -> String {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if storeAccess.productsReceived, let description = storeAccess.localizedDescriptionForProductWithIdentifier(productIdentifier) {
            return description
        } else {
            return NSLocalizedString(localProducts.descriptionForProductAtIndex(index), comment: "")
        }
    }
    
    public func localizedPriceForProductAtIndex(_ index: Int) -> String? {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if storeAccess.productsReceived, let price = storeAccess.localizedPriceForProductWithIdentifier(productIdentifier) {
            return price
        }
        return nil
    }
    
    public func stateForProductAtIndex(_ index: Int) -> ProductState {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if purchasedProducts.isPurchasedProductWithIdentifier(productIdentifier) {
            return .purchased
        } else if !storeAccess.productsReceived {
            return .retrieving
        } else {
            return .retrieved
        }
    }
    
    public func identifierForProductAtIndex(_ index: Int) -> String {
        return localProducts.identifierForProductAtIndex(index)
    }
}
