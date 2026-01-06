//
//  NewStudySession.swift
//  LazyPanda
//
//  Created by Bhoomi on 01/01/26.
//

import SwiftUI

struct NewStudySessionView: View {

    // MARK: - Session State
    @State private var title = ""
    @State private var minutes = 25

    // MARK: - Tasks
    @State private var newTaskText = ""
    @State private var tasks: [TaskItem] = []

    // MARK: - Navigation
    @State private var startTimer = false

    var body: some View {
        ZStack {

            // 🌿 Background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 26) {

                    // 🐼 Title
                    Text("New Study Session")
                        .font(.custom("Cochin", size: 32))
                        .fontWeight(.bold)

                    // ✏️ Session Title
                    TextField("Session Title", text: $title)
                        .padding()
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(20)
                        .shadow(radius: 6)
                        .font(.custom("Cochin", size: 20))
                        .fontWeight(.bold)

                    // ⏱ Duration
                    Stepper(
                        "Duration: \(minutes) min",
                        value: $minutes,
                        in: 1...180,
                        step: 5
                    )
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(20)
                    .font(.custom("Cochin", size: 20))
                    .fontWeight(.bold)

                    // ➕ Add Task
                    HStack {
                        TextField("New task", text: $newTaskText)

                        Button {
                            addTask()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.brown)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(30)
                    .font(.custom("Cochin", size: 20))
                    .fontWeight(.bold)

                    // 📋 Task List
                    if !tasks.isEmpty {
                        VStack(spacing: 12) {
                            ForEach(tasks) { task in
                                taskRow(task)
                            }
                        }
                    }

                    // 🚀 Start Button
                    Button {
                        startTimer = true
                    } label: {
                        Text("Start Session")
                            .font(.custom("Cochin", size: 20))
                            .fontWeight(.bold)
                            .frame(maxWidth: 220)
                            .padding()
                            .background(Color.brown)
                            .cornerRadius(30)
                            .shadow(radius: 10)
                            .foregroundColor(.white)
                    }
                    .disabled(minutes <= 0)
                    .opacity(minutes <= 0 ? 0.5 : 1)

                    Spacer(minLength: 60)
                }
                .padding()
            }
        }
        .navigationDestination(isPresented: $startTimer) {
            TimerView(
                sessionTitle: title.isEmpty ? "Focus Session" : title,
                totalMinutes: minutes,
                tasks: tasks,
                sessionType: .study
            )
        }
    }

    // MARK: - Task Row
    private func taskRow(_ task: TaskItem) -> some View {
        HStack {

            Button {
                toggle(task)
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .gray)
            }

            Text(task.title)
                .strikethrough(task.isDone)
                .opacity(task.isDone ? 0.5 : 1)
                .font(.custom("Cochin", size: 22))
                .fontWeight(.bold)

            Spacer()

            Menu {
                Button("Delete", role: .destructive) {
                    delete(task)
                }
            } label: {
                Image(systemName: "ellipsis")
            }
        }
        .padding()
        .background(Color.white.opacity(0.6))
        .cornerRadius(18)
    }

    // MARK: - Helpers
    private func addTask() {
        let trimmed = newTaskText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        tasks.append(TaskItem(title: trimmed))
        newTaskText = ""
    }

    private func toggle(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }

    private func delete(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
}
