//
//  StandardStoreProductService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import StoreKit

/**
 This class can be used to retrieve StoreKit products.
 */
open class StandardStoreProductService: StoreProductService {

    /**
     Create a service instance for the provided `productIds`.

     - Parameters:
       - productIds: The IDs of the products to fetch.
     */
    public init(productIds: [String]) {
        self.productIds = productIds
    }

    private let productIds: [String]

    /**
     Get all available products.
     */
    open func getProducts() async throws -> [Product] {
        try await Product.products(for: productIds)
    }
}
