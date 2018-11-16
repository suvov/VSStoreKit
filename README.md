# VSStoreKit

[![Build Status](https://travis-ci.org/suvov/VSStoreKit.svg?branch=master)](https://travis-ci.org/suvov/VSStoreKit) [![codecov.io](https://codecov.io/gh/suvov/VSStoreKit/branch/master/graphs/badge.svg)](https://codecov.io/gh/suvov/VSStoreKit/branch/master) [![Version](https://img.shields.io/cocoapods/v/VSStoreKit.svg?style=flat)](http://cocoapods.org/pods/VSStoreKit) [![License](https://img.shields.io/cocoapods/l/VSStoreKit.svg?style=flat)](http://cocoapods.org/pods/VSStoreKit) [![Platform](https://img.shields.io/cocoapods/p/VSStoreKit.svg?style=flat)](http://cocoapods.org/pods/VSStoreKit)

![Icon][img0]

VSStoreKit is an easy to use library that you can use to make in-app purchases in your iOS app. 

## Requirements

* Swift 4
* Xcode 9
* iOS 8.0+

## Installation

#### [CocoaPods](http://cocoapods.org) (recommended)

````ruby
use_frameworks!

pod 'VSStoreKit'

````

## Documentation

Read the [docs][docsLink]. Generated with [jazzy](https://github.com/realm/jazzy). Hosted by [GitHub Pages](https://pages.github.com).

#### Generate

````bash
$ ./build_docs.sh
````

#### Preview

````bash
$ open index.html -a Safari
````

## Getting Started

````swift
import VSStoreKit
````
## Design 

This library has five primary components with the following responsibilities:
1. `StoreAccess` — requesting products from the Store, providing product details such as price and purchasing products
2.  `PurchasedProductsProtocol` — instance conforming to this protocol stores completed purchases
3.  `LocalProductsDataSource` — instance conforming to this protocol provides information about products for sale in the app
4.  `ProductsDataSource` — also provides information about products for sale, but combines local and received from the Store information about products
5.  `StoreAccessObserver` — observing StoreAccess state change and notifying client via callback methods

## Example

````swift
// 1. Create an instance conforming to PurchasedProductsProtocol 
let puchasedProducts: PurchasedProductsProtocol = PurchasedProducts()

// 2. Provide StoreAccess purchaseCompletionHandler so it can mark products as purchased
let storeAccess = StoreAccess.shared
storeAccess.purchaseCompletionHandler = { purchasedProductIdentifier in
    puchasedProducts.markProductAsPurchased(purchasedProductIdentifier)
}

// 3. Create an instance conforming to LocalProductsDataSource with your products (in-app purchases)
let localProducts: LocalProductsDataSource = LocalProducts()

// 4. Request products from the store
storeAccess.requestProductsWithIdentifiers(localProducts.productIdentifiers)

// 5. Instantiate ProductsDataSource object that you will use to populate your UITableView, UICollectionView or whatever with products (in-app purchases)
let productsDataSource = ProductsDataSource(localProducts: localProducts, storeProducts: storeAccess)

// 6. Buy product
let productIdentifier = productsDataSource.identifierForProductAtIndex(index)
storeAccess.purchaseProductWithIdentifier(productIdentifier)

// 7. Observe StoreAccess state change with help of StoreAccessObserver by providing it optional handlers for the states you are interested in
let storeAccessObserver = StoreAccessObserver()
storeAccessObserver.receivedProductsStateHandler = {
    // reload your products presentation
}
storeAccessObserver.purchasedStateHandler = {
    // reload your products presentation
}

````

## Author

Vladimir Shutyuk, vladimir.shutyuk@gmail.com

## License

VSStoreKit is available under the MIT license. See the LICENSE file for more info.

[img0]:https://raw.githubusercontent.com/suvov/VSStoreKit/master/Icon0.png
[docsLink]:http://suvov.xyz/VSStoreKit

