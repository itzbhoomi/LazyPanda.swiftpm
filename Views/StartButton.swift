//
//  StartButton.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI

struct StartButton: View {
    @State private var showOptions = false
    @State private var goToNewSession = false
    @State private var goToQuestSession = false

    var body: some View {
        VStack {
            Button {
                showOptions = true
            } label: {
                Text("Start Study Session")
                    .font(.custom("Cochin", size: 25))
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .frame(maxWidth: 300)
                    .padding()
                    .background(Gradient(colors: [Color.black, Color.brown]))
                    .cornerRadius(40)
                    .shadow(radius: 10)
            }

            NavigationLink("", destination: NewStudySessionView(), isActive: $goToNewSession)
            NavigationLink("", destination: QuestSelectionView(), isActive: $goToQuestSession)
        }
        .confirmationDialog("Choose Session Type", isPresented: $showOptions) {
            Button("Start New Study Session") {
                goToNewSession = true
            }

            Button("Use Existing Quest") {
                goToQuestSession = true
            }

            Button("Cancel", role: .cancel) {}
        }
    }
}
