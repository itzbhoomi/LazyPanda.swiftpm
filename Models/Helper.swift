//
//  Helper.swift
//  LazyPanda
//
//  Created by Bhoomi on 06/01/26.
//

import SwiftData

func getCoinWallet(context: ModelContext) -> CoinWallet {
    let descriptor = FetchDescriptor<CoinWallet>()
    if let wallet = try? context.fetch(descriptor).first {
        return wallet
    } else {
        let wallet = CoinWallet()
        context.insert(wallet)
        return wallet
    }
}
