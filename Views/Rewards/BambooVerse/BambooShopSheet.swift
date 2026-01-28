//
//  BambooShopSheet.swift
//  LazyPanda
//
//  Created by Bhoomi on 28/01/26.
//

import SwiftUI

struct BambooShopSheet: View {

    let items: [BambooItem]
    let balance: Int
    let onBuy: (BambooItem) -> Void
    let onClose: () -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 20)
    ]

    var body: some View {
        VStack(spacing: 16) {

            // MARK: - Header (Centered, Themed)
            ZStack {
                Text("Bamboo Shop")
                    .font(.custom("Cochin", size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [.black, .brown],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(40)

                HStack {
                    Spacer()
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                }
                .padding(.trailing, 24)
            }
            .padding(.top, 12)

            // MARK: - Balance
            Text("Balance: 🪙 \(balance)")
                .font(.custom("Cochin", size: 25))
                .foregroundColor(.brown)

            // MARK: - Shop Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(items) { item in
                        VStack(spacing: 10) {

                            Image(item.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 72, height: 72)

                            Text(item.name)
                                .font(.custom("Cochin", size: 13))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)

                            // ✅ Price displayed separately with coin emoji
                            Text("🪙 \(item.price)")
                                .font(.custom("Cochin", size: 13))
                                .foregroundColor(.brown)
                                .padding(.top, 4)

                            Button {
                                onBuy(item)
                            } label: {
                                Text("Buy")
                                    .font(.custom("Cochin", size: 13))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 6)
                                    .background(
                                        LinearGradient(
                                            colors: [.black, .brown],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(14)
                            }
                        }
                        .padding(14)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.brown.opacity(0.35), lineWidth: 1)
                        )
                        .cornerRadius(18)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
        }
        .padding()
        .background(Color.white)
        .presentationDetents([.medium, .large])
    }
}
