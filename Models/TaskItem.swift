//
//  TaskItem.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftData

@Model
class TaskItem {
    var title: String
    var isDone: Bool

    init(title: String, isDone: Bool = false) {
        self.title = title
        self.isDone = isDone
    }
}
