//
//  AddQuestView.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI
import SwiftData

struct AddQuestView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    @State private var questName = ""
    @State private var selectedIcon = "📘"
    @State private var taskText = ""
    @State private var tasks: [TaskItem] = []

    let icons = ["📘", "🧠", "🎯", "⏳", "🔥", "🐼"]

    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    Image("panda-study")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .padding()

                    TextField("Quest name", text: $questName)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                        .frame(width: 350)
                        .font(.custom("Cochin", size: 20))

                    HStack {
                        ForEach(icons, id: \.self) { icon in
                            Text(icon)
                                .font(.largeTitle)
                                .padding(8)
                                .background(selectedIcon == icon ? Color.white.opacity(0.4) : .clear)
                                .cornerRadius(10)
                                .onTapGesture { selectedIcon = icon }
                        }
                    }

                    // Add task
                    HStack {
                        TextField("New task", text: $taskText)

                        Button {
                            guard !taskText.isEmpty else { return }
                            tasks.append(TaskItem(title: taskText))
                            taskText = ""
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.brown)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                    .frame(width: 350)

                    // Task list
                    VStack(spacing: 12) {
                        ForEach(tasks.indices, id: \.self) { index in
                            TaskRow(task: $tasks[index]) {
                                tasks.remove(at: index)
                            }
                        }
                    }

                    // Save quest
                    Button {
                        saveQuest()
                    } label: {
                        Text("Save Quest")
                            .frame(maxWidth: 320)
                            .padding()
                            .background(Color.brown)
                            .cornerRadius(30)
                            .foregroundColor(.white)
                            .font(.custom("Cochin", size: 20))
                    }
                }
                .padding()
            }
        }
    }

    private func saveQuest() {
        guard !questName.isEmpty else { return }

        let quest = Quest(title: questName, icon: selectedIcon)
        for task in tasks {
            quest.tasks.append(task)  // Append to relationship
        }

        context.insert(quest)

        do {
            try context.save()
            dismiss()
        } catch {
            print("❌ Failed to save quest: \(error)")
        }
    }
}

struct TaskRow: View {
    @Binding var task: TaskItem
    var onDelete: () -> Void

    @State private var showEditAlert = false
    @State private var editedTitle = ""

    var body: some View {
        HStack {
            Button {
                task.isDone.toggle()
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .brown)
            }

            Text(task.title)
                .strikethrough(task.isDone)
                .foregroundColor(task.isDone ? .gray : .primary)
                .frame(maxWidth: 270, alignment: .leading)
                .font(.custom("Cochin", size: 20))

            Menu {
                Button {
                    editedTitle = task.title
                    showEditAlert = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }

                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .foregroundColor(.brown)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .alert("Edit Task", isPresented: $showEditAlert) {
            TextField("Task name", text: $editedTitle)
            Button("Save") {
                if !editedTitle.isEmpty {
                    task.title = editedTitle
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
