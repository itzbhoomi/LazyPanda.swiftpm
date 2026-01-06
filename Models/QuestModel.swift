//
//  QuestModel.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftData
import Foundation

@Model
class Quest {
    @Attribute var title: String
    @Attribute var icon: String
    @Relationship var tasks: [TaskItem] = []  // Observable relationship
    @Attribute var isCompleted: Bool = false

    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }
}
