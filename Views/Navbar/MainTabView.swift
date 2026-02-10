//
//  MainTabView.swift
//  LazyPanda
//

import SwiftUI
import SwiftData

struct MainTabView: View {

    // MARK: - SwiftData
    @Environment(\.modelContext) private var modelContext

    // MARK: - Managers (INJECTED, NOT CREATED)
    @EnvironmentObject private var coinManager: CoinManager

    // MARK: - Navigation
    @State private var selectedTab: NavDestination = .home

    var body: some View {
        ZStack(alignment: .bottom) {

            NavigationStack {
                switch selectedTab {
                case .home:
                    HomeView()
                    

                case .quests:
                    QuestsView()

                case .rewards:
                    RewardsView()
                }
            }

            BottomNavBar(selectedTab: $selectedTab)
        }
        .onAppear {
            coinManager.setup(context: modelContext)
        }
    }
}
