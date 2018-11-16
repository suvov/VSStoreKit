//
//  ViewController.swift
//  Example
//
//  Created by Vladimir Shutyuk on 09/07/2017.
//  Copyright © 2017 Vladimir Shutyuk. All rights reserved.
//

import UIKit
import VSStoreKit

class ViewController: UITableViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let localProducts = LocalProducts()
    private let storeAccess = StoreAccess.shared
    private let purchasedProducts = PurchasedProducts()
    private let storeAccessObserver = StoreAccessObserver()
    private var productsDataSource: ProductsDataSource?

    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProductsDataSource()
        setupStoreAccessObserver()
        requestProductsFromStore()
        setupNavigationBar()
    }
    
    private func setupProductsDataSource() {
        productsDataSource = ProductsDataSource(localProducts: localProducts, storeProducts: storeAccess)
        tableView.reloadData()
    }
    
    private func setupStoreAccessObserver() {
        storeAccessObserver.requestForProductsFailedStateHandler = { error in
            print("*** Can't load products from store \(error.localizedDescription)")
        }
        storeAccessObserver.purchasedStateHandler = { [unowned self] in
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
        storeAccessObserver.purchaseFailedStateHandler = { [unowned self] skError in
            print(skError?.localizedDescription ?? "*** unknown error")
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }

    private func requestProductsFromStore() {
        storeAccess.requestProductsWithIdentifiers(localProducts.productIdentifiers)
    }
    
    private func setupNavigationBar() {
        title = "Store"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }
    
    // MARK:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsDataSource?.numProducts ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
        cell.productName.text = productsDataSource?.localizedNameForProductAtIndex(indexPath.item)
        cell.productDescription.text = productsDataSource?.localizedDescriptionForProductAtIndex(indexPath.item)
        cell.buyButton.tag = indexPath.item
        return cell
    }
    
    // MARK:
    @IBAction func buyAction(_ sender: UIButton) {
        guard storeAccess.productsReceived else { return } // StoreKit won't allow making purchases until products received
        
        guard let productIdentifier = productsDataSource?.identifierForProductAtIndex(sender.tag) else { return }
        storeAccess.purchaseProductWithIdentifier(productIdentifier)
    }
}

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var buyButton: UIButton!
}
