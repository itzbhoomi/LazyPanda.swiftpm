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
import SwiftData

struct HomeView: View {

    @Query private var quests: [Quest]
    @State private var showAddQuest = false

    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer().frame(height: 40)

                ProgressRingView(quests: quests)

                StartButton()

                TodayFocusSection(
                    quests: quests,
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
        }
        .sheet(isPresented: $showAddQuest) {
            AddQuestView()
        }
    }
}
