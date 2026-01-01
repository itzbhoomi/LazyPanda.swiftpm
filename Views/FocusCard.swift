//
//  FocusCard.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI

struct FocusCard: View {
    let icon: String // can be SF Symbol or emoji
    let title: String

    var body: some View {
        VStack(spacing: 12) {
            if icon.isSingleEmoji { // check if it's an emoji
                Text(icon)
                    .font(.system(size: 35)) // larger size for emoji
            } else {
                Image(systemName: icon)
                    .font(.system(size: 25))
            }

            Text(title)
                .font(.custom("Cochin", size: 15))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(width: 110, height: 120)
        .background(Color.white.opacity(0.7))
        .cornerRadius(18)
        .shadow(radius: 4)
    }
}

// Helper to detect emoji
extension String {
    var isSingleEmoji: Bool {
        return count == 1 && first?.isEmoji == true
    }
}

extension Character {
    var isEmoji: Bool {
        // Swift 5.3+ built-in property
        return unicodeScalars.first?.properties.isEmojiPresentation ?? false
    }
}
