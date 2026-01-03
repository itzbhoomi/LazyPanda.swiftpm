//
//  Timer.swift
//  LazyPanda
//
//  Created by Bhoomi on 01/01/26.
//

import SwiftUI

struct TimerView: View {

    let sessionTitle: String
    let totalMinutes: Int

    @State private var sessionTasks: [TaskItem]

    @Environment(\.dismiss) private var dismiss

    @State private var remainingSeconds: Int
    @State private var timer: Timer?

    // MARK: - Init
    init(sessionTitle: String, totalMinutes: Int, tasks: [TaskItem]) {
        self.sessionTitle = sessionTitle
        self.totalMinutes = totalMinutes
        self._remainingSeconds = State(initialValue: totalMinutes * 60)
        self._sessionTasks = State(initialValue: tasks)
    }

    var body: some View {
        ZStack {
            // 🌿 Background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {

                    // 🐼 Title
                    Text(sessionTitle)
                        .font(.custom("Cochin", size: 30))
                        .fontWeight(.bold)

                    // ⏳ Panda Hourglass
                    Image("panda_hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 260)

                    // ⌛ Timer
                    Text(timeString)
                        .font(.custom("Cochin", size: 42))
                        .fontWeight(.bold)

                    // 📋 Tasks
                    if !sessionTasks.isEmpty {
                        VStack(alignment: .leading, spacing: 14) {

                            Text("Session Tasks")
                                .font(.custom("Cochin", size: 22))
                                .fontWeight(.semibold)

                            ForEach($sessionTasks) { $task in
                                HStack {

                                    // ✅ isDone toggle
                                    Button {
                                        task.isDone.toggle()
                                    } label: {
                                        Image(systemName: task.isDone
                                              ? "checkmark.circle.fill"
                                              : "circle")
                                            .foregroundColor(task.isDone ? .green : .gray)
                                            .font(.system(size: 22))
                                    }

                                    // ✏️ Editable title
                                    TextField("Task", text: $task.title)
                                        .font(.custom("Cochin", size: 18))
                                        .strikethrough(task.isDone)
                                        .opacity(task.isDone ? 0.5 : 1)

                                    Spacer()

                                    // ⋯ Menu
                                    Menu {
                                        Button(role: .destructive) {
                                            sessionTasks.removeAll { $0.id == task.id }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .rotationEffect(.degrees(90))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.6))
                                .cornerRadius(20)
                                .shadow(radius: 4)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(26)
                        .shadow(radius: 8)
                    }

                    // 🛑 End Session (RED THEME)
                    Button {
                        timer?.invalidate()
                        dismiss()
                    } label: {
                        Text("End Session")
                            .font(.custom("Cochin", size: 20))
                            .fontWeight(.bold)
                            .frame(maxWidth: 220)
                            .padding()
                            .background(Color.red.opacity(0.9))
                            .cornerRadius(30)
                            .shadow(radius: 10)
                            .foregroundColor(.white)
                    }

                    Spacer(minLength: 100)
                }
                .padding()
            }
        }
        .onAppear(perform: startTimer)
        .onDisappear {
            timer?.invalidate()
        }
    }

    // MARK: - Timer Logic
    private var timeString: String {
        String(format: "%02d:%02d",
               remainingSeconds / 60,
               remainingSeconds % 60)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
}
