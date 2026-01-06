//
//  QuestDetailView.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI
import SwiftData

struct QuestDetailView: View {

    @Environment(\.modelContext) private var context
    let quest: Quest

    @State private var newTaskText = ""
    @State private var showConfetti = false  // ✅ new state for confetti

    var body: some View {
        ZStack {
            // Background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                ScrollView {
                    VStack(spacing: 20) {

                        Text("\(quest.icon) \(quest.title)")
                            .font(.custom("Cochin", size: 30))
                            .fontWeight(.black)

                        // Add task
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

                        // Tasks
                        VStack(spacing: 12) {
                            ForEach(quest.tasks) { task in
                                QuestTaskRow(
                                    task: task,
                                    quest: quest,
                                    onDelete: { deleteTask(task) },
                                    showConfetti: $showConfetti  // pass binding
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Image("panda-study-floor")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom,25)
            }

            // 🎉 Confetti overlay
            QuestConfettiView(coinsEarned: CoinRewards.questCompletion, show: $showConfetti)
        }
    }

    private func addTask() {
        guard !newTaskText.isEmpty else { return }

        let task = TaskItem(title: newTaskText)
        quest.tasks.append(task)
        newTaskText = ""
        saveChanges()
    }

    private func deleteTask(_ task: TaskItem) {
        quest.tasks.removeAll { $0 === task }
        saveChanges()
    }

    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("❌ Failed to save task/quest changes: \(error)")
        }
    }
}
