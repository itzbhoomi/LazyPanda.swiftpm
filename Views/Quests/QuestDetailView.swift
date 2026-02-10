//
// QuestDetailView.swift
// LazyPanda
//
// Created by Bhoomi on 31/12/25.
//
import SwiftUI
import SwiftData

struct QuestDetailView: View {
    // MARK: - Environment
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var coinManager: CoinManager
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Inputs
    let quest: Quest
    
    // MARK: - Local state
    @State private var newTaskText = ""
    @State private var showConfetti = false
    @State private var coinsEarned = 0
    @State private var rewardGiven = false
    
    var body: some View {
        GeometryReader { geo in
            let isPad = geo.size.width > 600
            let baseScale = isPad ? 1.10 : 1.00
            
            // Responsive values
            let sidePadding: CGFloat    = isPad ? 60 : 24
            let fieldFontSize: CGFloat  = isPad ? 26 : 20
            let titleFontSize: CGFloat  = isPad ? 42 : 30
            let pandaHeight: CGFloat    = isPad ? 240 : 180
            let plusFrame: CGFloat      = isPad ? 60 : 45
            
            ZStack {
                // Background
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: isPad ? 32 : 20) {
                        Spacer()
                            .frame(height: isPad ? 80 : 40)
                        
                        // Quest Title
                        Text("\(quest.icon) \(quest.title)")
                            .font(.custom("Cochin", size: titleFontSize))
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, sidePadding)
                        
                        // Add Task Section – full width
                        HStack(spacing: 16) {
                            TextField("New task", text: $newTaskText)
                                .font(.custom("Cochin", size: fieldFontSize))
                            
                            Button {
                                addTask()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: isPad ? 28 : 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: plusFrame, height: plusFrame)
                                    .background(Color.brown)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .padding(.horizontal, sidePadding)
                        
                        // Tasks List
                        VStack(spacing: isPad ? 16 : 12) {
                            ForEach(quest.tasks) { task in
                                QuestTaskRow(
                                    task: task,
                                    quest: quest,
                                    onDelete: { deleteTask(task) },
                                    showConfetti: $showConfetti
                                )
                            }
                        }
                        .padding(.horizontal, sidePadding)
                        
                        // Extra bottom space so last task / panda is reachable
                        Color.clear
                            .frame(height: isPad ? 180 : 140)
                        
                        // Panda Illustration (centered, bottom-ish)
                        Image("panda-study-floor")
                            .resizable()
                            .scaledToFit()
                            .frame(height: pandaHeight)
                            .shadow(radius: 8)
                            .padding(.bottom, isPad ? 60 : 30)
                    }
                    .padding(.bottom, isPad ? 160 : 120)  // crucial: prevents cutoff
                }
                
                // Confetti Overlay
                QuestConfettiView(coinsEarned: coinsEarned, show: $showConfetti)
            }
            .scaleEffect(baseScale, anchor: .top)
        }
        // MARK: - Reward logic
        .onChange(of: showConfetti) { newValue in
            if newValue && !rewardGiven {
                coinsEarned = CoinRewards.questCompletion
                coinManager.earn(coinsEarned, reason: .questCompleted)
                rewardGiven = true
            }
        }
    }
    
    private func addTask() {
        let trimmed = newTaskText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let task = TaskItem(title: trimmed)
        quest.tasks.append(task)
        newTaskText = ""
        saveChanges()
    }
    
    private func deleteTask(_ task: TaskItem) {
        quest.tasks.removeAll { $0.id == task.id }  // safer than === for Identifiable
        saveChanges()
    }
    
    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }
}
