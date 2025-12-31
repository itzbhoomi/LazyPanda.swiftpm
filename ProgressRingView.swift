//
//  ProgressRingView.swift
//  LazyPanda
//
//  Created by Bhoomi on 30/12/25.
//

import SwiftUI
struct ProgressRingView: View {
    let progress: CGFloat = 0.65

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.green.opacity(0.2), lineWidth: 18)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            // 🐼 Panda
            Image("panda")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .offset(x: 70, y: -70)
        }
        .frame(width: 220, height: 220)
        .background(
            Circle()
                .fill(Color.white.opacity(0.7))
                .blur(radius: 0.5)
        )
    }
}

