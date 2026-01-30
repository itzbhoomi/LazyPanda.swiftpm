import SwiftUI
import SwiftData

@MainActor
final class CoinManager: ObservableObject {

    private var context: ModelContext!

    @Published private(set) var wallet: CoinWallet!

    // MARK: - One-time setup
    func setup(context: ModelContext) {
        guard self.context == nil else { return } // prevent double setup
        self.context = context

        if let existingWallet = try? context.fetch(
            FetchDescriptor<CoinWallet>()
        ).first {
            self.wallet = existingWallet
        } else {
            let wallet = CoinWallet(balance: 0)
            context.insert(wallet)
            self.wallet = wallet
            try? context.save()
        }
    }

    // MARK: - Earn
    func earn(_ amount: Int, reason: CoinReason) {
        let tx = CoinTransaction(
            amount: amount,
            type: .earn,
            earnReason: reason
        )

        // Link transaction to wallet
        tx.wallet = wallet
        wallet.transactions.append(tx)

        context.insert(tx)
        wallet.balance += amount

        try? context.save()
    }

    // MARK: - Spend
    func spend(_ amount: Int, reason: CoinSpendReason) -> Bool {
        guard wallet.balance >= amount else { return false }

        let tx = CoinTransaction(
            amount: amount,
            type: .spend,
            spendReason: reason
        )

        // Link transaction to wallet
        tx.wallet = wallet
        wallet.transactions.append(tx)

        context.insert(tx)
        wallet.balance -= amount

        try? context.save()
        return true
    }
}
