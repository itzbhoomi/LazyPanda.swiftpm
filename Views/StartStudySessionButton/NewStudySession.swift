//
// NewStudySessionView.swift
// LazyPanda
//
// Created by Bhoomi on 01/01/26.
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
        GeometryReader { geo in
            let isPad       = geo.size.width > 600
            let baseScale   = isPad ? 1.30 : 1.00
            let maxFormWidth: CGFloat = isPad ? 680 : .infinity
            let horizontalPadding: CGFloat = isPad ? 140 : 24
            
            ZStack {
                // 🌿 Background
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: isPad ? 36 : 26) {
                        Spacer()
                            .frame(height: isPad ? 60 : 20)
                        
                        // 🐼 Title
                        Text("New Study Session")
                            .font(.custom("Cochin", size: isPad ? 42 : 32))
                            .fontWeight(.bold)
                        
                        // ✏️ Session Title
                        TextField("Session Title", text: $title)
                            .padding()
                            .frame(maxWidth: maxFormWidth)
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(20)
                            .shadow(radius: 6)
                            .font(.custom("Cochin", size: isPad ? 24 : 20))
                            .fontWeight(.bold)
                        
                        // ⏱ Duration
                        Stepper(
                            "Duration: \(minutes) min",
                            value: $minutes,
                            in: 1...180,
                            step: 5
                        )
                        .padding()
                        .frame(maxWidth: maxFormWidth)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(20)
                        .font(.custom("Cochin", size: isPad ? 24 : 20))
                        .fontWeight(.bold)
                        
                        // ➕ Add Task
                        HStack {
                            TextField("New task", text: $newTaskText)
                                .font(.custom("Cochin", size: isPad ? 22 : 20))
                            
                            Button {
                                addTask()
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .frame(width: isPad ? 52 : 44, height: isPad ? 52 : 44)
                                    .background(Color.brown)
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                        .frame(maxWidth: maxFormWidth)
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(30)
                        .font(.custom("Cochin", size: isPad ? 22 : 20))
                        .fontWeight(.bold)
                        
                        // 📋 Task List
                        if !tasks.isEmpty {
                            VStack(spacing: 14) {
                                ForEach(tasks) { task in
                                    taskRow(task, isPad: isPad)
                                        .frame(maxWidth: maxFormWidth)
                                }
                            }
                        }
                        
                        // 🚀 Start Button
                        Button {
                            startTimer = true
                        } label: {
                            Text("Start Session")
                                .font(.custom("Cochin", size: isPad ? 24 : 20))
                                .fontWeight(.bold)
                                .frame(maxWidth: isPad ? 340 : 220)
                                .padding(.vertical, isPad ? 20 : 16)
                                .background(Color.brown)
                                .cornerRadius(30)
                                .shadow(radius: 10)
                                .foregroundColor(.white)
                        }
                        .disabled(minutes <= 0)
                        .opacity(minutes <= 0 ? 0.5 : 1)
                        .scaleEffect(baseScale * 1.15)
                        
                        Spacer(minLength: isPad ? 120 : 80)
                    }
                    .padding(.horizontal, horizontalPadding)
                    .scaleEffect(baseScale, anchor: .top)
                }
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
    private func taskRow(_ task: TaskItem, isPad: Bool) -> some View {
        HStack(spacing: isPad ? 16 : 12) {
            Button {
                toggle(task)
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: isPad ? 28 : 24))
                    .foregroundColor(task.isDone ? .green : .gray)
            }
            
            Text(task.title)
                .strikethrough(task.isDone)
                .opacity(task.isDone ? 0.5 : 1)
                .font(.custom("Cochin", size: isPad ? 26 : 22))
                .fontWeight(.bold)
            
            Spacer()
            
            Menu {
                Button("Delete", role: .destructive) {
                    delete(task)
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: isPad ? 24 : 20))
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
