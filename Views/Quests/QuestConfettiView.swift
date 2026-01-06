//
//  QuestConfettiView.swift
//  LazyPanda
//
//  Created by Bhoomi on 06/01/26.
//

import SwiftUI

struct QuestConfettiView: View {

    let coinsEarned: Int
    @Binding var show: Bool

    var body: some View {
        if show {
            ZStack {
                // Background confetti
                ConfettiView()
                    .ignoresSafeArea()

                VStack(spacing: 20) {

                    // Panda mascot holding coins
                    Image("panda_happy_coins")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)

                    // Congratulatory message
                    Text("Quest Completed!")
                        .font(.custom("Cochin", size: 28))
                        .fontWeight(.black)
                        .foregroundColor(.yellow)

                    Text("Congratulations! You earned \(coinsEarned) coins 🎉")
                        .font(.custom("Cochin", size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(40)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
            }
            .transition(.opacity.combined(with: .scale))
            .zIndex(100)
        }
    }
}

