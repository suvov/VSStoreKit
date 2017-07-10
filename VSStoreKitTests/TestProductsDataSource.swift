//
//  TestProductsDataSource.swift
//  VSStoreKit
//
//  Created by Vladimir Shutyuk on 01/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import XCTest
@testable import VSStoreKit


class TestProductsDataSource: XCTestCase {
    
    private let localProductsArray = [LocalProduct(name: "Local name 1", identifier:"xyz.suvov.productone", description:"Local description 1"),
                                     LocalProduct(name: "Local name 2", identifier:"xyz.suvov.producttwo", description:"Local description 2")]
    
    private let storeProductsArray = [StoreProduct(name: "Store name 1", identifier:"xyz.suvov.productone", description:"Store description 1", price: "$1"),
                                     StoreProduct(name: "Store name 2", identifier:"xyz.suvov.producttwo", description:"Store description 2", price: "$2")]
    
    private var localProducts: LocalProductsMock!
    private var purchasedProducts: PurchasedProducts!
    private var storeAccessMock: StoreAccessMock!
    private var productsDataSource: ProductsDataSource!
    
    
    func testThatProductsDataSourceReturnsCorrectNumberOfProducts() {
        XCTAssertEqual(localProductsArray.count, productsDataSource.numProducts)
    }
    
    func testThatProductsDataSourceReturnsCorrectProductIdentifier() {
        for (index, _) in localProductsArray.enumerated() {
            XCTAssertEqual(localProductsArray[index].identifier, productsDataSource.identifierForProductAtIndex(index))
            XCTAssertEqual(localProductsArray[index].identifier, productsDataSource.identifierForProductAtIndex(index))
        }
    }
    
    func testThatProductsDataSourceReturnsCorrectLocalProductNamePriceAndDescription() {
        for (index, _) in localProductsArray.enumerated() {
            XCTAssertEqual(localProductsArray[index].name, productsDataSource.localizedNameForProductAtIndex(index))
            XCTAssertEqual(localProductsArray[index].description, productsDataSource.localizedDescriptionForProductAtIndex(index))
            XCTAssertNil(productsDataSource.localizedPriceForProductAtIndex(index))
        }
    }
    
    func testThatProductsDataSourceReturnsCorrectStoreProductNamePriceAndDescription() {
        storeAccessMock.productsReceivedSettable = true 
        for (index, _) in localProductsArray.enumerated() {
            XCTAssertEqual(storeProductsArray[index].name, productsDataSource.localizedNameForProductAtIndex(index))
            XCTAssertEqual(storeProductsArray[index].description, productsDataSource.localizedDescriptionForProductAtIndex(index))
            XCTAssertEqual(storeProductsArray[index].price, productsDataSource.localizedPriceForProductAtIndex(index))
        }
    }
    
    func testThatProductsDataSourceReturnsCorrectStateForProduct() {
        storeAccessMock.productsReceivedSettable = false
        XCTAssertTrue(productsDataSource.stateForProductAtIndex(0) == .retrieving)
        storeAccessMock.productsReceivedSettable = true
        XCTAssertTrue(productsDataSource.stateForProductAtIndex(0) == .retrieved)
        purchasedProducts.markProductAsPurchased(localProductsArray[0].identifier)
        XCTAssertTrue(productsDataSource.stateForProductAtIndex(0) == .purchased)
    }
    
    override func setUp() {
        super.setUp()
        localProducts = LocalProductsMock(products: localProductsArray)
        purchasedProducts = PurchasedProducts()
        storeAccessMock = StoreAccessMock(products: storeProductsArray)
        productsDataSource = ProductsDataSource(localProducts: localProducts, storeAccess: storeAccessMock, purchasedProducts: purchasedProducts)
    }
    
    override func tearDown() {
        localProducts = nil
        purchasedProducts = nil
        storeAccessMock = nil
        productsDataSource = nil
        super.tearDown()
    }
}
