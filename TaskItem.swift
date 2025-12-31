//
//  TaskItem.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import Foundation

struct TaskItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var isDone: Bool

    init(title: String, isDone: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isDone = isDone
    }
}
