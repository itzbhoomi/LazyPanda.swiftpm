//
// AddQuestView.swift
// LazyPanda
//
// Created by Bhoomi on 31/12/25.
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
        GeometryReader { geo in
            let isPad = geo.size.width > 600
            let baseScale = isPad ? 1.35 : 1.05   // stronger feel on iPad
            
            // More generous padding
            let sidePadding: CGFloat = isPad ? 80 : 28
            let fieldPadding: CGFloat = isPad ? 20 : 16
            
            // Larger sizes
            let titleFont: CGFloat     = isPad ? 36 : 26
            let fieldFont: CGFloat     = isPad ? 28 : 22
            let taskFont: CGFloat      = isPad ? 26 : 20
            let iconSize: CGFloat      = isPad ? 60 : 44
            let pandaHeight: CGFloat   = isPad ? 280 : 180
            let buttonHeight: CGFloat  = isPad ? 68 : 56
            let plusSize: CGFloat      = isPad ? 32 : 24
            let plusFrame: CGFloat     = isPad ? 80 : 64
            
            ZStack {
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: isPad ? 44 : 28) {
                        Spacer()
                            .frame(height: isPad ? 100 : 50)
                        
                        // Panda – much larger
                        Image("panda-study")
                            .resizable()
                            .scaledToFit()
                            .frame(height: pandaHeight)
                            .shadow(radius: 10)
                        
                        // Quest name field – bigger & taller
                        TextField("Quest name", text: $questName)
                            .font(.custom("Cochin", size: titleFont))
                            .fontWeight(.medium)
                            .padding(fieldPadding * 1.5)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 36))
                            .overlay(
                                RoundedRectangle(cornerRadius: 36)
                                    .stroke(Color.brown.opacity(0.3), lineWidth: 1)
                            )
                        
                        // Icon picker – larger icons, more spacing
                        HStack(spacing: isPad ? 40 : 24) {
                            ForEach(icons, id: \.self) { icon in
                                Text(icon)
                                    .font(.system(size: iconSize))
                                    .padding(isPad ? 18 : 12)
                                    .background(
                                        selectedIcon == icon ?
                                            Color.white.opacity(0.5) :
                                            Color.clear
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .onTapGesture { selectedIcon = icon }
                                    .scaleEffect(selectedIcon == icon ? 1.25 : 1.0)
                                    .animation(.spring(response: 0.45, dampingFraction: 0.65), value: selectedIcon)
                            }
                        }
                        .padding(.vertical, isPad ? 20 : 12)
                        
                        // Task input – taller, bigger text
                        HStack(spacing: 16) {
                            TextField("New task", text: $taskText)
                                .font(.custom("Cochin", size: taskFont))
                            
                            Button {
                                let trimmed = taskText.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !trimmed.isEmpty else { return }
                                tasks.append(TaskItem(title: trimmed))
                                taskText = ""
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: plusSize, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: plusFrame, height: plusFrame)
                                    .background(Color.brown)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                        }
                        .padding(fieldPadding * 1.4)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 36))
                        .overlay(
                            RoundedRectangle(cornerRadius: 36)
                                .stroke(Color.brown.opacity(0.25), lineWidth: 1)
                        )
                        
                        // Tasks or placeholder
                        if tasks.isEmpty {
                            Text("Add your first task above ☝️")
                                .font(.custom("Cochin", size: isPad ? 24 : 20))
                                .foregroundColor(.gray.opacity(0.85))
                                .italic()
                                .padding(.vertical, isPad ? 40 : 24)
                        } else {
                            VStack(spacing: isPad ? 20 : 14) {
                                ForEach(tasks.indices, id: \.self) { index in
                                    TaskRow(task: $tasks[index]) {
                                        tasks.remove(at: index)
                                    }
                                }
                            }
                            .padding(.top, 12)
                        }
                        
                        // Save button – much larger & more prominent
                        Button {
                            saveQuest()
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        } label: {
                            Text("Save Quest")
                                .font(.custom("Cochin", size: isPad ? 30 : 24))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: isPad ? 600 : 380)
                                .frame(height: buttonHeight)
                                .background(
                                    questName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                                        Color.brown.opacity(0.55) :
                                        Color.brown
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                                .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
                                .padding(.bottom,350)
                        }
                        .disabled(questName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .scaleEffect(baseScale * 1.12)
                        
                        Spacer(minLength: isPad ? 260 : 100)
                    }
                    .padding(.horizontal, sidePadding)
                    .scaleEffect(baseScale, anchor: .top)
                }
            }
        }
    }
    
    private func saveQuest() {
        let trimmedName = questName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let quest = Quest(title: trimmedName, icon: selectedIcon)
        quest.tasks.append(contentsOf: tasks)
        
        context.insert(quest)
        do {
            try context.save()
            print("✅ Quest saved: \(trimmedName)")
            dismiss()
        } catch {
            print("❌ Save failed: \(error)")
        }
    }
}

// TaskRow – increased font/icon sizes too
struct TaskRow: View {
    @Binding var task: TaskItem
    var onDelete: () -> Void
    
    @State private var showEditAlert = false
    @State private var editedTitle = ""
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                task.isDone.toggle()
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 32))
                    .foregroundColor(task.isDone ? .green : .brown)
            }
            
            Text(task.title)
                .strikethrough(task.isDone)
                .foregroundColor(task.isDone ? .gray : .primary)
                .font(.custom("Cochin", size: 26))
                .lineLimit(3)
            
            Spacer()
            
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
                    .font(.system(size: 26))
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.brown.opacity(0.2), lineWidth: 1)
        )
        .alert("Edit Task", isPresented: $showEditAlert) {
            TextField("Task name", text: $editedTitle)
            Button("Save") {
                let trimmed = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    task.title = trimmed
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
