//
//  MainTabView 2.swift
//  LazyPanda
//
//  Created by Bhoomi on 06/01/26.
//


import SwiftUI
import SwiftData

struct MainTabView: View {

    @Environment(\.modelContext) private var modelContext

    @StateObject private var coinManager: CoinManager
    @State private var selectedTab: NavDestination = .home

    // ✅ Correct init: context injected ONCE
    init(modelContext: ModelContext) {
        _coinManager = StateObject(
            wrappedValue: CoinManager(context: modelContext)
        )
    }

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

                case .settings:
                    SettingsView()
                }
            }

            BottomNavBar(selectedTab: $selectedTab)
        }
        .environmentObject(coinManager)
    }
}
