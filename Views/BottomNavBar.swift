//
//  BottomNavBar.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI

struct BottomNavBar: View {
    var body: some View {
        HStack {
            NavItem(icon: "house", title: "Home", active: true)
            Spacer()
            NavItem(icon: "target", title: "Focus")
            Spacer()
            NavItem(icon: "chart.bar", title: "Progress")
            Spacer()
            NavItem(icon: "gift", title: "Rewards")
            Spacer()
            NavItem(icon: "gear", title: "Settings")
        }
        .padding()
        .background(Color.brown.opacity(0.4))
        .cornerRadius(25)
        .padding(.bottom, 10)
        .frame(maxWidth: 350)
    }
}
