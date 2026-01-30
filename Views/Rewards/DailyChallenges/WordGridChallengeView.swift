//
//  WordGridChallengeView.swift
//  LazyPanda
//
//  Created by Bhoomi on 29/01/26.
//

import SwiftUI

// MARK: - Models

struct GridCell: Identifiable, Hashable {
    let id = UUID()
    let letter: Character
    let row: Int
    let col: Int
}

// MARK: - View

struct WordGridChallengeView: View {

    // MARK: Config
    private let gridSize = 6
    private let minWordLength = 3
    private let maxWordsPerGrid = 5

    // MARK: State
    @State private var grid: [[GridCell]] = []
    @State private var currentPath: [GridCell] = []
    @State private var foundWords: Set<String> = []
    @State private var wordsInGrid: [String] = []
    @State private var showGameCompleteAlert = false

    // MARK: Daily Challenge
    private let todayKey = "WordGridLastPlayedDate"

    // MARK: Dictionary
    private let dictionary: [String] = [
        "CAT", "DOG", "WORD", "GRID", "CODE",
        "DATA", "LOGIC", "SWIFT", "FUN",
        "PUZZLE", "TREE", "BOOK", "PLAN"
    ]

    var body: some View {
        ZStack {

            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {

                header

                currentWordView

                if !grid.isEmpty {
                    gridView
                        .padding(.horizontal, 20)
                }

                foundWordsView

                Spacer()
            }
            .padding(.top)
        }
        .onAppear {
            setupDailyChallenge()
        }
        .alert("Congratulations 🏆", isPresented: $showGameCompleteAlert) {
            Button("Come Back Tomorrow") {}
        } message: {
            Text("You’ve completed today’s Word Grid challenge!")
        }
    }

    // MARK: - Header

    private var header: some View {
        Text("Word Grid")
            .font(.custom("Cochin", size: 26))
            .fontWeight(.black)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [.black, .brown],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(36)
            .shadow(radius: 8)
    }

    // MARK: - Current Word

    private var currentWordView: some View {
        Text(currentWord)
            .font(.custom("Cochin", size: 22))
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(24)
            .padding(.horizontal)
    }

    private var currentWord: String {
        String(currentPath.map { $0.letter })
    }
}

// MARK: - Grid View

extension WordGridChallengeView {

    private var gridView: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 10
            let size = (geo.size.width - spacing * 5) / 6

            VStack(spacing: spacing) {
                ForEach(0..<6, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<6, id: \.self) { col in
                            if let cell = safeCell(row: row, col: col) {
                                LetterCellView(
                                    cell: cell,
                                    isSelected: currentPath.contains(cell)
                                )
                                .frame(width: size, height: size)
                            }
                        }
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let col = Int(value.location.x / (size + spacing))
                        let row = Int(value.location.y / (size + spacing))
                        guard let cell = safeCell(row: row, col: col) else { return }
                        handleDrag(cell)
                    }
                    .onEnded { _ in
                        finishWord()
                    }
            )
        }
        .frame(height: 360)
    }

    private func safeCell(row: Int, col: Int) -> GridCell? {
        guard row >= 0, row < grid.count else { return nil }
        guard col >= 0, col < grid[row].count else { return nil }
        return grid[row][col]
    }
}

// MARK: - Letter Cell

struct LetterCellView: View {

    let cell: GridCell
    let isSelected: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    isSelected
                    ? AnyShapeStyle(
                        LinearGradient(
                            colors: [.black, .brown],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    : AnyShapeStyle(Color.white)
                )

            Text(String(cell.letter))
                .font(.custom("Cochin", size: 22))
                .fontWeight(.black)
                .foregroundColor(isSelected ? .white : .black)
        }
        .shadow(color: .black.opacity(0.15), radius: 3)
    }
}

// MARK: - Found Words

extension WordGridChallengeView {

    private var foundWordsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Found Words")
                .font(.custom("Cochin", size: 18))
                .fontWeight(.bold)

            if foundWords.isEmpty {
                Text("No words yet")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEach(Array(foundWords), id: \.self) { word in
                        Text(word)
                            .font(.caption)
                            .padding(6)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(24)
        .padding(.horizontal)
    }
}

// MARK: - Game Logic

extension WordGridChallengeView {

    private func setupDailyChallenge() {
        let today = Calendar.current.startOfDay(for: Date())

        if let last = UserDefaults.standard.object(forKey: todayKey) as? Date,
           Calendar.current.isDate(last, inSameDayAs: today) {
            return
        }

        UserDefaults.standard.set(today, forKey: todayKey)
        generateGrid()
    }

    private func generateGrid() {
        grid = (0..<6).map { row in
            (0..<6).map { col in
                GridCell(letter: " ", row: row, col: col)
            }
        }

        foundWords.removeAll()
        wordsInGrid = Array(dictionary.shuffled().prefix(maxWordsPerGrid))

        let directions = [
            (0, 1),   // horizontal
            (1, 0),   // vertical
        ]

        for word in wordsInGrid {
            placeWord(word, directions: directions)
        }

        let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

        for row in 0..<6 {
            for col in 0..<6 {
                if grid[row][col].letter == " " {
                    grid[row][col] = GridCell(
                        letter: letters.randomElement()!,
                        row: row,
                        col: col
                    )
                }
            }
        }
    }

    private func placeWord(_ word: String, directions: [(Int, Int)]) {
        let chars = Array(word)

        for _ in 0..<100 {
            let (dx, dy) = directions.randomElement()!
            let startRow = Int.random(in: 0..<6)
            let startCol = Int.random(in: 0..<6)

            var positions: [(Int, Int)] = []

            for i in 0..<chars.count {
                let r = startRow + i * dx
                let c = startCol + i * dy
                guard r >= 0, r < 6, c >= 0, c < 6 else { positions.removeAll(); break }
                positions.append((r, c))
            }

            guard positions.count == chars.count else { continue }

            for (index, pos) in positions.enumerated() {
                let cell = grid[pos.0][pos.1]
                if cell.letter != " " && cell.letter != chars[index] {
                    positions.removeAll()
                    break
                }
            }

            if positions.count == chars.count {
                for (index, pos) in positions.enumerated() {
                    grid[pos.0][pos.1] = GridCell(
                        letter: chars[index],
                        row: pos.0,
                        col: pos.1
                    )
                }
                return
            }
        }
    }

    private func handleDrag(_ cell: GridCell) {
        if let last = currentPath.last {
            let adjacent =
                abs(last.row - cell.row) <= 1 &&
                abs(last.col - cell.col) <= 1
            guard adjacent else { return }
        }

        if !currentPath.contains(cell) {
            currentPath.append(cell)
        }
    }

    private func finishWord() {
        let word = currentWord.uppercased()
        if word.count >= minWordLength && wordsInGrid.contains(word) {
            foundWords.insert(word)
        }

        currentPath.removeAll()

        if Set(wordsInGrid).isSubset(of: foundWords) {
            showGameCompleteAlert = true
        }
    }
}
