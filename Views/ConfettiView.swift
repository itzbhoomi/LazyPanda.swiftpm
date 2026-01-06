//
//  ConfettiView.swift
//  LazyPanda
//
//  Created by Bhoomi on 06/01/26.
//

import SwiftUI

struct ConfettiView: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<30, id: \.self) { i in
                Circle()
                    .fill([Color.yellow, Color.orange, Color.red, Color.green].randomElement()!)
                    .frame(width: 10, height: 10)
                    .position(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: animate ? geo.size.height + 20 : -20
                    )
                    .animation(
                        .easeIn(duration: Double.random(in: 1.5...2.5))
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...0.5)),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}
