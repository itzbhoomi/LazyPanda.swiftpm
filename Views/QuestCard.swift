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
                .font(.custom("Cochin", size: 30))

            VStack(alignment: .leading) {
                Text(quest.title)
                    .font(.custom("Cochin", size: 20))
                    .foregroundStyle(Color(.black))

                Text("\(quest.tasks.count) tasks")
                    .font(.custom("Cochin", size: 15))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(30)
    }
}
