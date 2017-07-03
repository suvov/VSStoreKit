//
//  LocalProductsMock.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 01/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
@testable import VSStoreKit


class LocalProductsMock: LocalProductsProtocol {
    
    let products: [LocalProduct]
    
    init(products: [LocalProduct]) {
        self.products = products
    }
    
    var productsCount: Int {
        return products.count
    }
    var productIdentifiers: Set<String> {
        let identifiers = products.map { $0.identifier }
        return Set(identifiers)
    }
    
    func nameForProductAtIndex(_ index: Int) -> String {
        return products[index].name
    }
    
    func identifierForProductAtIndex(_ index: Int) -> String {
        return products[index].identifier
    }
    
    func descriptionForProductAtIndex(_ index: Int) -> String {
        return products[index].description
    }
}
