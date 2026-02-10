//
//  HomeView.swift
//  LazyPanda
//
//  Created by Bhoomi on 30/12/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query private var quests: [Quest]
    @State private var showAddQuest = false
    
    var body: some View {
        GeometryReader { geo in
            let isPad = geo.size.width > 600
            let baseScale: CGFloat = isPad ? 1.35 : 1.0
            
            ZStack {
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 36 * baseScale) {
                        Spacer()
                            .frame(height: isPad ? 80 : 50)
                        
                        ProgressRingView(quests: quests)
                            .frame(width: isPad ? 380 : 280)
                            .scaleEffect(baseScale * 1.1)
                        
                        StartButton()
                            .frame(maxWidth: isPad ? 400 : 300)
                            .scaleEffect(baseScale * 1.2)
                            .padding(.top, isPad ? 80 : 20)
                        
                        TodayFocusSection(quests: quests, onAddQuest: {
                            showAddQuest = true
                        })
                        .frame(maxWidth: isPad ? 680 : .infinity)
                        .scaleEffect(baseScale * 1.08)
                        
                        Spacer(minLength: isPad ? 100 : 90)
                    }
                    .padding(.horizontal, isPad ? 160 : 24)
                }
            }
        }
        .navigationDestination(for: Quest.self) { quest in
            QuestDetailView(quest: quest)
        }
        .sheet(isPresented: $showAddQuest) {
            AddQuestView()
        }
        .presentationDetents([.large])          // ← full height
        .presentationDragIndicator(.visible)
    }
}
