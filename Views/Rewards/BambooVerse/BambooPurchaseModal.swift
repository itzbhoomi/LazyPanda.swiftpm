//
//  BambooPurchaseModal.swift
//  LazyPanda
//
//  Created by Bhoomi on 28/01/26.
//

import SwiftUI

struct BambooPurchaseModal: View {

    let item: BambooItem
    let balance: Int
    let onBuy: () -> Void
    let onClose: () -> Void

    var body: some View {
        ZStack {

            // Dim background
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            VStack(spacing: 20) {

                Image(item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)

                Text(item.name)
                    .font(.custom("Cochin", size: 24))
                    .fontWeight(.bold)

                Text("🎋 Costs \(item.price) coins")
                    .font(.headline)

                Text("🪙 You have \(balance) coins")
                    .foregroundColor(.gray)

                if balance < item.price {
                    Text("""
                    Aww panda 🐼💔
                    Not enough bamboo coins yet.
                    """)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.brown)
                }

                HStack(spacing: 14) {

                    Button("Close") {
                        onClose()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(14)

                    Button("Buy") {
                        onBuy()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(balance >= item.price ? Color.brown : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .disabled(balance < item.price)
                }
            }
            .padding()
            .frame(maxWidth: 300)
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.white)
            )
            .shadow(radius: 20)
        }
        .transition(.scale.combined(with: .opacity))
    }
}
