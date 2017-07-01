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
    private let storeProducts: StoreProductsProtocol
    private let purchasedProducts: PurchasedProductsProtocol
    
    public init(localProducts: LocalProductsProtocol, storeProducts: StoreProductsProtocol, purchasedProducts: PurchasedProductsProtocol) {
        self.localProducts = localProducts
        self.storeProducts = storeProducts
        self.purchasedProducts = purchasedProducts
    }
    
    public var numProducts: Int {
        return localProducts.productsCount
    }
    
    public func localizedNameForProductAtIndex(_ index: Int) -> String {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if storeProducts.productsReceived, let name = storeProducts.localizedNameForProductWithIdentifier(productIdentifier) {
            return name
        } else {
            return NSLocalizedString(localProducts.nameForProductAtIndex(index), comment: "")
        }
    }
    
    public func localizedDescriptionForProductAtIndex(_ index: Int) -> String {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if storeProducts.productsReceived, let description = storeProducts.localizedDescriptionForProductWithIdentifier(productIdentifier) {
            return description
        } else {
            return NSLocalizedString(localProducts.descriptionForProductAtIndex(index), comment: "")
        }
    }
    
    public func localizedPriceForProductAtIndex(_ index: Int) -> String? {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if storeProducts.productsReceived, let price = storeProducts.localizedPriceForProductWithIdentifier(productIdentifier) {
            return price
        }
        return nil
    }
    
    public func stateForProductAtIndex(_ index: Int) -> ProductState {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if purchasedProducts.isPurchasedProductWithIdentifier(productIdentifier) {
            return .purchased
        } else if !storeProducts.productsReceived {
            return .retrieving
        } else {
            return .retrieved
        }
    }
    
    public func identifierForProductAtIndex(_ index: Int) -> String {
        return localProducts.identifierForProductAtIndex(index)
    }
}
