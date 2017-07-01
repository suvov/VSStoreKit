//
//  PurchasedProducts.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 01/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import Foundation
@testable import VSStoreKit


class PurchasedProducts: PurchasedProductsProtocol {
    
    var puchasedProductIdentifiers = [String]()
    
    func isPurchasedProductWithIdentifier(_ identifier: String) -> Bool {
        return puchasedProductIdentifiers.contains(identifier)
    }
    
    func markProductAsPurchased(_ identifier: String) {
        puchasedProductIdentifiers.append(identifier)
    }
}
