//
//  BambooItem.swift
//  LazyPanda
//
//  Created by Bhoomi on 28/01/26.
//

import Foundation

struct BambooItem: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let price: Int
    var isUnlocked = false
    var position: CGPoint = .zero
    var scale: CGFloat = 1.0
}
