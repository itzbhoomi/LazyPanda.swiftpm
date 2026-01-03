//
//  QuestsView.swift
//  LazyPanda
//
//  Created by Bhoomi on 02/01/26.
//

import SwiftUI
import SwiftData

struct QuestsView: View {

    @Query private var quests: [Quest]
    @State private var showAddQuest = false

    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    Text("My Study Quests")
                        .font(.custom("Cochin", size: 30))
                        .padding(.top, 30)
                        .fontWeight(.black)

                    Image("panda_quests")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)

                    Button {
                        showAddQuest = true
                    } label: {
                        Text("Add New Quest")
                            .font(.custom("Cochin", size: 25))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(Gradient(colors: [.black, .brown]))
                            .cornerRadius(40)
                            .shadow(radius: 10)
                    }

                    VStack(spacing: 16) {
                        ForEach(quests) { quest in
                            NavigationLink(value: quest) {
                                QuestCard(quest: quest)
                            }
                            .frame(maxWidth: 300)
                        }
                    }
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
