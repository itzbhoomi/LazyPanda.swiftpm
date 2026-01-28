//
//  CoinTransaction.swift
//  LazyPanda
//

import Foundation
import SwiftData

@Model
final class CoinTransaction {

    var amount: Int
    var type: CoinTransactionType

    // Only one will be set
    var earnReasonRaw: String?
    var spendReasonRaw: String?

    var date: Date

    // MARK: - Computed helpers (UI-safe)

    var earnReason: CoinReason? {
        earnReasonRaw.flatMap { CoinReason(rawValue: $0) }
    }

    var spendReason: CoinSpendReason? {
        spendReasonRaw.flatMap { CoinSpendReason(rawValue: $0) }
    }

    init(
        amount: Int,
        type: CoinTransactionType,
        earnReason: CoinReason? = nil,
        spendReason: CoinSpendReason? = nil,
        date: Date = .now
    ) {
        self.amount = amount
        self.type = type
        self.earnReasonRaw = earnReason?.rawValue
        self.spendReasonRaw = spendReason?.rawValue
        self.date = date
    }
}
