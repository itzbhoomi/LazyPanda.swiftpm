//
//  MainTabView.swift
//  LazyPanda
//
//  Created by Bhoomi on 02/01/26.
//

import SwiftUI
import SwiftData

struct MainTabView: View {

    @Environment(\.modelContext) private var modelContext
    @StateObject private var coinManager: CoinManager

    @State private var selectedTab: NavDestination = .home

    init() {
        // Temporary placeholder, real context injected onAppear
        _coinManager = StateObject(
            wrappedValue: CoinManager(context: nil)
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
        .onAppear {
            coinManager.configure(with: modelContext)
        }
    }
}
