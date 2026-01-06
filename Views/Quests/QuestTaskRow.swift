//
//  QuestTaskRow.swift
//  LazyPanda
//
//  Created by Bhoomi on 06/01/26.
//

import SwiftUI
import SwiftData

struct QuestTaskRow: View {

    let task: TaskItem
    let quest: Quest

    @Environment(\.modelContext) private var context
    var onDelete: () -> Void
    
    @Binding var showConfetti: Bool

    var body: some View {
        HStack {

            Button {
                task.isDone.toggle()
                saveChanges()
                checkQuestCompletionAndReward()
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .brown)
            }

            Text(task.title)
                .strikethrough(task.isDone)
                .font(.custom("Cochin", size: 20))
                .frame(maxWidth: 400, alignment: .leading)

            Menu {
                Button {
                    // edit handled in parent
                } label: {
                    Label("Edit", systemImage: "pencil")
                }

                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }

    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("❌ Failed to save task/quest changes: \(error)")
        }
    }
    
    
    private func checkQuestCompletionAndReward() {
        guard !quest.isCompleted else { return }
        let allDone = quest.tasks.allSatisfy { $0.isDone }
        guard allDone else { return }

        quest.isCompleted = true
        saveChanges()

        let wallet = getCoinWallet(context: context)
        wallet.balance += CoinRewards.questCompletion
        
        // Show confetti
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showConfetti = false
            }

        print("🎉 Quest completed → +\(CoinRewards.questCompletion) coins")
    }
}
