//
//  QuestModel.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import Foundation

struct Quest: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var icon: String
    var tasks: [TaskItem]  // <-- use TaskItem consistently

    init(title: String, icon: String, tasks: [TaskItem] = []) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.tasks = tasks
    }
}

