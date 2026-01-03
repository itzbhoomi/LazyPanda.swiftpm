//
//  AddQuestView.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI

struct AddQuestView: View {
    @EnvironmentObject var questVM: QuestViewModel
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

                    // Panda mascot
                    Image("panda-study") // add this to Assets
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .padding()

                    // Quest name
                    TextField("Quest name", text: $questName)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                        .frame(width: 350)
                        .font(.custom("Cochin", size:20))

                    // Icon picker
                    HStack {
                        ForEach(icons, id: \.self) { icon in
                            Text(icon)
                                .font(.largeTitle)
                                .padding(8)
                                .background(selectedIcon == icon ? Color.white.opacity(0.4) : .clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedIcon = icon
                                }
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
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Color.brown)
                                    .clipShape(Circle())
                            }
                        }
                        .frame(maxWidth: 350)
                        .padding(.leading)
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                        .frame(width: 350)
                        .font(.custom("Cochin", size:20))
                        .background(.ultraThinMaterial)
                        .cornerRadius(30)
                        .frame(width: 350)
                        .font(.custom("Cochin", size:20))

                    // Task preview
                    VStack(spacing: 12) {
                        ForEach(tasks.indices, id: \.self) { index in
                            TaskRow(
                                task: $tasks[index],
                                onDelete: {
                                    tasks.remove(at: index)
                                }
                            )
                        }
                    }
                    .frame(maxWidth: 350)


                    // Save button
                    Button {
                        questVM.addQuest(
                            title: questName,
                            icon: selectedIcon,
                            tasks: tasks
                        )
                        dismiss()
                    } label: {
                        Text("Save Quest")
                            .fontWeight(.heavy)
                            .frame(maxWidth: 320)
                            .padding()
                            .background(Color.brown)
                            .cornerRadius(30)
                            .font(.custom("Cochin", size:20))
                            .foregroundColor(Color.white)
                    }
                }
                .padding()
            }
        }
    }
}

struct TaskRow: View {
    @Binding var task: TaskItem
    @State private var showEditAlert = false
    @State private var editedTitle = ""

    var onDelete: () -> Void

    var body: some View {
        HStack {
            // Completion button
            Button {
                task.isDone.toggle()
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .brown)
                    .font(.title3)
            }

            // Task title
            Text(task.title)
                .strikethrough(task.isDone)
                .foregroundColor(task.isDone ? .gray : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("Cochin", size: 20))

            // Three dot menu
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

struct QuestTaskRow: View {
    @EnvironmentObject var questVM: QuestViewModel

    let questID: UUID
    let task: TaskItem

    @State private var showEditAlert = false
    @State private var editedTitle = ""

    var body: some View {
        HStack {
            // Completion toggle
            Button {
                questVM.toggleTask(questID: questID, taskID: task.id)
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .brown)
                    .font(.title3)
            }

            // Task title
            Text(task.title)
                .strikethrough(task.isDone)
                .foregroundColor(task.isDone ? .gray : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("Cochin", size: 20))

            // Three-dot menu
            Menu {
                Button {
                    editedTitle = task.title
                    showEditAlert = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }

                Button(role: .destructive) {
                    questVM.deleteTask(questID: questID, taskID: task.id)
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
                guard !editedTitle.isEmpty else { return }
                questVM.editTask(
                    questID: questID,
                    taskID: task.id,
                    newTitle: editedTitle
                )
            }

            Button("Cancel", role: .cancel) {}
        }
    }
}
