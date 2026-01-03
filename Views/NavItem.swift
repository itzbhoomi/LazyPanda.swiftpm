//
//  NavItem.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI

struct NavItem: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))

                Text(title)
                    .font(.caption2)
            }
            .foregroundColor(isActive ? .mint : .white.opacity(0.8))
        }
        .buttonStyle(.plain)
    }
}
