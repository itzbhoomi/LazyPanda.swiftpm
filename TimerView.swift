//
//  Timer.swift
//  LazyPanda
//
//  Created by Bhoomi on 01/01/26.
//

import SwiftUI

struct TimerView: View {
    let sessionTitle: String
    let totalMinutes: Int

    @State private var remainingSeconds: Int
    @State private var timer: Timer?

    init(sessionTitle: String, totalMinutes: Int) {
        self.sessionTitle = sessionTitle
        self.totalMinutes = totalMinutes
        self._remainingSeconds = State(initialValue: totalMinutes * 60)
    }

    var body: some View {
        VStack(spacing: 24) {

            Text(sessionTitle)
                .font(.custom("Cochin", size: 28))
                .fontWeight(.bold)

            Image("panda_hourglass") // your UI image
                .resizable()
                .scaledToFit()
                .frame(height: 260)

            Text(timeString)
                .font(.system(size: 40, weight: .bold, design: .rounded))

            Button("End Session") {
                timer?.invalidate()
            }
            .foregroundColor(.red)
        }
        .onAppear(perform: startTimer)
        .padding()
    }

    var timeString: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
}

