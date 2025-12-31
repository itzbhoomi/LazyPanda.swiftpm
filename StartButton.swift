//
//  StartButton.swift
//  LazyPanda
//
//  Created by Bhoomi on 31/12/25.
//

import SwiftUI

struct StartButton: View {
    var body: some View {
        Button(action: {
            print("Start Study Session")
        }) {
            Text("Start Study Session")
                .fontWeight(.black)
                .font(Font.custom("Cochin", size: 25))
                .foregroundColor(.black)
                .frame(maxWidth: 300)
                .padding()
                .background(Color.white.opacity(0.6))
                .cornerRadius(40)
                .shadow(radius: 10)
        }
    }
}

