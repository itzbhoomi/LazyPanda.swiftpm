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

    private var context: ModelContext?
    @Published private(set) var wallet: CoinWallet?

    init(context: ModelContext?) {
        self.context = context
    }

    func configure(with context: ModelContext) {
        guard self.context == nil else { return }
        self.context = context
        loadWallet()
    }

    private func loadWallet() {
        guard let context else { return }

        if let wallet = try? context.fetch(
            FetchDescriptor<CoinWallet>()
        ).first {
            self.wallet = wallet
        } else {
            let wallet = CoinWallet()
            context.insert(wallet)
            self.wallet = wallet
            try? context.save()
        }
    }

    // MARK: - Earn
    func earn(_ amount: Int, reason: CoinReason) {
        guard let wallet, let context else { return }
        wallet.balance += amount
        try? context.save()
    }

    // MARK: - Spend
    func spend(_ amount: Int, reason: CoinSpendReason) -> Bool {
        guard let wallet, let context else { return false }
        guard wallet.balance >= amount else { return false }

        wallet.balance -= amount
        try? context.save()
        return true
    }
}
