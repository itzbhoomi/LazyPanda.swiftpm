import SwiftUI
import SwiftData

@main
struct MyApp: App {

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [
            CoinWallet.self,
            Quest.self,
            TaskItem.self
        ])
    }
}
