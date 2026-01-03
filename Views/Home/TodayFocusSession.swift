//
//  TodayFocusSession.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI

struct TodayFocusSection: View {
    var quests: [Quest]
    var onAddQuest: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Quests")
                .font(.custom("Cochin", size: 25))
                .fontWeight(.bold)
                .padding(.horizontal, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    
                    // + Button as first card
                    Button(action: {
                        onAddQuest()
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 25))
                            Text("Add Quest")
                                .font(.custom("Cochin", size: 15))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(width: 110, height: 120)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(18)
                        .shadow(radius: 4)
                        .foregroundStyle(Color(.brown))
                    }

                    // User quests
                    ForEach(quests) { quest in
                        NavigationLink(value: quest) {
                            FocusCard(icon: quest.icon, title: quest.title)
                        }
                        .buttonStyle(.plain) // keeps card look intact
                    }

                }
                .padding(.horizontal, 15)
            }
        }
    }
}
