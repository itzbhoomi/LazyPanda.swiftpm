//
//  QuestDetailView.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
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
    @State private var rewardGiven = false  // To prevent double earning

    // MARK: - Body
    var body: some View {
        ZStack {
            // 🌿 Background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                ScrollView {
                    VStack(spacing: 20) {

                        // Quest Title
                        Text("\(quest.icon) \(quest.title)")
                            .font(.custom("Cochin", size: 30))
                            .fontWeight(.black)

                        // Add Task Section
                        HStack {
                            TextField("New task", text: $newTaskText)

                            Button {
                                addTask()
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .frame(width: 45, height: 45)
                                    .background(Color.brown)
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                        .frame(maxWidth: 350)

                        // Tasks List
                        VStack(spacing: 12) {
                            ForEach(quest.tasks) { task in
                                QuestTaskRow(
                                    task: task,
                                    quest: quest,
                                    onDelete: { deleteTask(task) },
                                    showConfetti: $showConfetti
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Panda Illustration
                Image("panda-study-floor")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 25)
            }

            // 🎉 Confetti Overlay
            QuestConfettiView(coinsEarned: coinsEarned, show: $showConfetti)
        }
        // MARK: - Reward Coins when confetti triggers
        .onChange(of: showConfetti) { newValue in
            if newValue && !rewardGiven {
                coinsEarned = CoinRewards.questCompletion
                coinManager.earn(coinsEarned, reason: .questCompleted)
                rewardGiven = true
            }
        }
    }

    // MARK: - Add a new task
    private func addTask() {
        guard !newTaskText.isEmpty else { return }

        let task = TaskItem(title: newTaskText)
        quest.tasks.append(task)
        newTaskText = ""
        saveChanges()
    }

    // MARK: - Delete task
    private func deleteTask(_ task: TaskItem) {
        quest.tasks.removeAll { $0 === task }
        saveChanges()
    }

    // MARK: - Save changes
    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("❌ Failed to save task/quest changes: \(error)")
        }
    }
}
