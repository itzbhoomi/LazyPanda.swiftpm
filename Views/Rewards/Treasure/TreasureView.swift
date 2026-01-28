//
//  TreasureView.swift
//  LazyPanda
//
//  Created by Bhoomi on 06/01/26.
//

import SwiftUI
import SwiftData

struct TreasureView: View {

    // MARK: - SwiftData
    @Query private var wallets: [CoinWallet]

    @Query(
        sort: \CoinTransaction.date,
        order: .reverse
    )
    private var transactions: [CoinTransaction]

    private var wallet: CoinWallet? {
        wallets.first
    }

    private var balance: Int {
        wallet?.balance ?? 0
    }

    @State private var glowPulse = false

    let bambooGreen = Color(red: 0.38, green: 0.67, blue: 0.45)
    let softGreen   = Color(red: 0.75, green: 0.88, blue: 0.78)

    var body: some View {
        ZStack {

            // 🌿 Background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {

                    // 🏷️ Heading
                    Text("Your Treasure Chest")
                        .font(.custom("Cochin", size: 30))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 320)
                        .background(
                            LinearGradient(
                                colors: [.black.opacity(0.8), .brown.opacity(0.9)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(40)
                        .shadow(radius: 10)
                        .padding(.top, 24)

                    // 🐼 Panda + Chest
                    ZStack {
                        Image("treasure_chest_open")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 260)

                        Image("panda_happy_coins")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .offset(x: -15, y: -30)
                    }

                    // 💰 Balance Card
                    VStack(spacing: 10) {
                        Text("Available Balance")
                            .font(.custom("Cochin", size: 22))
                            .foregroundColor(.white.opacity(0.9))
                            .fontWeight(.bold)

                        HStack(alignment: .bottom, spacing: 6) {
                            Text("\(balance)")
                                .font(.custom("Cochin", size: 42))
                                .fontWeight(.black)
                                .foregroundColor(.yellow)

                            Text("Bamboo Coins")
                                .font(.custom("Cochin", size: 24))
                                .foregroundColor(.white)
                                .offset(y: -6)
                        }
                    }
                    .padding()
                    .frame(maxWidth: 320)
                    .background(
                        LinearGradient(
                            colors: [.black.opacity(0.8), .brown.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(40)
                    .shadow(radius: 10)

                    // 📜 Recent Activity
                    VStack(alignment: .leading, spacing: 16) {

                        Text("Recent Activity")
                            .font(.custom("Cochin", size: 24))
                            .fontWeight(.black)
                            .foregroundColor(.black)
                            .padding(.horizontal)

                        VStack(spacing: 12) {

                            if transactions.isEmpty {
                                Text("No transactions yet 🌱")
                                    .font(.custom("Cochin", size: 18))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding()
                            } else {
                                ForEach(transactions.prefix(10)) { transaction in
                                    HistoryRow(transaction: transaction)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(22)
                        .padding(.horizontal)
                    }

                    Spacer().frame(height: 40)
                }
            }
        }
        .onAppear {
            print("Transactions count:", transactions.count)
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowPulse.toggle()
            }
        }
        .navigationTitle("Treasure")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HistoryRow: View {

    let transaction: CoinTransaction

    private var isEarn: Bool {
        transaction.type == .earn
    }

    private var title: String {
        if isEarn {
            return transaction.earnReason?.rawValue
                .replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
                ?? "Earned Coins"
        } else {
            return transaction.spendReason?.rawValue
                .replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
                ?? "Spent Coins"
        }
    }

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: isEarn ? "plus.circle.fill" : "minus.circle.fill")
                .foregroundColor(isEarn ? .green : .red)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Cochin", size: 18))
                    .foregroundColor(.white)

                Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.custom("Cochin", size: 14))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            Text(isEarn ? "+\(transaction.amount)" : "\(transaction.amount)")
                .font(.custom("Cochin", size: 20))
                .fontWeight(.bold)
                .foregroundColor(isEarn ? .green : .red)
        }
        .padding()
        .background(Color.black.opacity(0.35))
        .cornerRadius(18)
    }
}
