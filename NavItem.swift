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
    var active: Bool = false

    var body: some View {
        VStack {
            Image(systemName: icon)
            Text(title)
                .font(.caption2)
        }
        .foregroundColor(active ? .green : .gray)
    }
}

