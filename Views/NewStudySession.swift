//
//  NewStudySession.swift
//  LazyPanda
//
//  Created by Bhoomi on 01/01/26.
//

import SwiftUI

struct NewStudySessionView: View {

    @State private var title = ""
    @State private var minutes = 25

    @State private var newTaskText = ""
    @State private var tasks: [TaskItem] = []

    @State private var startTimer = false

    var body: some View {
        ZStack {
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    Text("New Study Session")
                        .font(.custom("Cochin", size: 32))
                        .fontWeight(.bold)

                    TextField("Session Title", text: $title)
                        .padding()
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(20)
                        .shadow(radius: 6)
                        .font(.custom("Cochin", size: 20))
                        .fontWeight(.bold)
                    
                    Stepper("Duration: \(minutes) min", value: $minutes, in: 5...180, step: 5)
                        .padding()
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(20)
                        .font(.custom("Cochin", size: 20))
                        .fontWeight(.bold)

                    // ➕ Add Task
                    HStack {
                        TextField("New task", text: $newTaskText)

                        Button {
                            guard !newTaskText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                            tasks.append(TaskItem(title: newTaskText))
                            newTaskText = ""
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
                    VStack(spacing: 12) {
                        ForEach(tasks) { task in
                            taskRow(task)
                        }
                    }

                    Button { startTimer = true } label: { Text("Start Session") .font(.custom("Cochin", size: 20)) .fontWeight(.bold) .frame(maxWidth: 220) .padding() .background(Color.brown.opacity(1)) .cornerRadius(30) .shadow(radius: 10) .foregroundColor(Color.white) }
                }
                .padding()
            }
        }
        .navigationDestination(isPresented: $startTimer) {
            TimerView(
                sessionTitle: title.isEmpty ? "Focus Session" : title,
                totalMinutes: minutes,
                tasks: tasks
            )
        }
    }

    // MARK: - Inline Task Row
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
                .font(.custom("Cochin", size: 25))
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

    private func toggle(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }

    private func delete(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
}
