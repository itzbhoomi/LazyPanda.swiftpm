//
//  BottomNavBar.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI

struct BottomNavBar: View {

    @Binding var selectedTab: NavDestination

    var body: some View {
        HStack {
            NavItem(
                icon: "house",
                title: "Home",
                isActive: selectedTab == .home
            ) {
                selectedTab = .home
            }

            Spacer()

            NavItem(
                icon: "target",
                title: "Quests",
                isActive: selectedTab == .quests
            ) {
                selectedTab = .quests
            }

            Spacer()

            NavItem(
                icon: "gift",
                title: "Rewards",
                isActive: selectedTab == .rewards
            ) {
                selectedTab = .rewards
            }

            Spacer()

            NavItem(
                icon: "gear",
                title: "Settings",
                isActive: selectedTab == .settings
            ) {
                selectedTab = .settings
            }
        }
        .padding()
        .background(
            Color.brown.opacity(0.85)
                .clipShape(RoundedRectangle(cornerRadius: 25))
        )
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
