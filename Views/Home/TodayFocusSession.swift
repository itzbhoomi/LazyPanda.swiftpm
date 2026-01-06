//
//  TodayFocusSession.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI
import SwiftData

struct TodayFocusSection: View {
    var quests: [Quest]
    var onAddQuest: () -> Void

    @Environment(\.modelContext) private var context
    @State private var questToDelete: Quest?   // 👈 track which quest is being deleted

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Today's Quests")
                .font(.custom("Cochin", size: 25))
                .fontWeight(.bold)
                .padding(.horizontal, 10)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {

                    // ➕ Add Quest card
                    Button(action: { onAddQuest() }) {
                        VStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 25))
                            Text("Add Quest")
                                .font(.custom("Cochin", size: 15))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(width: 110, height: 120)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(18)
                        .shadow(radius: 4)
                        .foregroundStyle(Color(.brown))
                    }

                    // 🧭 User quests
                    ForEach(quests) { quest in
                        NavigationLink(value: quest) {
                            FocusCard(icon: quest.icon, title: quest.title, isCompleted: quest.isCompleted)
                                .simultaneousGesture(
                                    LongPressGesture(minimumDuration: 0.6)
                                        .onEnded { _ in
                                            questToDelete = quest
                                        }
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 15)
            }
        }
        // ⚠️ Confirmation Alert
        .alert("Delete Quest?", isPresented: .constant(questToDelete != nil)) {
            Button("Delete", role: .destructive) {
                if let quest = questToDelete {
                    context.delete(quest)
                }
                questToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                questToDelete = nil
            }
        } message: {
            Text("This will permanently delete this quest and all its tasks.")
        }
    }
}
