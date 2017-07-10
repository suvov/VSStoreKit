//
//  LocalProducts.swift
//  Example
//
//  Created by Vladimir Shutyuk on 09/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

/*
    Implementation of LocalProductsProtocol.
    Provides information about in-app purchase products we have in our app.
    It should be the same as the in-app purchases in iTunesConnect.
*/

import Foundation
import VSStoreKit


struct LocalProducts: LocalProductsProtocol {
    
    private struct Product {
        let name: String
        let identifier: String
        let description: String
    }
    
    init() {
        let product1 = Product(name: "In-app purchase 1", identifier: "com.example.inappproductone", description: "My In-app purchase #1")
        let product2 = Product(name: "In-app purchase 2", identifier: "com.example.inappproducttwo", description: "My In-app purchase #2")
        products = [product1, product2]
    }
    
    private let products: [Product]
    
    public var productsCount: Int {
        return products.count
    }
    
    public var productIdentifiers: Set<String> {
        let identifiers = products.map { $0.identifier }
        return Set(identifiers)
    }
    
    public func nameForProductAtIndex(_ index: Int) -> String {
        return products[index].name
    }
    
    public func identifierForProductAtIndex(_ index: Int) -> String {
        return products[index].identifier
    }
    
    public func descriptionForProductAtIndex(_ index: Int) -> String {
        return products[index].description
    }
}
