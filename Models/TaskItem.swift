//
//  TaskItem.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftData


@Model
class TaskItem: Identifiable {
    @Attribute var title: String
    @Attribute var isDone: Bool = false

    init(title: String) {
        self.title = title
    }
}
