//
//  QuestViewModel.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//
//
//  QuestViewModel.swift
//  LazyPanda
//

import Foundation

class QuestViewModel: ObservableObject {
    @Published var quests: [Quest] = []

    // MARK: - Quest
    func addQuest(title: String, icon: String, tasks: [TaskItem]) {
        let newQuest = Quest(title: title, icon: icon, tasks: tasks)
        quests.append(newQuest)
    }

    // MARK: - Tasks
    func addTask(to questID: UUID, title: String) {
        guard let index = quests.firstIndex(where: { $0.id == questID }) else { return }
        quests[index].tasks.append(TaskItem(title: title))
    }

    func toggleTask(questID: UUID, taskID: UUID) {
        guard let qIndex = quests.firstIndex(where: { $0.id == questID }),
              let tIndex = quests[qIndex].tasks.firstIndex(where: { $0.id == taskID }) else { return }

        quests[qIndex].tasks[tIndex].isDone.toggle()
    }

    func editTask(questID: UUID, taskID: UUID, newTitle: String) {
        guard let qIndex = quests.firstIndex(where: { $0.id == questID }),
              let tIndex = quests[qIndex].tasks.firstIndex(where: { $0.id == taskID }) else { return }

        quests[qIndex].tasks[tIndex].title = newTitle
    }

    func deleteTask(questID: UUID, taskID: UUID) {
        guard let qIndex = quests.firstIndex(where: { $0.id == questID }) else { return }
        quests[qIndex].tasks.removeAll { $0.id == taskID }
    }
}
