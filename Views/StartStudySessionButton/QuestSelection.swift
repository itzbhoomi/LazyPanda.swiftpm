//
//  QuestSelectionView.swift
//  LazyPanda
//
//  Created by Bhoomi on 01/01/26.
//

import SwiftUI
import SwiftData

struct QuestSelectionView: View {

    // Fetch all quests from SwiftData
    @Query private var quests: [Quest]

    // UI State
    @State private var selectedQuest: Quest?
    @State private var minutes: Int = 30
    @State private var startTimer = false

    var body: some View {
        ZStack {

            // 🌿 Background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 22) {

                // 🐼 Header
                Text("Choose a Quest")
                    .font(.custom("Cochin", size: 28))
                    .fontWeight(.bold)
                    .padding(.top)

                // 📜 Quest List
                List(quests) { quest in
                    Button {
                        selectedQuest = quest
                    } label: {
                        HStack(spacing: 12) {

                            Text(quest.icon)
                                .font(.system(size: 24))

                            Text(quest.title)
                                .font(.custom("Cochin", size: 20))
                                .fontWeight(.bold)

                            Spacer()

                            if selectedQuest?.id == quest.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 22))
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(maxHeight: 420)
                .cornerRadius(20)

                // ⏱ Duration Picker
                Stepper(
                    "Duration: \(minutes) min",
                    value: $minutes,
                    in: 5...180,
                    step: 5
                )
                .padding()
                .background(Color.white.opacity(0.6))
                .cornerRadius(22)
                .font(.custom("Cochin", size: 20))
                .fontWeight(.bold)
                .padding(.horizontal)

                // 🚀 Start Button
                Button {
                    startTimer = true
                } label: {
                    Text("Start Quest Session")
                        .font(.custom("Cochin", size: 20))
                        .fontWeight(.bold)
                        .frame(maxWidth: 240)
                        .padding()
                        .background(Color.brown)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                        .foregroundColor(.white)
                }
                .disabled(selectedQuest == nil)
                .opacity(selectedQuest == nil ? 0.5 : 1)

                Spacer(minLength: 20)
            }
            .padding(.horizontal)
        }
        .navigationDestination(isPresented: $startTimer) {
            if let quest = selectedQuest {
                TimerView(
                    sessionTitle: quest.title,
                    totalMinutes: minutes,
                    tasks: Array(quest.tasks),
                    sessionType: .quest
                )
            }
        }
    }
}
