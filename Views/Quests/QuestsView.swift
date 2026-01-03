//
//  QuestsView.swift
//  LazyPanda
//
//  Created by Bhoomi on 02/01/26.
//

import SwiftUI

struct QuestsView: View {

    @EnvironmentObject var questVM: QuestViewModel
    @State private var showAddQuest = false

    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    // Title
                    Text("My Study Quests")
                        .font(Font.custom("Cochin", size: 30))
                        .padding(.top, 30)
                        .fontWeight(.black)

                    // Panda Mascot
                    Image("panda_quests")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)

                    // Add Quest Button
                    Button {
                        showAddQuest = true
                    } label: {
                        Text("Add New Quest")
                            .font(.custom("Cochin", size: 25))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(Gradient(colors: [Color.black, Color.brown]))
                            .cornerRadius(40)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal)

                    // Quest List
                    VStack(spacing: 16) {
                        ForEach(questVM.quests) { quest in
                            NavigationLink {
                                QuestDetailView(quest: quest)
                                    .environmentObject(questVM) // 🔥 CRITICAL FIX
                            } label: {
                                QuestCard(quest: quest)
                                    .font(.custom("Cochin", size: 25))
                                    .fontWeight(.black)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 350)
                                                              }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showAddQuest) {
            AddQuestView()
                .environmentObject(questVM)
        }
    }
}
