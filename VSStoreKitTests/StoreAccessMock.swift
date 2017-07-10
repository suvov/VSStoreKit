//
//  StoreAccessMock.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 01/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
@testable import VSStoreKit


class StoreAccessMock: StoreProductsDataSource {
    
    var productsReceivedSettable = false
    
    let products: [StoreProduct]
    
    init(products: [StoreProduct]) {
        self.products = products
    }
        
    var productsReceived: Bool {
        return productsReceivedSettable
    }
    
    func localizedNameForProductWithIdentifier(_ identifier: String) -> String? {
        return productWithIdentifier(identifier)?.name
    }
    
    func localizedPriceForProductWithIdentifier(_ identifier: String) -> String? {
        return productWithIdentifier(identifier)?.price
    }
    
    func localizedDescriptionForProductWithIdentifier(_ identifier: String) -> String? {
        return productWithIdentifier(identifier)?.description
    }
    
    private func productWithIdentifier(_ identifier: String) -> StoreProduct? {
        return products.first(where: { $0.identifier == identifier })
    }
}
