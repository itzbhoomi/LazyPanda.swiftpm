//
// RewardsView.swift
// LazyPanda
//
//
// RewardsView.swift
// LazyPanda
//

import SwiftUI
import SwiftData

struct RewardsView: View {

    // MARK: - SwiftData
    @Query(sort: \CoinTransaction.date, order: .reverse)
    private var transactions: [CoinTransaction]

    // MARK: - Colors
    let bambooGreen = Color(red: 0.38, green: 0.67, blue: 0.45)
    let softGreen = Color(red: 0.75, green: 0.88, blue: 0.78)

    // MARK: - Animations
    @State private var glowPulse = false
    @State private var pandaFloat = false
    @State private var appear = false

    // Fireflies
    @State private var fireflies: [Firefly] = []

    // MARK: - Streak Logic
    private var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let earnDates = transactions
            .filter { $0.type == .earn }
            .map { calendar.startOfDay(for: $0.date) }

        guard !earnDates.isEmpty else { return 0 }

        let uniqueDays = Set(earnDates)
        var streak = 0
        var cursor = today

        while uniqueDays.contains(cursor) {
            streak += 1
            cursor = calendar.date(byAdding: .day, value: -1, to: cursor)!
        }
        return streak
    }

    private var streakProgress: CGFloat {
        min(CGFloat(currentStreak) / 30.0, 1.0)
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let isPad = width > 600
            
            ZStack {
                
                // 🌿 Background
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // ✨ Fireflies
                ZStack {
                    ForEach(fireflies) { firefly in
                        FireflyView(firefly: firefly)
                            .position(
                                x: firefly.x * width,
                                y: firefly.y * height
                            )
                    }
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
                
                VStack(spacing: isPad ? 40 : 20) {
                    
                    
                    // 🏷 Heading
                    Text("LazyPanda’s Wonderland")
                        .font(.custom("Cochin", size: isPad ? 50 : 25))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, isPad ? 16 : 10)
                        .background(
                            LinearGradient(
                                colors: [.black, .brown],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .shadow(radius: 12)
                        .offset(x : isPad ? -40 : -5)
                    
                    Spacer()
                    
                    // 🎮 Central Play Area
                    ZStack {
                        
                        // 🎋 Bamboo Streak (LEFT)
                        ZStack(alignment: .bottom) {
                            Image("bamboo_streak")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isPad ? 820 : 420)
                            
                            ZStack(alignment: .bottom) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.brown.opacity(0.7))
                                    .frame(width: 20, height: isPad ? 360 : 220)
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [softGreen, bambooGreen],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(
                                        width: 20,
                                        height: (isPad ? 360 : 220) * streakProgress
                                    )
                                    .shadow(
                                        color: softGreen.opacity(glowPulse ? 0.9 : 0.6),
                                        radius: 18
                                    )
                                    .shadow(
                                        color: bambooGreen.opacity(glowPulse ? 0.7 : 0.4),
                                        radius: 26
                                    )
                            }
                            .padding(.bottom, 30)
                            
                            Text("\(currentStreak)")
                                .font(.custom("Cochin", size: isPad ? 32 : 25))
                                .fontWeight(.black)
                                .foregroundColor(.black)
                                .frame(width: 60, height: 60)
                                .background(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            .white.opacity(0.9),
                                            .pink.opacity(0.5)
                                        ]),
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 28
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(
                                    color: .yellow.opacity(glowPulse ? 0.8 : 0.4),
                                    radius: 14
                                )
                                .shadow(
                                    color: .pink.opacity(glowPulse ? 0.5 : 0.3),
                                    radius: 22
                                )
                        }
                        .offset(
                            x: isPad ? -400 : -180,
                            y: isPad ? -130 : -30
                        )
                        
                        // 🎖 Right-side Buttons
                        VStack(spacing: isPad ? 36 : 22) {
                            
                            NavigationLink(destination: BadgesView()) {
                                Image("badges_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: isPad ? 210 : 135)
                            }
                            .buttonStyle(BouncyButtonStyle())
                            
                            Button {} label: {
                                Image("themes_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: isPad ? 170 : 95)
                            }
                            .buttonStyle(BouncyButtonStyle())
                            
                            NavigationLink(destination: DailyChallengesView()) {
                                Image("gaming_console")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: isPad ? 210 : 135)
                            }
                            .buttonStyle(BouncyButtonStyle(scale: 0.88))
                        }
                        .offset(
                            x: isPad ? 300 : 180,
                            y: isPad ? -60 : -80
                        )
                        
                        // 🐼 Panda (CENTER ANCHOR)
                        Image("playful_panda")
                            .resizable()
                            .scaledToFit()
                            .frame(width: isPad ? 730 : 460)
                            .offset(
                                y: pandaFloat
                                ? (isPad ? 90 : 85)
                                : (isPad ? 110 : 105)
                            )
                            .offset(
                                x: isPad ? -60 : 180,
                                y: isPad ? -100 : -80
                            )
                    }
                    .frame(
                        maxWidth: isPad ? 700 : 520,
                        maxHeight: isPad ? 520 : 420
                    )
                    .opacity(appear ? 1 : 0)
                    
                    
                    
                    // 🔘 Bottom Icons
                    HStack(spacing: isPad ? 80 : 50) {
                        
                        NavigationLink(destination: TreasureView()) {
                            Image("treasure_box")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isPad ? 180 : 105)
                        }
                        .buttonStyle(BouncyButtonStyle())
                        
                        NavigationLink(destination: BambooVerseView()) {
                            Image("bamboo_entrance")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isPad ? 290 : 190)
                        }
                        .buttonStyle(BouncyButtonStyle(scale: 0.94))
                        
                        Button {} label: {
                            Image("panda_avatar_button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: isPad ? 160 : 85)
                        }
                        .buttonStyle(BouncyButtonStyle())
                    }
                    .padding(.horizontal, isPad ? 60 : 30)
                    .padding(.bottom, isPad ? 400 : 50)
                    .offset(x : isPad ? -30 : 0, y: isPad ? -80:0)
                }
            }
        }
        .onAppear {
            if fireflies.isEmpty {
                let count = UIDevice.current.userInterfaceIdiom == .pad ? 22 : 14
                fireflies = (0..<count).map { _ in
                    Firefly(
                        x: CGFloat.random(in: 0.05...0.95),
                        y: CGFloat.random(in: 0.05...0.95),
                        size: CGFloat.random(in: 5...9),
                        speed: Double.random(in: 8...14),
                        delay: Double.random(in: 0...6)
                    )
                }
            }
            
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

// MARK: - Bouncy Button Style
struct BouncyButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.92
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .brightness(configuration.isPressed ? 0.08 : 0)
            .animation(
                .interactiveSpring(response: 0.25, dampingFraction: 0.55, blendDuration: 0.1),
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

// MARK: - Firefly View
struct FireflyView: View {
    @State private var float = false
    @State private var flicker = false
    let firefly: Firefly
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color(red: 1.0, green: 1.0, blue: 0.75, opacity: 1), .clear],
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
