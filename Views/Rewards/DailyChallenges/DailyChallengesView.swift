//
//  DailyChallengesView.swift
//  LazyPanda
//
//  Created by Bhoomi on 29/01/26.
//

import SwiftUI

// MARK: - Game Type
enum DailyGameType {
    case wordGrid
    case numberGrid
    case patternRecall
}

// MARK: - Game Model
struct DailyGame {
    let title: String
    let subtitle: String
    let systemImage: String
    let type: DailyGameType
}

// MARK: - Main View
struct DailyChallengesView: View {

    private let games: [DailyGame] = [
        DailyGame(
            title: "Word Grid",
            subtitle: "Find hidden words",
            systemImage: "textformat.abc",
            type: .wordGrid
        ),
        DailyGame(
            title: "Number Grid",
            subtitle: "Complete all sums",
            systemImage: "sum",
            type: .numberGrid
        ),
        DailyGame(
            title: "Pattern Recall",
            subtitle: "Memorize & repeat",
            systemImage: "square.grid.3x3.fill",
            type: .patternRecall
        )
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            ZStack {

                // 🎋 Bamboo Background
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {

                    // MARK: - Header
                    Text("Daily Challenges")
                        .font(.custom("Cochin", size: 26))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .frame(maxWidth: 300)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [Color.black, Color.brown],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(36)
                        .shadow(radius: 8)
                        .padding(.top)

                    // MARK: - Panda Image
                    Image("panda_daily_challenge")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 190)
                        .shadow(radius: 10)

                    // MARK: - Games Grid
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(games, id: \.title) { game in
                            DailyGameGridCard(game: game)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
        }
    }
}

// MARK: - Grid Card
struct DailyGameGridCard: View {

    let game: DailyGame

    var body: some View {
        NavigationLink {
            destinationView
        } label: {
            cardContent
        }
        .buttonStyle(.plain)
    }
}

private extension DailyGameGridCard {

    var cardContent: some View {
        VStack(spacing: 10) {

            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.black, Color.brown],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)

                Image(systemName: game.systemImage)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }

            Text(game.title)
                .font(.custom("Cochin", size: 16))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            Text(game.subtitle)
                .font(.custom("Cochin", size: 12))
                .foregroundColor(.black.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(Color.white)
        )
        .shadow(color: .black.opacity(0.12), radius: 6, y: 4)
    }
}

private extension DailyGameGridCard {

    @ViewBuilder
    var destinationView: some View {
        switch game.type {
        case .wordGrid:
            WordGridChallengeView()

        case .numberGrid:
            NumberGridFillBlankView()

        case .patternRecall:
            MemoryFlipChallengeView()
        }
    }
}
