//
//  SparkleView.swift
//  LazyPanda
//
//  Created by Bhoomi on 28/01/26.
//

import SwiftUI

struct SparkleView: View {
    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0.0

    var body: some View {
        Image(systemName: "sparkles")
            .foregroundColor(.yellow)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4)) {
                    scale = 1.3
                    opacity = 1
                }

                withAnimation(.easeIn(duration: 0.6).delay(0.5)) {
                    opacity = 0
                }
            }
    }
}
