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
    
    var body: some View {
        GeometryReader { geometry in
            let isPad = geometry.size.width > 600
            let isLandscape = geometry.size.width > geometry.size.height
            
            // ── Responsive values ────────────────────────────────────────
            let sidePadding: CGFloat     = isPad ? 60 : 24
            let titleSize: CGFloat       = isPad ? 38 : 30
            let timerSize: CGFloat       = isPad ? (isLandscape ? 72 : 58) : 48
            let pandaHeight: CGFloat     = isPad ? (isLandscape ? 220 : 280) : 240
            let taskFontSize: CGFloat    = isPad ? 22 : 18
            let buttonFontSize: CGFloat  = isPad ? 22 : 18
            let buttonWidth: CGFloat     = isPad ? 280 : 220
            let bottomExtraSpace: CGFloat = isPad ? 140 : 100
            
            ZStack {
                // Background
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: isPad ? 36 : 28) {
                        Spacer()
                            .frame(height: isPad ? (isLandscape ? 40 : 60) : 40)
                        
                        // Session Title
                        Text(sessionTitle)
                            .font(.custom("Cochin", size: titleSize))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, sidePadding)
                        
                        // Panda Hourglass
                        Image("panda_hourglass")
                            .resizable()
                            .scaledToFit()
                            .frame(height: pandaHeight)
                            .shadow(radius: isPad ? 12 : 8)
                        
                        // Timer
                        Text(timeString(from: remainingSeconds))
                            .font(.custom("Cochin", size: timerSize))
                            .fontWeight(.black)
                            .monospacedDigit()
                            .foregroundColor(.primary)
                        
                        Text("Stay focused 🐼")
                            .font(.custom("Cochin", size: isPad ? 22 : 18))
                            .foregroundColor(.secondary)
                        
                        // Tasks
                        if !localTasks.isEmpty {
                            tasksSection(isPad: isPad, sidePadding: sidePadding, fontSize: taskFontSize)
                        }
                        
                        // End Session Button
                        Button {
                            timer?.invalidate()
                            stopAlarm()
                            dismiss()
                        } label: {
                            Text("End Session")
                                .font(.custom("Cochin", size: buttonFontSize))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: buttonWidth)
                                .padding(.vertical, isPad ? 18 : 14)
                                .background(Color.red.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .shadow(radius: 10)
                        }
                        
                        Color.clear
                            .frame(height: bottomExtraSpace)
                    }
                    .padding(.horizontal, sidePadding)
                    .padding(.bottom, isPad ? 180 : 140) // important for last item visibility
                }
                
                // Completion overlay
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
    }
    
    // MARK: - Tasks Section
    @ViewBuilder
    private func tasksSection(isPad: Bool, sidePadding: CGFloat, fontSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: isPad ? 16 : 12) {
            Text("Session Tasks")
                .font(.custom("Cochin", size: isPad ? 26 : 22))
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            ForEach(localTasks.indices, id: \.self) { index in
                HStack(spacing: 16) {
                    Button {
                        localTasks[index].isDone.toggle()
                    } label: {
                        Image(systemName: localTasks[index].isDone ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: isPad ? 28 : 24))
                            .foregroundColor(localTasks[index].isDone ? .green : .gray)
                    }
                    
                    Text(localTasks[index].title)
                        .font(.custom("Cochin", size: fontSize))
                        .strikethrough(localTasks[index].isDone)
                        .opacity(localTasks[index].isDone ? 0.6 : 1)
                        .lineLimit(2)
                    
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: isPad ? 6 : 4)
            }
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(radius: isPad ? 10 : 8)
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
    
    private func rewardCoins() {
        switch sessionType {
        case .study:
            earnedCoins = CoinRewards.studySession
            coinManager.earn(CoinRewards.studySession, reason: .studySessionCompleted)
        case .quest:
            earnedCoins = CoinRewards.questCompletion
            coinManager.earn(CoinRewards.questCompletion, reason: .questCompleted)
        }
    }
    
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
    
    private func timeString(from seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}

// ────────────────────────────────────────────────
struct CompletionOverlay: View {
    let earnedCoins: Int
    let stopAction: () -> Void
    
    var body: some View {
        ZStack {
            // Semi-transparent dark overlay
            Color.black.opacity(0.65)
                .ignoresSafeArea()
            
            // Confetti (assuming you have ConfettiView already)
            ConfettiView()
                .allowsHitTesting(false)
            
            VStack(spacing: 28) {
                // Cute panda celebration image
                Image("panda_break")           // ← make sure this asset exists
                    .resizable()
                    .scaledToFit()
                    .frame(height: 260)
                    .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 8)
                    .scaleEffect(1.08)
                    .animation(
                        .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                        value: UUID()
                    )
                
                // Main message
                Text("Break Time!")
                    .font(.custom("Cochin", size: 48))
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 3)
                
                // Coins earned (only show if > 0)
                if earnedCoins > 0 {
                    HStack(spacing: 12) {
                        Text("+\(earnedCoins)")
                            .font(.custom("Cochin", size: 36))
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                        
                        Text("Bamboo Coins")
                            .font(.custom("Cochin", size: 24))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.5))
                            .overlay(
                                Capsule()
                                    .stroke(Color.yellow.opacity(0.6), lineWidth: 2)
                            )
                    )
                    .shadow(color: .yellow.opacity(0.4), radius: 10)
                }
                
                // Optional motivational / fun text
                Text("You did great, little panda! 🌿✨")
                    .font(.custom("Cochin", size: 20))
                    .italic()
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.top, 8)
                
                // Stop / Continue button
                Button(action: stopAction) {
                    Text("Break Time")
                        .font(.custom("Cochin", size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: 240)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [.green.opacity(0.9), .mint.opacity(0.9)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(color: .green.opacity(0.5), radius: 10)
                }
                .padding(.bottom, 80)
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 30)
            .multilineTextAlignment(.center)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}
