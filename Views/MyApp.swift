import SwiftUI
import SwiftData

@main
struct MyApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CoinWallet.self,
            Quest.self,
            TaskItem.self
        ])
        return try! ModelContainer(for: schema)
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
