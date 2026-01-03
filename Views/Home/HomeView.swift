//
//  HomeView.swift
//  LazyPanda
//
//  Created by Bhoomi on 30/12/25.
//

//
//  HomeView.swift
//  LazyPanda
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var questVM: QuestViewModel
    @State private var showAddQuest = false

    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer().frame(height: 40)

                ProgressRingView(quests: questVM.quests)

                StartButton()

                TodayFocusSection(
                    quests: questVM.quests,
                    onAddQuest: {
                        showAddQuest = true
                    }
                )

                Spacer(minLength: 80)
            }
            .padding(.horizontal)
        }
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
