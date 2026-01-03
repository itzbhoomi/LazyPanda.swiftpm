//
//  ProgressRingView.swift
//  LazyPanda
//
//  Created by Bhoomi on 30/12/25.
//

import SwiftUI

struct ProgressRingView: View {

    let quests: [Quest]

    // MARK: - Computed Values

    private var totalTasks: Int {
        quests.flatMap { $0.tasks }.count
    }

    private var completedTasks: Int {
        quests
            .flatMap { $0.tasks }
            .filter { $0.isDone }
            .count
    }

    private var progress: CGFloat {
        guard totalTasks > 0 else { return 0 }
        return CGFloat(completedTasks) / CGFloat(totalTasks)
    }

    private var pandaImageName: String {
        switch progress {
        case 0..<0.25:
            return "panda_sad"
        case 0.25..<0.5:
            return "panda_okay"
        case 0.5..<0.75:
            return "panda_happy"
        default:
            return "panda_super_happy"
        }
    }

    // MARK: - UI

    var body: some View {
        ZStack {

            // Background Ring
            Circle()
                .stroke(Color.green.opacity(0.15), lineWidth: 18)

            // Progress Ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 18,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: progress)

            // Panda at Center
            Image(pandaImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 410)
                .animation(.easeInOut(duration: 0.4), value: pandaImageName)

            // Progress Percentage
            VStack {
                Spacer()
                Text("\(Int(progress * 100))%")
                    .foregroundStyle(Color.white.opacity(1))
                    .font(.custom("Cochin", size: 20))
                    .fontWeight(.black)
                    .background(
                        Circle()
                            .fill(Gradient(colors: [.black, .brown]))
                            .frame(width: 60, height: 60)
                    )
            }
            .padding(.bottom, 3)
        }
        .frame(width: 220, height: 220)
        .background(
            Circle()
                .fill(Color.pink.opacity(0.15))
                .blur(radius: 0.5)
        )
    }
}
