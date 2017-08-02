//
//  Protocols.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 11/06/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation

/**
 An instance conforming to `LocalProductsDataSource` represents a data source of in-app purchase items (products)
 available before requesting products from the store.
 */
public protocol LocalProductsDataSource {
    
    /// The number of products.
    var productsCount: Int { get }
    
    /// The Set of product identifiers.
    var productIdentifiers: Set<String> { get }
    
    /**
     - parameter index: An index of product in the data source.
     
     - returns: Non-localized name for product on specified index.
     */
    func nameForProductAtIndex(_ index: Int) -> String
    
    /**
     - parameter index: An index of product in the data source.
     
     - returns: Identifier for product on specified index.
     */
    func identifierForProductAtIndex(_ index: Int) -> String
    
    /**
     - parameter index: An index of product in the data source.
     
     - returns: Non-localized description for product on specified index.
     */
    func descriptionForProductAtIndex(_ index: Int) -> String
}

/**
 An instance conforming to `StoreProductsDataSource` represents a data source of in-app purchase items (products)
 fetched from the store.
 */
public protocol StoreProductsDataSource {
    
    /** 
     True if products were received from the store, false otherwise.
     */
    var productsReceived: Bool { get }
    
    /** 
     Localized name for product with identifier returned by the store. 
     
     - parameter identifier: Identifier of a product.
     
     - returns: Localized name for product if `productsReceived` is true, nil otherwise.
     */
    func localizedNameForProductWithIdentifier(_ identifier: String) -> String?
    
    /**
     Localized price for product with identifier returned by the store.
     
     - parameter identifier: Identifier of a product.
     
     - returns: Localized price string for product if `productsReceived` is true, nil otherwise.
     */
    func localizedPriceForProductWithIdentifier(_ identifier: String) -> String?
    
    /**
     Localized description for product with identifier returned by the store.
     
     - parameter identifier: Identifier of a product.
     
     - returns: Localized description for product if `productsReceived` is true, nil otherwise.
     */
    func localizedDescriptionForProductWithIdentifier(_ identifier: String) -> String?
    
    /**
     Price for product with identifier returned by the store.
     
     - parameter identifier: Identifier of a product.
     
     - returns: Price for product if `productsReceived` is true, nil otherwise.
     */
    func priceForProductWithIdentifier(_ identifier: String) -> NSDecimalNumber?
    
    /**
     Price locale for products returned by the store.
     
     - returns: Current price locale for products if `productsReceived` is true, nil otherwise.
     */
    func priceLocaleForProducts() -> Locale?
}

/**
 An instance conforming to `PurchasedProductsProtocol` is responsible for keeping information about products that were purchased.
 */
public protocol PurchasedProductsProtocol {
    
    /**
     - parameter identifier: Identifier of a product.
     
     - returns: true if product is purchased and false otherwise
     */
    func isPurchasedProductWithIdentifier(_ identifier: String) -> Bool
    
    /**
     Persists information that product is purchased.
     - parameter identifier: Identifier of a purchased product.
     */
    func markProductAsPurchased(_ identifier: String)
}
