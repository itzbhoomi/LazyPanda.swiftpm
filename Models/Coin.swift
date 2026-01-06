//
//  Coin.swift
//  LazyPanda
//
//  Created by Bhoomi on 06/01/26.
//

import SwiftUI
import SwiftData

// MARK: - SwiftData Coin Model
@Model
final class CoinWallet {

    var balance: Int

    init(balance: Int = 0) {
        self.balance = balance
    }
}

// MARK: - Reasons for earning coins
enum CoinReason: String, Codable {
    case studySessionCompleted
    case questCompleted
    case weeklyStreakAchieved
    case monthlyStreakAchieved
}

// MARK: - Reasons for spending coins
enum CoinSpendReason: String, Codable {
    case bambooVerseItem
    case themePurchase
    case avatarItem
    case streakRestore
}

// MARK: - Coin Reward Values
enum CoinRewards {

    static let studySession = 10
    static let questCompletion = 20
    static let weeklyStreak = 50
    static let monthlyStreak = 100
}
