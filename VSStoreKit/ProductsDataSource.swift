//
//  ProductsDataSource.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 07/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation


public class ProductsDataSource {
    
    private let localProducts: LocalProductsDataSource
    private let storeAccess: StoreAccessProtocol
    
    public init(localProducts: LocalProductsDataSource, storeAccess: StoreAccessProtocol) {
        self.localProducts = localProducts
        self.storeAccess = storeAccess
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
    
    public func identifierForProductAtIndex(_ index: Int) -> String {
        return localProducts.identifierForProductAtIndex(index)
    }
}
