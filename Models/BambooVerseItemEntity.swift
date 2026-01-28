//
//  BambooVerseItemEntity.swift
//  LazyPanda
//
//  Created by Bhoomi on 29/01/26.
//

import SwiftData
import SwiftUI

@Model
final class BambooVerseItemEntity {

    var id: UUID
    var name: String
    var imageName: String
    var price: Int

    var x: Double
    var y: Double
    var scale: Double

    init(
        id: UUID = UUID(),
        name: String,
        imageName: String,
        price: Int,
        position: CGPoint,
        scale: CGFloat
    ) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.price = price
        self.x = position.x
        self.y = position.y
        self.scale = scale
    }

    var position: CGPoint {
        get { CGPoint(x: x, y: y) }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
}
