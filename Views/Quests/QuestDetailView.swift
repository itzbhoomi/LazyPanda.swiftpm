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

    private var questIndex: Int? {
        questVM.quests.firstIndex(where: { $0.id == quest.id })
    }

    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            if let index = questIndex {
                VStack {
                    ScrollView {
                        VStack(spacing: 20) {

                            Text("\(questVM.quests[index].icon) \(questVM.quests[index].title)")
                                .font(.custom("Cochin", size: 30))
                                .padding(.top)
                                .fontWeight(.black)

                            // Add new task
                            HStack {
                                TextField("New task", text: $newTaskText)

                                Button {
                                    guard !newTaskText.isEmpty else { return }
                                    questVM.addTask(
                                        to: questVM.quests[index].id,
                                        title: newTaskText
                                    )
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

                            // Tasks
                            VStack(spacing: 12) {
                                ForEach(questVM.quests[index].tasks) { task in
                                    QuestTaskRow(
                                        questID: questVM.quests[index].id,
                                        task: task
                                    )
                                }
                            }
                            .frame(maxWidth: 350)
                        }
                        .padding(.bottom, 120)
                    }

                    Image("panda-study-floor")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding(.bottom, 60)
                }
            } else {
                // Safety fallback (never crashes)
                Text("Quest not found 🐼")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
