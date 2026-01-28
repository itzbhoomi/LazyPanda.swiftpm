//
//  RewardsView.swift
//  LazyPanda
//

import SwiftUI
import SwiftData

struct RewardsView: View {

    // MARK: - SwiftData
    @Query(
        sort: \CoinTransaction.date,
        order: .reverse
    )
    private var transactions: [CoinTransaction]

    // MARK: - Colors
    let bambooGreen = Color(red: 0.38, green: 0.67, blue: 0.45)
    let softGreen   = Color(red: 0.75, green: 0.88, blue: 0.78)

    // MARK: - Animations
    @State private var glowPulse = false
    @State private var pandaFloat = false
    @State private var appear = false

    // 🔥 Fireflies everywhere
    let fireflies: [Firefly] = (0..<22).map { _ in
        Firefly(
            x: CGFloat.random(in: 0.05...0.95),
            y: CGFloat.random(in: 0.05...0.95),
            size: CGFloat.random(in: 5...9),
            speed: Double.random(in: 8...14),
            delay: Double.random(in: 0...6)
        )
    }

    // MARK: - Streak Logic
    private var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Only consider EARN transactions
        let earnDates = transactions
            .filter { $0.type == .earn }
            .map { calendar.startOfDay(for: $0.date) }

        guard !earnDates.isEmpty else { return 0 }

        let uniqueDays = Set(earnDates)
        var streak = 0
        var dayCursor = today

        while uniqueDays.contains(dayCursor) {
            streak += 1
            dayCursor = calendar.date(byAdding: .day, value: -1, to: dayCursor)!
        }

        return streak
    }

    private var streakProgress: CGFloat {
        // Assuming max streak to visualize is 30 days
        min(CGFloat(currentStreak) / 30.0, 1.0)
    }

    var body: some View {
        ZStack {

            // 🌿 Background
            Image("bamboo_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // ✨ Fireflies layer
            GeometryReader { geo in
                ZStack {
                    ForEach(fireflies) { firefly in
                        FireflyView(firefly: firefly)
                            .position(
                                x: firefly.x * geo.size.width,
                                y: firefly.y * geo.size.height
                            )
                    }
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }

            VStack {
                Spacer().frame(height: 20)

                // 🏷️ Heading
                VStack(spacing: 0) {
                    Text("LazyPanda’s")
                        .font(.custom("Cochin", size: 25))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text("Wonderland")
                        .font(.custom("Cochin", size: 25))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: 190)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.black, Color.brown],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(40)
                .shadow(radius: 10)
                .offset(y:160)

                Spacer()

                ZStack {

                    // 🎋 Streak Bamboo
                    ZStack(alignment: .bottom) {

                        Image("bamboo_streak")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 470)

                        ZStack(alignment: .bottom) {

                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.brown.opacity(0.7))
                                .frame(width: 8, height: 220)

                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [softGreen, bambooGreen],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 8, height: 220 * streakProgress)
                                .shadow(color: softGreen.opacity(glowPulse ? 0.9 : 0.6), radius: 18)
                                .shadow(color: bambooGreen.opacity(glowPulse ? 0.7 : 0.4), radius: 26)
                        }
                        .padding(.bottom, 10)

                        // 🟢 Streak Days Button (Glowing)
                        VStack {
                            Button {
                                // action when tapped (optional)
                            } label: {
                                Text("\(currentStreak)")
                                    .foregroundColor(.black)
                                    .font(.custom("Cochin", size: 25))
                                    .fontWeight(.black)
                                    .frame(width: 50, height: 50)
                                    .background(
                                        RadialGradient(
                                            gradient: Gradient(colors: [Color.white.opacity(0.9), Color.pink.opacity(0.5)]),
                                            center: .center,
                                            startRadius: 5,
                                            endRadius: 23
                                        )
                                    )
                                    .clipShape(Circle())
                                    .shadow(color: Color.yellow.opacity(glowPulse ? 0.8 : 0.4), radius: 12)
                                    .shadow(color: Color.pink.opacity(glowPulse ? 0.5 : 0.3), radius: 20)
                            }
                        }
                        .offset(y: -220 * streakProgress)
                    }
                    .offset(x: -160, y: -50)

                    // 🎖 Buttons (GAME FEEL)
                    VStack(spacing: 0) {

                        NavigationLink {
                            BadgesView()
                        } label: {
                            Image("badges_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 135)
                        }
                        .buttonStyle(BouncyButtonStyle())

                        Button {} label: {
                            Image("themes_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 95)
                        }
                        .buttonStyle(BouncyButtonStyle())

                        Button {} label: {
                            Image("gaming_console")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 135)
                        }
                        .buttonStyle(BouncyButtonStyle(scale: 0.88))
                    }
                    .offset(x: 148, y: -120)

                    // 🐼 Panda (ambient float only)
                    Image("playful_panda")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 490)
                        .offset(y: pandaFloat ? 92 : 100)
                }
                .opacity(appear ? 1 : 0)

                Spacer()

                // ⬇️ Bottom Interaction Area
                HStack(spacing: 0) {

                    NavigationLink {
                        TreasureView()
                    } label: {
                        Image("treasure_box")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 105)
                    }
                    .buttonStyle(BouncyButtonStyle())

                    Spacer()

                    NavigationLink {
                        BambooVerseView()
                    } label: {
                        Image("bamboo_entrance")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190)
                            .padding(.vertical, 50)
                            .offset(y: 10)
                    }
                    .buttonStyle(BouncyButtonStyle(scale: 0.94))

                    Spacer()

                    Button {} label: {
                        Image("panda_avatar_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 85)
                    }
                    .buttonStyle(BouncyButtonStyle())

                    Spacer()
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)

                Spacer().frame(height: 30)
            }
        }
        .onAppear {
            appear = true

            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowPulse.toggle()
            }

            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                pandaFloat.toggle()
            }
        }
    }
}

// MARK: - 🎮 Bouncy Button Style
struct BouncyButtonStyle: ButtonStyle {

    var scale: CGFloat = 0.92

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .brightness(configuration.isPressed ? 0.08 : 0)
            .animation(
                .interactiveSpring(
                    response: 0.25,
                    dampingFraction: 0.55,
                    blendDuration: 0.1
                ),
                value: configuration.isPressed
            )
    }
}

// MARK: - Firefly Model
struct Firefly: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let speed: Double
    let delay: Double
}

// MARK: - Firefly View (FLOAT + FLICKER)
struct FireflyView: View {
    @State private var float = false
    @State private var flicker = false

    let firefly: Firefly

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color(red: 1.0, green: 1.0, blue: 0.75, opacity: 1),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: firefly.size * 3
                )
            )
            .frame(width: firefly.size, height: firefly.size)
            .blur(radius: 2)
            .opacity(flicker ? 0.9 : 0.35)
            .offset(
                x: float ? CGFloat.random(in: -40...40) : 0,
                y: float ? CGFloat.random(in: -120...120) : 0
            )
            .onAppear {
                withAnimation(
                    .easeInOut(duration: firefly.speed)
                        .repeatForever(autoreverses: true)
                        .delay(firefly.delay)
                ) {
                    float.toggle()
                }

                withAnimation(
                    .easeInOut(duration: Double.random(in: 1.2...2.5))
                        .repeatForever(autoreverses: true)
                        .delay(firefly.delay)
                ) {
                    flicker.toggle()
                }
            }
    }
}
