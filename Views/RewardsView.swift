//
//  RewardsView.swift
//  LazyPanda
//
//  Created by Bhoomi on 02/01/26.
//

import SwiftUI

struct RewardsView: View {
    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer().frame(height: 40)

                Text("Rewards")
                    .font(Font.custom("Cochin", size: 30))

                Image(systemName: "gift.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.mint)

                Text("Rewards coming soon 🐼")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text("Complete quests to unlock fun surprises!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()
            }
        }
    }
}
