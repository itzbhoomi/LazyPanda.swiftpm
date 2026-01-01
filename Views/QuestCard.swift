//
//  QuestCard.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI

struct QuestCard: View {
    let quest: Quest

    var body: some View {
        HStack(spacing: 16) {
            Text(quest.icon)
                .font(.largeTitle)

            VStack(alignment: .leading) {
                Text(quest.title)
                    .font(.headline)

                Text("\(quest.tasks.count) tasks")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(18)
    }
}
