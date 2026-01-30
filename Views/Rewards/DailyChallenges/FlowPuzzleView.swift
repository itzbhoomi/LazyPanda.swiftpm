//
//  MemoryFlipChallengeView.swift
//  LazyPanda
//
//  Created by Bhoomi 🐼
//

import SwiftUI

// MARK: - Model
struct MemoryCard: Identifiable {
    let id = UUID()
    let symbol: String
    var isFlipped: Bool = false
    var isMatched: Bool = false
}

// MARK: - View
struct MemoryFlipChallengeView: View {

    private let rows = 5
    private let columnsCount = 4
    private let todayKey = "DailyMemoryFlipDate"

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 10), count: columnsCount)
    }

    @Environment(\.dismiss) private var dismiss

    @State private var cards: [MemoryCard] = []
    @State private var flippedIndices: [Int] = []
    @State private var isLocked = false
    @State private var showCompletionAlert = false
    @State private var hasPlayedToday = false

    var body: some View {
        ZStack {

            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 18) {

                header

                if hasPlayedToday {
                    Text("You have already completed today's challenge! 🐼")
                        .font(.custom("Cochin", size: 18))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(cards.indices, id: \.self) { index in
                            cardView(for: index)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
        }
        .onAppear { setupDailyGame() }
        .alert("Today's Challenge Completed 🐼", isPresented: $showCompletionAlert) {
            Button("Go Back") { dismiss() }
        } message: {
            Text("You’ve mastered today’s Memory Flip challenge!")
        }
    }
}

// MARK: - Header
extension MemoryFlipChallengeView {
    private var header: some View {
        Text("Memory Flip")
            .font(.custom("Cochin", size: 26))
            .fontWeight(.black)
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 12)
            .background(
                LinearGradient(colors: [.black, .brown], startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(36)
            .shadow(radius: 8)
    }
}

// MARK: - Card UI
extension MemoryFlipChallengeView {

    private func cardView(for index: Int) -> some View {
        let card = cards[index]

        return ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(card.isFlipped ? Color.white : Color.brown)
                .scaleEffect(card.isMatched ? 0.1 : 1) // shrink when matched
                .opacity(card.isMatched ? 0 : 1)
                .animation(.easeInOut(duration: 0.4), value: card.isMatched)

            if card.isFlipped && !card.isMatched {
                Text(card.symbol)
                    .font(.system(size: 28))
                    .transition(.scale)
            }
        }
        .frame(height: 64)
        .shadow(radius: 3)
        .rotation3DEffect(
            .degrees(card.isFlipped ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.25), value: card.isFlipped)
        .onTapGesture { handleTap(on: index) }
    }
}

// MARK: - Game Logic
extension MemoryFlipChallengeView {

    private func setupDailyGame() {

        let today = Calendar.current.startOfDay(for: Date())
        let lastPlay = UserDefaults.standard.object(forKey: todayKey) as? Date

        if let last = lastPlay, Calendar.current.isDate(last, inSameDayAs: today) {
            // Already played today
            hasPlayedToday = true
            return
        }

        hasPlayedToday = false

        let emojiPool = [
            "🐼", "🐻", "🧸", "🐨",
            "🎋", "🌱", "🌿", "☘️", "🍀", "🌾", "🪴", "🌳", "🌲", "🍃",
            "🍵", "🫖", "☕️", "🥛",
            "🍪", "🍩", "🧁", "🍰", "🥐", "🍞", "🍯", "🍫",
            "🌸", "🌼", "💮",
            "🪵",
            "☁️", "🌙", "⭐️", "💫"
        ].shuffled()

        // 5x4 = 20 cards → 10 pairs
        let pairs = Array(emojiPool.prefix(10))
        var symbols = pairs + pairs
        symbols.shuffle()

        cards = symbols.map { MemoryCard(symbol: $0) }
    }

    private func handleTap(on index: Int) {
        guard !isLocked, !cards[index].isFlipped, !cards[index].isMatched else { return }

        cards[index].isFlipped = true
        flippedIndices.append(index)

        if flippedIndices.count == 2 {
            checkMatch()
        }
    }

    private func checkMatch() {
        isLocked = true
        let first = flippedIndices[0]
        let second = flippedIndices[1]

        if cards[first].symbol == cards[second].symbol {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                cards[first].isMatched = true
                cards[second].isMatched = true
                resetTurn()
                checkCompletion()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                cards[first].isFlipped = false
                cards[second].isFlipped = false
                resetTurn()
            }
        }
    }

    private func resetTurn() {
        flippedIndices.removeAll()
        isLocked = false
    }

    private func checkCompletion() {
        if cards.allSatisfy({ $0.isMatched }) {
            showCompletionAlert = true
            UserDefaults.standard.set(Date(), forKey: todayKey)
            hasPlayedToday = true
        }
    }
}
