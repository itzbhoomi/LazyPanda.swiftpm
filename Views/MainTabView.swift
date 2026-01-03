//
//  MainTabView.swift
//  LazyPanda
//
//  Created by Bhoomi on 02/01/26.
//

import SwiftUI

struct MainTabView: View {

    @State private var selectedTab: NavDestination = .home
    @StateObject private var questVM = QuestViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {

            NavigationStack {
                switch selectedTab {
                case .home:
                    HomeView()
                        .environmentObject(questVM)

                case .quests:
                    QuestsView()
                        .environmentObject(questVM)

                case .rewards:
                    RewardsView()

                case .settings:
                    SettingsView()
                }
            }

            BottomNavBar(selectedTab: $selectedTab)
        }
    }
}
