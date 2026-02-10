import SwiftUI
import SwiftData

@main
struct MyApp: App {

    let coinManager = CoinManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(coinManager)
                .modelContainer(for: [
                    CoinWallet.self,
                    CoinTransaction.self,
                    Quest.self,
                    TaskItem.self,
                    BambooVerseItemEntity.self
                ])
        }
        .modelContainer(for: [
            CoinWallet.self,
            CoinTransaction.self,
            Quest.self,
            TaskItem.self,
            BambooVerseItemEntity.self
        ])
    }
}
