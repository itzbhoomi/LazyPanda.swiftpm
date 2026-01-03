//
//  SettingsView.swift
//  LazyPanda
//
//  Created by Bhoomi on 02/01/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer().frame(height: 40)

                Text("Settings")
                    .font(Font.custom("Cochin", size: 30))

                Image(systemName: "gearshape.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.mint)

                Text("Settings coming soon 🐼")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text("Customize your LazyPanda experience.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()
            }
        }
    }
}
