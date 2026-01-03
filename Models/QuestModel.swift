//
//  QuestModel.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftData

@Model
class Quest {
    var title: String
    var icon: String
    var tasks: [TaskItem]

    init(title: String, icon: String, tasks: [TaskItem] = []) {
        self.title = title
        self.icon = icon
        self.tasks = tasks
    }
}
