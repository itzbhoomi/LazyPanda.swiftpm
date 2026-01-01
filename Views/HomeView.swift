//
//  HomeView.swift
//  LazyPanda
//
//  Created by Bhoomi on 30/12/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var questVM = QuestViewModel()
    @State private var showAddQuest = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer().frame(height: 40)

                    ProgressRingView()

                    StartButton()

                    TodayFocusSection(
                        quests: questVM.quests,
                        onAddQuest: {
                            showAddQuest = true
                        }
                    )

                    Spacer(minLength: 80)

                    BottomNavBar()
                }
                .padding(.horizontal)
                .zIndex(1)
            }
            // ✅ THIS is the key line
            .navigationDestination(for: Quest.self) { quest in
                QuestDetailView(quest: quest)
                    .environmentObject(questVM)
            }
            .sheet(isPresented: $showAddQuest) {
                AddQuestView()
                    .environmentObject(questVM)
            }
        }
    }
}
