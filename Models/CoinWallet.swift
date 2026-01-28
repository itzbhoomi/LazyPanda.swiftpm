//
//  CoinWallet.swift
//  LazyPanda
//
//  Created by Bhoomi on 06/01/26.
//

import Foundation
import SwiftData

@Model
final class CoinWallet {

    // MARK: - Stored Properties

    var balance: Int

    // MARK: - Relationships

    @Relationship(deleteRule: .cascade)
    var transactions: [CoinTransaction] = []

    // MARK: - Init

    init(balance: Int = 0) {
        self.balance = balance
    }
}
