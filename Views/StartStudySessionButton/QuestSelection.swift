//
//  QuestSelection.swift
//  LazyPanda
//
//  Created by Bhoomi on 01/01/26.
//

import SwiftUI
import SwiftData

struct QuestSelectionView: View {

    @Query private var quests: [Quest]

    @State private var selectedQuest: Quest?
    @State private var minutes = 30
    @State private var startTimer = false

    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {

                // 📜 Quest List
                List(quests) { quest in
                    Button {
                        selectedQuest = quest
                    } label: {
                        HStack {
                            Text(quest.icon)
                            Text(quest.title)
                                .font(.custom("Cochin", size: 20))
                                .fontWeight(.bold)

                            Spacer()

                            if selectedQuest === quest {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(maxHeight: 420) // 👈 keeps controls higher on screen

                // ⏱ Duration (Styled like NewStudySession)
                Stepper("Duration: \(minutes) min",
                        value: $minutes,
                        in: 5...180,
                        step: 5)
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(20)
                    .font(.custom("Cochin", size: 20))
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // ▶️ Start Session Button
                Button {
                    startTimer = true
                } label: {
                    Text("Start Quest Session")
                        .font(.custom("Cochin", size: 20))
                        .fontWeight(.bold)
                        .frame(maxWidth: 220)
                        .padding()
                        .background(Color.brown)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                        .foregroundColor(.white)
                }
                .disabled(selectedQuest == nil)
                .opacity(selectedQuest == nil ? 0.5 : 1)

                Spacer(minLength: 20) // 👈 pushes everything slightly up
            }
            .padding(.top)
        }
        .navigationDestination(isPresented: $startTimer) {
            if let quest = selectedQuest {
                TimerView(
                    sessionTitle: quest.title,
                    totalMinutes: minutes,
                    tasks: quest.tasks
                )
            }
        }
    }
}
