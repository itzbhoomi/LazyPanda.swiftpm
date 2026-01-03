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

    var body: some View {
        ZStack {
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

                        HStack {
                            TextField("New task", text: $newTaskText)

                            Button {
                                guard !newTaskText.isEmpty else { return }
                                quest.tasks.append(TaskItem(title: newTaskText))
                                newTaskText = ""
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

                        VStack(spacing: 12) {
                            ForEach(quest.tasks) { task in
                                QuestTaskRow(
                                    task: task,
                                    onDelete: {
                                        quest.tasks.removeAll { $0 === task }
                                    }
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
        }
    }
}
