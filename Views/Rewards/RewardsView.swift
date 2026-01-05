//
//  RewardsView.swift
//  LazyPanda
//
//  Created by Bhoomi on 02/01/26.
//

import SwiftUI

struct RewardsView: View {

    // Mock streak progress (0.0 – 1.0)
    let streakProgress: CGFloat = 0.65

    // Theme colors
    let bambooGreen = Color(red: 0.38, green: 0.67, blue: 0.45)
    let softGreen = Color(red: 0.75, green: 0.88, blue: 0.78)

    var body: some View {
        ZStack {

            // Background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer().frame(height: 20)

                // Top Title Board
                Image("lazy_panda_board")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)

                Spacer()

                // Main Garden Area
                ZStack {

                    // Left: Streak Bamboo with Vertical Progress
                    ZStack(alignment: .bottom) {

                        // Bamboo image (UNCHANGED)
                        Image("bamboo_streak")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 470)

                        // Vertical Progress Overlay (glowing)
                        ZStack(alignment: .bottom) {

                            // Track
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.brown.opacity(0.9),
                                            Color.brown.opacity(0.6)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 8, height: 220)
                                .shadow(color: Color.black.opacity(0.25), radius: 4, y: 2)

                            // Filled Progress (glow)
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            softGreen.opacity(0.95),
                                            bambooGreen.opacity(0.85)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 8, height: 220 * streakProgress)
                                .shadow(color: softGreen.opacity(0.9), radius: 10)
                                .shadow(color: bambooGreen.opacity(0.6), radius: 18)
                        }
                        .padding(.bottom, 10)
                        .padding(.leading, 0)
                    }
                    .offset(x: -160, y: 30)


                    // Badges + Themes (above gaming console)
                    VStack(spacing: 16) {

                        Button {
                            // navigate to badges
                        } label: {
                            Image("badges_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 135)
                        }
                        .offset(y: 30)

                        Button {
                            // navigate to themes
                        } label: {
                            Image("themes_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 135)
                        }
                        
                        // Gaming Console Button
                        Button {
                            // navigate to games
                        } label: {
                            Image("gaming_console")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 115)
                                .rotationEffect(.degrees(-20))
                                .contentShape(Rectangle())
                                .accessibilityLabel("Open Games")
                        }

                    }
                    .offset(x: 140, y: -120)

                    

                    // Center Panda
                    Image("playful_panda")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 370)
                        .offset(y: 100)
                }

                // Bottom Interaction Area
                HStack(spacing: 0) {

                    // Treasure Box
                    Button {
                        // navigate to rewards
                    } label: {
                        Image("treasure_box")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 105)
                            .contentShape(Rectangle())
                    }

                    Spacer()

                    // Bamboo Entrance
                    Button {
                        // navigate to explore area
                    } label: {
                        Image("bamboo_entrance")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190)
                            .padding(.vertical, 50)
                            .offset(y: 18)
                            .contentShape(Rectangle())
                    }

                    Spacer()

                    // Panda Avatar Button
                    Button {
                        // navigate to avatar customization
                    } label: {
                        Image("panda_avatar_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 85)
                            .contentShape(Rectangle())
                    }

                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)

                Spacer().frame(height: 30)
            }
        }
    }
}
