//
//  CoinManager.swift
//  LazyPanda
//
//  Created by Bhoomi on 06/01/26.
//

import SwiftUI
import SwiftData

@MainActor
final class CoinManager: ObservableObject {

    private let context: ModelContext
    @Published private(set) var wallet: CoinWallet

    init(context: ModelContext) {
        self.context = context

        if let existingWallet = try? context.fetch(FetchDescriptor<CoinWallet>()).first {
            self.wallet = existingWallet
        } else {
            let newWallet = CoinWallet()
            context.insert(newWallet)
            self.wallet = newWallet
        }
    }

    // MARK: - Earn Coins
    func earn(_ amount: Int, reason: CoinReason) {
        guard amount > 0 else { return }

        wallet.balance += amount
        save()

        #if DEBUG
        print("🐼 Earned \(amount) coins for \(reason.rawValue)")
        #endif
    }

    // MARK: - Spend Coins
    func spend(_ amount: Int, reason: CoinSpendReason) -> Bool {
        guard amount > 0, wallet.balance >= amount else { return false }

        wallet.balance -= amount
        save()

        #if DEBUG
        print("🎋 Spent \(amount) coins for \(reason.rawValue)")
        #endif

        return true
    }

    private func save() {
        try? context.save()
    }
}
