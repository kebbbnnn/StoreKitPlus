//
//  StoreSyncService.swift
//  StoreKitPlus
//
//  Created by Daniel Saidi on 2022-08-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import StoreKit

/// This protocol can be implemented by any classes that can
/// be used to sync StoreKit purchase & product information.
public protocol StoreSyncService: AnyObject {

    /// Sync StoreKit product and purchase information.
    func syncStoreData() async throws
}
