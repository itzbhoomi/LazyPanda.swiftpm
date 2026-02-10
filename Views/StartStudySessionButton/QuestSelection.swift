//
// QuestSelectionView.swift
// LazyPanda
//
// Created by Bhoomi on 01/01/26.
//
import SwiftUI
import SwiftData

struct QuestSelectionView: View {
    @Query private var quests: [Quest]
    
    @State private var selectedQuest: Quest?
    @State private var minutes: Int = 30
    @State private var startTimer = false
    
    var body: some View {
        GeometryReader { geo in
            let isPad = geo.size.width > 600
            
            // Only scale up fonts/padding/button sizes – keep layout structure simple at first
            let titleSize: CGFloat     = isPad ? 38 : 28
            let iconSize: CGFloat      = isPad ? 32 : 24
            let textSize: CGFloat      = isPad ? 26 : 20
            let checkSize: CGFloat     = isPad ? 28 : 22
            let stepperSize: CGFloat   = isPad ? 24 : 20
            let buttonSize: CGFloat    = isPad ? 24 : 20
            let maxWidth: CGFloat      = isPad ? 720 : .infinity
            let listHeight: CGFloat    = isPad ? 580 : 420
            let hPadding: CGFloat      = isPad ? 80 : 24
            
            ZStack {
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: isPad ? 32 : 22) {
                    Spacer().frame(height: isPad ? 60 : 20)
                    
                    Text("Choose a Quest")
                        .font(.custom("Cochin", size: titleSize))
                        .fontWeight(.bold)
                    
                    // Debug line (remove later)
                    Text("Quests: \(quests.count)")
                        .font(.title3)
                        .foregroundColor(.orange)
                        .padding(.bottom, 8)
                    
                    List(quests) { quest in
                        Button {
                            selectedQuest = quest
                        } label: {
                            HStack(spacing: isPad ? 16 : 12) {
                                Text(quest.icon)
                                    .font(.system(size: iconSize))
                                
                                Text(quest.title)
                                    .font(.custom("Cochin", size: textSize))
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                if selectedQuest?.id == quest.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: checkSize))
                                }
                            }
                            .padding(.vertical, isPad ? 12 : 6)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: listHeight)
                    .frame(maxWidth: maxWidth)
                    .cornerRadius(24)
                    .listStyle(.plain)
                    
                    Stepper(
                        "Duration: \(minutes) min",
                        value: $minutes,
                        in: 5...180,
                        step: 5
                    )
                    .padding()
                    .frame(maxWidth: maxWidth)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(24)
                    .font(.custom("Cochin", size: stepperSize))
                    .fontWeight(.bold)
                    
                    Button {
                        startTimer = true
                    } label: {
                        Text("Start Quest Session")
                            .font(.custom("Cochin", size: buttonSize))
                            .fontWeight(.bold)
                            .frame(maxWidth: isPad ? 360 : 240)
                            .padding(.vertical, isPad ? 20 : 16)
                            .background(Color.brown)
                            .cornerRadius(30)
                            .shadow(radius: 10)
                            .foregroundColor(.white)
                    }
                    .disabled(selectedQuest == nil)
                    .opacity(selectedQuest == nil ? 0.5 : 1)
                    
                    Spacer(minLength: isPad ? 100 : 60)
                }
                .padding(.horizontal, hPadding)
            }
        }
        .navigationDestination(isPresented: $startTimer) {
            if let quest = selectedQuest {
                TimerView(
                    sessionTitle: quest.title,
                    totalMinutes: minutes,
                    tasks: Array(quest.tasks),
                    sessionType: .quest
                )
            }
        }
    }
}
