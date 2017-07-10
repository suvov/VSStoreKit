//
//  ProductsDataSource.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 07/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation

/// A `ProductsDataSource` is responsible for providing actual products data, given `LocalProductsDataSource` and `StoreProductsDataSource` objects.
public class ProductsDataSource {
    
    private let localProducts: LocalProductsDataSource
    private let storeProducts: StoreProductsDataSource
    
    /**
     Initializes a new products data source.
     
     - parameter localProducts: `LocalProductsDataSource` object.
     - parameter storeProducts: `StoreProductsDataSource` object.

     - returns: A new `ProductsDataSource` instance.
     */
    public init(localProducts: LocalProductsDataSource, storeProducts: StoreProductsDataSource) {
        self.localProducts = localProducts
        self.storeProducts = storeProducts
    }
    
    /// The number of products.
    public var numProducts: Int {
        return localProducts.productsCount
    }
    
    /**
     Localized name for product at index. If products received from the store, returns localized name received from the store, otherwise returns name of corresponding local product, localized with NSLocalizedString macro.
     
     - parameter index: An index of product in the data source.
     
     - returns: Localized name for product on specified index.
     */
    public func localizedNameForProductAtIndex(_ index: Int) -> String {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if storeProducts.productsReceived, let name = storeProducts.localizedNameForProductWithIdentifier(productIdentifier) {
            return name
        } else {
            return NSLocalizedString(localProducts.nameForProductAtIndex(index), comment: "")
        }
    }
    
    /**
     Localized description for product at index. If products received from the store, returns localized description received from the store, otherwise returns description of corresponding local product, localized with NSLocalizedString macro.
     
     - parameter index: An index of product in the data source.
     
     - returns: Localized description for product on specified index.
     */
    public func localizedDescriptionForProductAtIndex(_ index: Int) -> String {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if storeProducts.productsReceived, let description = storeProducts.localizedDescriptionForProductWithIdentifier(productIdentifier) {
            return description
        } else {
            return NSLocalizedString(localProducts.descriptionForProductAtIndex(index), comment: "")
        }
    }
    
    /**
     Localized price for product at index. If products received from the store, returns localized price received from the store, otherwise returns nil.
     
     - parameter index: An index of product in the data source.
     
     - returns: Localized price for product on specified index.
     */
    public func localizedPriceForProductAtIndex(_ index: Int) -> String? {
        let productIdentifier = localProducts.identifierForProductAtIndex(index)
        if storeProducts.productsReceived, let price = storeProducts.localizedPriceForProductWithIdentifier(productIdentifier) {
            return price
        }
        return nil
    }
    
    /**
     - parameter index: An index of product in the data source.
     
     - returns: Identifier for product on specified index.
     */
    public func identifierForProductAtIndex(_ index: Int) -> String {
        return localProducts.identifierForProductAtIndex(index)
    }
}
