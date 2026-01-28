//
//  BadgesView.swift
//  LazyPanda
//
//  Created by Bhoomi on 07/01/26.
//

import SwiftUI
import SwiftData

struct Badge {
    let title: String
    let description: String
    let minDays: Int
    let systemImage: String
}

struct BadgesView: View {

    // MARK: - SwiftData
    @Query(
        sort: \CoinTransaction.date,
        order: .reverse
    )
    private var transactions: [CoinTransaction]

    // MARK: - Badge Definitions
    private let badges: [Badge] = [
        Badge(
            title: "Sprout Panda",
            description: "Your consistency has started to grow.",
            minDays: 3,
            systemImage: "leaf.fill"
        ),
        Badge(
            title: "Bamboo Explorer",
            description: "A full week of steady focus and effort.",
            minDays: 7,
            systemImage: "leaf.circle.fill"
        ),
        Badge(
            title: "Zen Guardian",
            description: "Calm, disciplined, and consistent for 15 days.",
            minDays: 15,
            systemImage: "yin.yang"
        ),
        Badge(
            title: "Forest Sage",
            description: "A month of dedication. True mastery begins.",
            minDays: 30,
            systemImage: "tree.fill"
        ),
        Badge(
            title: "Legendary Panda",
            description: "Elite consistency. Few reach this level.",
            minDays: 60,
            systemImage: "star.circle.fill"
        )
    ]

    // MARK: - Streak Logic (SAME as RewardsView)
    private var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let earnDates = transactions
            .filter { $0.type == .earn }
            .map { calendar.startOfDay(for: $0.date) }

        guard !earnDates.isEmpty else { return 0 }

        let uniqueDays = Set(earnDates)
        var streak = 0
        var dayCursor = today

        while uniqueDays.contains(dayCursor) {
            streak += 1
            dayCursor = calendar.date(byAdding: .day, value: -1, to: dayCursor)!
        }

        return streak
    }

    // MARK: - Badge Resolution
    private var currentBadge: Badge? {
        badges.last { currentStreak >= $0.minDays }
    }

    private var upcomingBadge: Badge? {
        badges.first { currentStreak < $0.minDays }
    }

    var body: some View {
        ZStack {

            // 🎋 Bamboo Background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 24) {

                // MARK: - Header
                Text("Badges")
                    .font(.custom("Cochin", size: 28))
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .frame(maxWidth: 300)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.black, Color.brown],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(40)
                    .shadow(radius: 10)
                    .padding(.top)


                // MARK: - Badge Display
                if let badge = currentBadge {

                    // 🎖️ Earned Badge
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.brown.opacity(0.85), Color.black],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 160, height: 160)
                            .shadow(color: .green.opacity(0.5), radius: 18)

                        Image(systemName: badge.systemImage)
                            .font(.system(size: 64))
                            .foregroundColor(.green)
                    }

                    Text(badge.title)
                        .font(.custom("Cochin", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text(badge.description)
                        .font(.custom("Cochin", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                } else {

                    // ❌ No badge yet
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.6))
                            .frame(width: 160, height: 160)

                        Image(systemName: "lock.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                    }

                    Text("No badge earned yet")
                        .font(.custom("Cochin", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text("Reach a 3-day streak to unlock your first badge.")
                        .font(.custom("Cochin", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }


                // MARK: - Upcoming Badge
                if let next = upcomingBadge {
                    VStack(spacing: 8) {
                        Text("Upcoming Badge")
                            .font(.custom("Cochin", size: 18))
                            .foregroundColor(.green)

                        Text(next.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Text("\(next.minDays - currentStreak) days remaining")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    .frame(maxWidth: 320)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(
                                LinearGradient(
                                    colors: [Color.black, Color.brown.opacity(0.85)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .shadow(radius: 8)
                } else if currentBadge != nil {
                    Text("🎉 All badges unlocked!")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }

                Spacer()
            }
        }
    }
}
