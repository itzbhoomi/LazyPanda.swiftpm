//
//  BadgesView.swift
//  LazyPanda
//
//  Created by Bhoomi on 07/01/26.
//

//
// BadgesView.swift
// LazyPanda
//
import SwiftUI
import SwiftData

struct Badge {
    let title: String
    let description: String
    let minDays: Int
    let systemImage: String
}

struct BadgesView: View {
    // MARK: - SwiftData
    @Query(sort: \CoinTransaction.date, order: .reverse)
    private var transactions: [CoinTransaction]
    
    // MARK: - Badge Definitions
    private let badges: [Badge] = [
        Badge(title: "Sprout Panda", description: "Your consistency has started to grow.", minDays: 3, systemImage: "leaf.fill"),
        Badge(title: "Bamboo Explorer", description: "A full week of steady focus and effort.", minDays: 7, systemImage: "leaf.circle.fill"),
        Badge(title: "Zen Guardian", description: "Calm, disciplined, and consistent for 15 days.", minDays: 15, systemImage: "yin.yang"),
        Badge(title: "Forest Sage", description: "A month of dedication. True mastery begins.", minDays: 30, systemImage: "tree.fill"),
        Badge(title: "Legendary Panda", description: "Elite consistency. Few reach this level.", minDays: 60, systemImage: "star.circle.fill")
    ]
    
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
        var dayCursor = today
        while uniqueDays.contains(dayCursor) {
            streak += 1
            dayCursor = calendar.date(byAdding: .day, value: -1, to: dayCursor)!
        }
        return streak
    }
    
    // MARK: - Badge Resolution
    private var currentBadge: Badge? {
        badges.last { currentStreak >= $0.minDays }
    }
    
    private var upcomingBadge: Badge? {
        badges.first { currentStreak < $0.minDays }
    }
    
    @State private var upcomingGlow = false
    
    var body: some View {
        GeometryReader { geo in
            let isPad = geo.size.width > 600
            let isLandscape = geo.size.width > geo.size.height
            
            // Responsive sizes
            let badgeDiameter: CGFloat   = isPad ? 240 : 160
            let iconSize: CGFloat        = isPad ? 100 : 64
            let headerSize: CGFloat      = isPad ? 42 : 28
            let titleSize: CGFloat       = isPad ? 32 : 24
            let descSize: CGFloat        = isPad ? 22 : 18
            let sidePadding: CGFloat     = isPad ? 60 : 24
            let verticalSpacing: CGFloat = isPad ? 36 : 24
            
            ZStack {
                // Background
                Image("bamboo_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: verticalSpacing) {
                        Spacer(minLength: isPad ? 100 : 40)
                        
                        // Header
                        Text("Badges")
                            .font(.custom("Cochin", size: headerSize))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding(.horizontal, isPad ? 68 : 32)
                            .padding(.vertical, isPad ? 20 : 12)
                            .background(
                                LinearGradient(colors: [.black, .brown], startPoint: .top, endPoint: .bottom)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                            .shadow(radius: isPad ? 16 : 10)
                        
                        Spacer(minLength: isPad ? 50 : 30)
                        
                        // Current Badge Display
                        if let badge = currentBadge {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.brown.opacity(0.85), Color.black],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: badgeDiameter, height: badgeDiameter)
                                        .shadow(color: .green.opacity(0.6), radius: 24)
                                    
                                    Image(systemName: badge.systemImage)
                                        .font(.system(size: iconSize, weight: .bold))
                                        .foregroundColor(.green)
                                }
                                
                                Text(badge.title)
                                    .font(.custom("Cochin", size: titleSize))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                Text(badge.description)
                                    .font(.custom("Cochin", size: descSize))
                                    .foregroundColor(.black.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, sidePadding)
                            }
                        } else {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(Color.black.opacity(0.6))
                                        .frame(width: badgeDiameter, height: badgeDiameter)
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: iconSize * 0.8))
                                        .foregroundColor(.gray)
                                }
                                
                                Text("No badge earned yet")
                                    .font(.custom("Cochin", size: titleSize))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                Text("Reach a 3-day streak to unlock your first badge.")
                                    .font(.custom("Cochin", size: descSize))
                                    .foregroundColor(.black.opacity(0.85))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, sidePadding)
                            }
                        }
                        
                        Spacer(minLength: isPad ? 40 : 20)
                        
                        // Upcoming Badge – more attractive + subtle animation
                        if let next = upcomingBadge {
                            VStack(spacing: 12) {
                                Text("Next Milestone")
                                    .font(.custom("Cochin", size: isPad ? 26 : 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                
                                Text(next.title)
                                    .font(.custom("Cochin", size: isPad ? 34 : 24))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("\(next.minDays - currentStreak) days remaining")
                                    .font(.custom("Cochin", size: isPad ? 22 : 16))
                                    .foregroundColor(.white.opacity(0.85))
                                
                                ProgressView(value: Double(currentStreak), total: Double(next.minDays))
                                    .progressViewStyle(.linear)
                                    .tint(.green)
                                    .frame(maxWidth: isPad ? 400 : 280)
                                    .scaleEffect(1.1)
                            }
                            .padding(.vertical, isPad ? 24 : 16)
                            .padding(.horizontal, isPad ? 40 : 24)
                            .frame(maxWidth: isPad ? 480 : 340)
                            .background(
                                RoundedRectangle(cornerRadius: 36)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.brown.opacity(0.4), Color.black.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 36)
                                            .stroke(Color.brown.opacity(upcomingGlow ? 0.7 : 0.3), lineWidth: 3)
                                    )
                            )
                            .shadow(color: .brown.opacity(0.5), radius: upcomingGlow ? 16 : 8)
                            .scaleEffect(upcomingGlow ? 1.04 : 1.0)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                    upcomingGlow.toggle()
                                }
                            }
                        } else if currentBadge != nil {
                            Text("🎉 All badges unlocked!")
                                .font(.custom("Cochin", size: isPad ? 28 : 22))
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .padding()
                        }
                        
                        Spacer(minLength: isPad ? 120 : 80)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, sidePadding)
                }
            }
        }
    }
}
