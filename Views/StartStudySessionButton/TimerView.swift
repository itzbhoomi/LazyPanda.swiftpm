//
//  TimerView.swift
//  LazyPanda
//
//  Created by Bhoomi on 01/01/26.
//

import SwiftUI
import AudioToolbox

struct TimerView: View {

    // MARK: - Inputs
    let sessionTitle: String
    let totalMinutes: Int
    let tasks: [TaskItem]
    let sessionType: SessionType

    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var coinManager: CoinManager

    // MARK: - Timer state
    @State private var remainingSeconds: Int
    @State private var timer: Timer?

    // MARK: - Task state
    @State private var localTasks: [TaskItem]

    // MARK: - Completion & alarm
    @State private var showCompletionScreen = false
    @State private var alarmTimer: Timer?
    @State private var earnedCoins: Int = 0

    // Built-in iOS alarm sound (safe for Playgrounds)
    private let alarmSoundID: SystemSoundID = 1013

    // MARK: - Init
    init(
        sessionTitle: String,
        totalMinutes: Int,
        tasks: [TaskItem],
        sessionType: SessionType
    ) {
        self.sessionTitle = sessionTitle
        self.totalMinutes = totalMinutes
        self.tasks = tasks
        self.sessionType = sessionType

        _remainingSeconds = State(initialValue: totalMinutes * 60)
        _localTasks = State(initialValue: tasks)
    }

    // MARK: - View
    var body: some View {
        ZStack {

            // 🌿 Bamboo Background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {

                    // 🐼 Session Title
                    Text(sessionTitle)
                        .font(.custom("Cochin", size: 30))
                        .fontWeight(.bold)

                    // ⏳ Panda Hourglass
                    Image("panda_hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 260)

                    // ⌛ Timer Text
                    Text(timeString(from: remainingSeconds))
                        .font(.custom("Cochin", size: 44))
                        .fontWeight(.bold)

                    Text("Stay focused 🐼")
                        .foregroundColor(.secondary)

                    // 📋 Tasks Section
                    if !localTasks.isEmpty {
                        tasksSection
                    }

                    // 🛑 End Session Button (NO COINS)
                    Button {
                        timer?.invalidate()
                        stopAlarm()
                        dismiss()
                    } label: {
                        Text("End Session")
                            .font(.custom("Cochin", size: 20))
                            .fontWeight(.bold)
                            .frame(maxWidth: 220)
                            .padding()
                            .background(Color.red.opacity(0.9))
                            .cornerRadius(30)
                            .shadow(radius: 10)
                            .foregroundColor(.white)
                    }

                    Spacer(minLength: 100)
                }
                .padding()
            }

            // 🎉 Completion Overlay
            if showCompletionScreen {
                CompletionOverlay(
                    earnedCoins: earnedCoins,
                    stopAction: {
                        stopAlarm()
                        dismiss()
                    }
                )
                .transition(.opacity)
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopAlarm()
            timer?.invalidate()
        }
        .animation(.easeInOut, value: showCompletionScreen)
    }

    // MARK: - Tasks UI
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("Session Tasks")
                .font(.custom("Cochin", size: 22))
                .fontWeight(.semibold)

            ForEach(localTasks.indices, id: \.self) { index in
                HStack {

                    // ✅ Toggle
                    Button {
                        localTasks[index].isDone.toggle()
                    } label: {
                        Image(systemName:
                            localTasks[index].isDone
                            ? "checkmark.circle.fill"
                            : "circle"
                        )
                        .foregroundColor(localTasks[index].isDone ? .green : .gray)
                        .font(.system(size: 22))
                    }

                    Text(localTasks[index].title)
                        .font(.custom("Cochin", size: 18))
                        .strikethrough(localTasks[index].isDone)
                        .opacity(localTasks[index].isDone ? 0.5 : 1)

                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.6))
                .cornerRadius(20)
                .shadow(radius: 4)
            }
        }
        .padding()
        .background(Color.white.opacity(0.5))
        .cornerRadius(26)
        .shadow(radius: 8)
    }

    // MARK: - Timer Logic
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else {
                    timer?.invalidate()
                    rewardCoins()
                    playAlarmLoop()
                    showCompletionScreen = true
                }
            }
        }
    }

    // MARK: - Coin Rewards
    private func rewardCoins() {
        switch sessionType {
        case .study:
            earnedCoins = CoinRewards.studySession
            coinManager.earn(
                CoinRewards.studySession,
                reason: .studySessionCompleted
            )

        case .quest:
            earnedCoins = CoinRewards.questCompletion
            coinManager.earn(
                CoinRewards.questCompletion,
                reason: .questCompleted
            )
        }
    }

    // MARK: - Alarm
    @MainActor
    private func playAlarmLoop() {
        AudioServicesPlaySystemSound(alarmSoundID)
        alarmTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            AudioServicesPlaySystemSound(alarmSoundID)
        }
    }

    private func stopAlarm() {
        alarmTimer?.invalidate()
        alarmTimer = nil
    }

    // MARK: - Helpers
    private func timeString(from seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}

//////////////////////////////////////////////////////////
// MARK: - Completion Overlay
//////////////////////////////////////////////////////////

struct CompletionOverlay: View {

    let earnedCoins: Int
    let stopAction: () -> Void

    var body: some View {
        ZStack {

            Color.black.opacity(0.6)
                .ignoresSafeArea()

            ConfettiView()

            VStack(spacing: 24) {

                Image("panda_break")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260)
                    .scaleEffect(1.05)
                    .animation(
                        .easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                        value: UUID()
                    )

                Text("Break Time!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                if earnedCoins > 0 {
                    Text("+\(earnedCoins) Bamboo Coins 🌿")
                        .font(.custom("Cochin", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.6))
                        )
                }

                Button(action: stopAction) {
                    Text("Stop")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 160)
                        .background(Color.green)
                        .cornerRadius(18)
                }
            }
        }
    }
}

//////////////////////////////////////////////////////////
// MARK: - Confetti
//////////////////////////////////////////////////////////

struct ConfettiView: View {

    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<25, id: \.self) { _ in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.white.opacity(0.8))
                    .position(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: animate ? geo.size.height + 40 : -40
                    )
                    .animation(
                        .linear(duration: Double.random(in: 2.5...4))
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...1)),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
        .ignoresSafeArea()
    }
}
