//
// QuestTaskRow.swift
// LazyPanda
//
// Created by Bhoomi on 06/01/26.
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
        GeometryReader { geo in
            let isPad = geo.size.width > 600
            let fontSize: CGFloat = isPad ? 24 : 20
            let iconSize: CGFloat = isPad ? 28 : 24
            let maxTextWidth: CGFloat = isPad ? 580 : 400
            let paddingHorizontal: CGFloat = isPad ? 20 : 16
            let paddingVertical: CGFloat = isPad ? 16 : 12
            
            HStack(spacing: isPad ? 16 : 12) {
                // Checkbox / toggle
                Button {
                    task.isDone.toggle()
                    saveChanges()
                    checkQuestCompletionAndReward()
                } label: {
                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: iconSize))
                        .foregroundColor(task.isDone ? .green : .brown)
                }
                
                // Task title
                Text(task.title)
                    .strikethrough(task.isDone)
                    .foregroundColor(task.isDone ? .gray : .primary)
                    .font(.custom("Cochin", size: fontSize))
                    .fontWeight(.medium)
                    .frame(maxWidth: maxTextWidth, alignment: .leading)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Menu (edit + delete)
                Menu {
                    Button {
                        // Edit handled in parent view
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.system(size: isPad ? 24 : 20))
                        .foregroundColor(.brown)
                }
            }
            .padding(.horizontal, paddingHorizontal)
            .padding(.vertical, paddingVertical)
            .background(.ultraThinMaterial)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        }
        .frame(height: 70)           // consistent row height
        .frame(maxWidth: .infinity)  // fills available width
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
        
        // Trigger confetti
        showConfetti = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showConfetti = false
        }
        
        print("🎉 Quest completed → +\(CoinRewards.questCompletion) coins")
    }
}
