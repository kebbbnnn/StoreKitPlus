//
//  StandardStoreService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-06-20.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This class implements the ``StoreService`` protocol, and
/// can be used to integrate with StoreKit.
///
/// This service keeps products and purchases in sync, using
/// the provided ``StoreContext`` and can be used by SwiftUI
/// based apps, to observe context changes.
///
/// You can use this service with a local product collection,
/// by adding a StoreKit configuration file to the app.
open class StandardStoreService: StoreService {

    /// Create a service instance for the provided IDs, that
    /// syncs any changes to the provided `context`.
    ///
    /// - Parameters:
    ///   - productIds: The IDs of the products to handle.
    ///   - context: The store context to sync with.
    ///   - productService: A custom product service to use, if any.
    ///   - purchaseService: A custom purchase service to use, if any.
    public init(
        productIds: [String],
        context: StoreContext = StoreContext(),
        productService: StoreProductService? = nil,
        purchaseService: StorePurchaseService? = nil
    ) {
        self.productIds = productIds
        self.storeContext = context
        self.productService = productService ?? StandardStoreProductService(
            productIds: productIds)
        self.purchaseService = purchaseService ?? StandardStorePurchaseService(
            productIds: productIds,
            context: context)
    }

    /// Create a service instance for the provided `products`,
    /// that syncs any changes to the provided `context`.
    ///
    /// - Parameters:
    ///   - products: The products to handle.
    ///   - context: The store context to sync with.
    ///   - productService: A custom product service to use, if any.
    ///   - purchaseService: A custom purchase service to use, if any.
    public convenience init<Product: ProductRepresentable>(
        products: [Product],
        context: StoreContext = StoreContext(),
        productService: StoreProductService? = nil,
        purchaseService: StorePurchaseService? = nil
    ) {
        self.init(
            productIds: products.map { $0.id },
            context: context,
            productService: productService,
            purchaseService: purchaseService
        )
    }
    
    private let productIds: [String]
    private let productService: StoreProductService
    private let purchaseService: StorePurchaseService
    private let storeContext: StoreContext
    
    open func getProducts() async throws -> [Product] {
        try await productService.getProducts()
    }
    
    open func purchase(_ product: Product) async throws -> Product.PurchaseResult {
        try await purchaseService.purchase(product)
    }
    
    open func restorePurchases() async throws {
        try await purchaseService.restorePurchases()
    }

    open func syncStoreData() async throws {
        let products = try await getProducts()
        await updateContext(with: products)
        try await restorePurchases()
    }
}



@MainActor
private extension StandardStoreService {
    
    func updateContext(with products: [Product]) {
        storeContext.products = products
    }
}
