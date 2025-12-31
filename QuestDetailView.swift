//
//  QuestDetailView.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI

struct QuestDetailView: View {
    @EnvironmentObject var questVM: QuestViewModel
    let quest: Quest

    @State private var newTaskText = ""

    // Computed binding to always get the latest quest from ViewModel
    var questBinding: Quest? {
        questVM.quests.first(where: { $0.id == quest.id })
    }

    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                ScrollView {
                    VStack(spacing: 20) {

                        // Quest title with icon
                        Text("\(quest.icon) \(quest.title)")
                            .font(.custom("Cochin", size: 30))
                            .padding(.top)

                        // Add new task field
                        HStack {
                            TextField("New task", text: $newTaskText)

                            Button {
                                guard !newTaskText.isEmpty else { return }
                                questVM.addTask(to: quest.id, title: newTaskText)
                                newTaskText = ""
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .bold))
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

                        // Task list
                        VStack(spacing: 12) {
                            if let questBinding {
                                ForEach(questBinding.tasks) { task in
                                    QuestTaskRow(
                                        questID: questBinding.id,
                                        task: task
                                    )
                                }
                            }
                        }
                        .frame(maxWidth: 350)
                    }
                    .padding(.bottom, 120) // space for panda
                }

                // Panda mascot bottom-center
                Image("panda-study-floor") // panda laying on stomach, playful legs
                    .resizable()
                    .scaledToFit()
                    .frame(height: 140)
                    .padding(.bottom, 10)
            }
        }
    }
}


