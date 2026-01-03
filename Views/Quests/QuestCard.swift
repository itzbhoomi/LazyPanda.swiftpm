//
//  QuestCard.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI
import SwiftData

struct QuestCard: View {
    let quest: Quest

    @Environment(\.modelContext) private var context
    @State private var showDeleteAlert = false

    var body: some View {
        HStack(spacing: 16) {

            Text(quest.icon)
                .font(.custom("Cochin", size: 30))

            VStack(alignment: .leading, spacing: 4) {
                Text(quest.title)
                    .font(.custom("Cochin", size: 20))
                    .foregroundStyle(.black)

                Text("\(quest.tasks.count) tasks")
                    .font(.custom("Cochin", size: 15))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // 🗑️ Visible delete button
            Button {
                showDeleteAlert = true
            } label: {
                Image(systemName: "trash")
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .clipShape(Circle())
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(30)

        // ⚠️ Confirmation alert
        .alert("Delete Quest?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                context.delete(quest)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete this quest and all its tasks.")
        }
    }
}
