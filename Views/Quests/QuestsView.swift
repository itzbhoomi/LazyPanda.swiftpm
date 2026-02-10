//
// QuestsView.swift
// LazyPanda
//
// Created by Bhoomi on 02/01/26.
//
import SwiftUI
import SwiftData

struct QuestsView: View {
    
    @Query private var quests: [Quest]
    @State private var showAddQuest = false
    
    var body: some View {
        GeometryReader { geo in
            let isPad             = geo.size.width > 600
            let baseScale         = isPad ? 1.30 : 1.00
            let maxCardWidth      = isPad ? 520 : 300
            let horizontalPadding = isPad ? 100 : 24
            let pandaSize: CGFloat = isPad ? 280 : 200
            
            ZStack {
                // 🌿 Background
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: isPad ? 40 : 24) {
                        Spacer()
                            .frame(height: isPad ? 80 : 40)
                        
                        // Title
                        Text("My Study Quests")
                            .font(.custom("Cochin", size: isPad ? 42 : 30))
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                        
                        // Panda illustration
                        Image("panda_quests")
                            .resizable()
                            .scaledToFit()
                            .frame(width: pandaSize)
                            .shadow(radius: 8)
                            .padding(.vertical, isPad ? 20 : 10)
                        
                        // Add New Quest button
                        Button {
                            showAddQuest = true
                        } label: {
                            Text("Add New Quest")
                                .font(.custom("Cochin", size: isPad ? 28 : 25))
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .frame(maxWidth: isPad ? 420 : 300)
                                .padding(.vertical, isPad ? 20 : 16)
                                .background(
                                    LinearGradient(
                                        colors: [.black, .brown],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(40)
                                .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 6)
                        }
                        .scaleEffect(baseScale * 1.1)
                        
                        // Quest cards grid / list
                        if quests.isEmpty {
                            Text("No quests yet.\nStart your first adventure!")
                                .font(.custom("Cochin", size: isPad ? 26 : 20))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 40)
                        } else {
                            LazyVGrid(columns: isPad ? [
                                GridItem(.flexible(), spacing: 24),
                                GridItem(.flexible(), spacing: 24)
                            ] : [GridItem(.flexible())], spacing: isPad ? 32 : 16) {
                                ForEach(quests) { quest in
                                    NavigationLink(value: quest) {
                                        QuestCard(quest: quest)
                                            .frame(maxWidth: CGFloat(maxCardWidth))
                                    }
                                }
                            }
                            .padding(.bottom, isPad ? 80 : 0)
                        }
                        
                        Spacer(minLength: isPad ? 120 : 80)
                        
                        Color.clear
                                    .frame(height: isPad ? 350 : 100)
                    }
                    .padding(.horizontal, CGFloat(horizontalPadding))
                    .scaleEffect(baseScale, anchor: .top)
                    
                    Spacer()
                        .frame(height: isPad ? 80 : 40)
                }
            }
            
        }
        .navigationDestination(for: Quest.self) { quest in
            QuestDetailView(quest: quest)
        }
        
        .sheet(isPresented: $showAddQuest) {
            AddQuestView()
        }
    }
}
