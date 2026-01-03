//
//  QuestSelection.swift
//  LazyPanda
//
//  Created by Bhoomi on 01/01/26.
//

import SwiftUI

struct QuestSelectionView: View {

    @EnvironmentObject var questVM: QuestViewModel

    @State private var selectedQuest: Quest?
    @State private var minutes = 30
    @State private var startTimer = false

    var body: some View {
        ZStack {
            // 🌿 Theme background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {

                List(questVM.quests) { quest in
                    Button {
                        selectedQuest = quest
                    } label: {
                        HStack {
                            Text(quest.icon)
                            Text(quest.title)
                            Spacer()
                            if selectedQuest?.id == quest.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .font(.custom("Cochin", size: 18))
                    }
                }
                .scrollContentBackground(.hidden)

                Stepper {
                    Text("Duration: \(minutes) min")
                        .font(.custom("Cochin", size: 18))
                } onIncrement: {
                    minutes += 5
                } onDecrement: {
                    minutes = max(5, minutes - 5)
                }
                .padding()
                .background(Color.white.opacity(0.6))
                .cornerRadius(20)
                .shadow(radius: 6)
                .padding()

                Button {
                    startTimer = true
                } label: {
                    Text("Start Quest Session")
                        .font(.custom("Cochin", size: 20))
                        .fontWeight(.bold)
                        .frame(maxWidth: 240)
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(30)
                        .shadow(radius: 8)
                }
                .disabled(selectedQuest == nil)
                .opacity(selectedQuest == nil ? 0.5 : 1)

                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Choose Quest")
        .navigationDestination(isPresented: $startTimer) {
            if let quest = selectedQuest {
                TimerView(
                    sessionTitle: quest.title,
                    totalMinutes: minutes,
                    tasks: quest.tasks   // ✅ PASS DIRECTLY
                )
            }
        }
    }
}
