import SwiftUI
import UserNotifications

// MARK: - Cell Model
struct FillCell: Identifiable {
    let id = UUID()
    let row: Int
    let col: Int
    let value: Int?
    let isEditable: Bool
}

// MARK: - View
struct NumberGridFillBlankView: View {

    private let size = 6
    private let todayKey = "DailyNumberFillGrid"

    @State private var solution: [[Int]] = []
    @State private var grid: [[FillCell]] = []

    @State private var userInputs: [UUID: String] = [:]
    @State private var wrongCells: Set<UUID> = []

    @State private var showComplete = false
    @State private var notificationSent = false

    var body: some View {
        ZStack {

            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {

                header

                gridView

                Button("Check Answers") {
                    validate()
                }
                .font(.custom("Cochin", size: 18))
                .padding(.horizontal, 36)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(colors: [.black, .brown],
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
                .foregroundColor(.white)
                .cornerRadius(30)
                .shadow(radius: 6)

                Spacer()
            }
            .padding(.top)
        }
        .onAppear {
            requestNotificationPermission()
            generateDailyPuzzle()
        }
        .alert("Puzzle Complete 🐼", isPresented: $showComplete) {
            Button("Nice!") {}
        } message: {
            Text("You solved today’s number grid!")
        }
    }

    // MARK: - Header
    private var header: some View {
        Text("Number Grid")
            .font(.custom("Cochin", size: 26))
            .fontWeight(.black)
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 12)
            .background(
                LinearGradient(colors: [.black, .brown],
                               startPoint: .top,
                               endPoint: .bottom)
            )
            .cornerRadius(36)
            .shadow(radius: 8)
    }
}

// MARK: - Grid UI
extension NumberGridFillBlankView {

    private var gridView: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 8
            let cellSize = (geo.size.width - spacing * 5) / 6

            VStack(spacing: spacing) {
                ForEach(grid, id: \.first!.row) { row in
                    HStack(spacing: spacing) {
                        ForEach(row) { cell in
                            cellView(cell, size: cellSize)
                        }
                    }
                }
            }
        }
        .frame(height: 360)
        .padding(.horizontal)
    }

    private func cellView(_ cell: FillCell, size: CGFloat) -> some View {
        let isWrong = wrongCells.contains(cell.id)

        return ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    isWrong
                    ? Color.red.opacity(0.35)
                    : cell.isEditable
                        ? Color.white
                        : Color.brown.opacity(0.25)
                )
                .animation(.easeInOut(duration: 0.2), value: isWrong)

            if cell.isEditable {
                TextField(
                    "",
                    text: Binding(
                        get: { userInputs[cell.id, default: ""] },
                        set: { userInputs[cell.id] = $0 }
                    )
                )
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.custom("Cochin", size: 18))
            } else {
                Text("\(cell.value!)")
                    .font(.custom("Cochin", size: 18))
                    .fontWeight(.bold)
            }
        }
        .frame(width: size, height: size)
        .shadow(radius: 2)
    }
}

// MARK: - Game Logic
extension NumberGridFillBlankView {

    private func generateDailyPuzzle() {
        let today = Calendar.current.startOfDay(for: Date())

        if let saved = UserDefaults.standard.object(forKey: todayKey) as? Data,
           let decoded = try? JSONDecoder().decode([[Int]].self, from: saved) {
            solution = decoded
        } else {
            solution = generateSolution()
            if let data = try? JSONEncoder().encode(solution) {
                UserDefaults.standard.set(data, forKey: todayKey)
            }
        }

        grid = generatePuzzle(from: solution)
    }

    // MARK: - Generate Full Valid Grid
    private func generateSolution() -> [[Int]] {
        var base = Array(repeating: Array(repeating: 0, count: size), count: size)

        for r in 0..<size - 1 {
            for c in 0..<size - 1 {
                base[r][c] = Int.random(in: 1...9)
            }
        }

        // Row sums
        for r in 0..<size - 1 {
            base[r][size - 1] = base[r][0..<size - 1].reduce(0, +)
        }

        // Column sums
        for c in 0..<size {
            base[size - 1][c] = base[0..<size - 1].map { $0[c] }.reduce(0, +)
        }

        return base
    }

    // MARK: - Hide Cells
    private func generatePuzzle(from solution: [[Int]]) -> [[FillCell]] {

        let playableSize = size - 1   // 5
        let blanksPerRow = 2
        let blanksPerCol = 2

        var blankCountCol = Array(repeating: 0, count: playableSize)
        var blankPositions = Set<String>()

        // Retry until constraints satisfied
        while true {
            blankCountCol = Array(repeating: 0, count: playableSize)
            blankPositions.removeAll()

            var valid = true

            for row in 0..<playableSize {
                let availableCols = (0..<playableSize).filter {
                    blankCountCol[$0] < blanksPerCol
                }

                if availableCols.count < blanksPerRow {
                    valid = false
                    break
                }

                let chosen = availableCols.shuffled().prefix(blanksPerRow)

                for col in chosen {
                    blankPositions.insert("\(row)-\(col)")
                    blankCountCol[col] += 1
                }
            }

            // Check column constraint
            if valid && blankCountCol.allSatisfy({ $0 == blanksPerCol }) {
                break
            }
        }

        // Build FillCell grid
        return solution.enumerated().map { r, row in
            row.enumerated().map { c, value in

                let editable =
                    r < playableSize &&
                    c < playableSize &&
                    blankPositions.contains("\(r)-\(c)")

                return FillCell(
                    row: r,
                    col: c,
                    value: editable ? nil : value,
                    isEditable: editable
                )
            }
        }
    }


    // MARK: - Validation + Red Blink
    private func validate() {
        wrongCells.removeAll()

        for row in grid {
            for cell in row where cell.isEditable {
                guard
                    let input = userInputs[cell.id],
                    let number = Int(input),
                    number == solution[cell.row][cell.col]
                else {
                    wrongCells.insert(cell.id)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        wrongCells.remove(cell.id)
                    }
                    return
                }
            }
        }

        showComplete = true
        sendCompletionNotification()
    }
}

// MARK: - Notifications
extension NumberGridFillBlankView {

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    private func sendCompletionNotification() {
        guard !notificationSent else { return }
        notificationSent = true

        let content = UNMutableNotificationContent()
        content.title = "Daily Puzzle Complete 🐼"
        content.body = "You solved today’s Number Grid challenge!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "numberGridComplete",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
