//
//  ProfileDetailScreen.swift
//  ScrambledStates
//
// Created by Margi Patel on 1/28/26.
//
//  Full profile detail: stats, report-card content, edit name, delete player
//

import SwiftUI

// MARK: - ProfileDetailScreen

struct ProfileDetailScreen: View {

    @ObservedObject var viewModel: GameViewModel

    // MARK: - State

    @State private var showEditPopup   = false
    @State private var showDeleteAlert = false

    // MARK: - Computed

    private var profile: UserProfile {
        viewModel.currentProfile ?? UserProfile(username: "Player", avatar: "😊")
    }

    private static let modeNames = [
        "Educational Mode",
        "Speed Challenge",
        "Go the Distance",
        "Match a State"
    ]

    private var allStats: [ModeStats] {
        ProfileDetailScreen.modeNames.map { profile.stats(for: $0) }
    }

    private var maxModeTotal: Int {
        allStats.map { $0.totalScore }.max() ?? 1
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                // ── Background (matches ReportCardScreen) ──
                Image("scrambledStates_achievements")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                //    .edgesIgnoringSafeArea(.all)
                  .ignoresSafeArea()
                
                // ── Main layout ──
                VStack(spacing: 10) {
                    header
                    ScrollView {
                        VStack(spacing: 22) {
                            profileHero
                            overallSummary
                            
                            ForEach(allStats, id: \.modeName) { stats in
                                ModeCard(
                                    stats: stats,
                                    maxTotal: maxModeTotal,
                                    badge: profile.badges.getBadge(for: stats.modeName)
                                )
                            }
                            
                         //   recentGames
                            deleteButton
                        }
                        .padding(.bottom, 40)
                    }
                }
                
                // ── Edit-name popup overlay ──
                if showEditPopup {
                    EditNamePopup(
                        viewModel: viewModel,
                        isPresented: $showEditPopup
                    )
                    .transition(.opacity)
                }
            }
            // ── Delete confirmation ──
            .alert("Delete Player", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let p = viewModel.currentProfile {
                        viewModel.profileManager.deleteProfile(p)
                    }
                    viewModel.currentProfile = nil
                    viewModel.currentScreen  = .login
                }
            } message: {
                Text("This will permanently delete \(profile.username)'s profile and all game history. This cannot be undone.")
            }
         //   .ignoresSafeArea()
        }
    }
    // MARK: - Header

    private var header: some View {
        HStack {
            // Back button - Enhanced with gradient
            Button(action: { viewModel.currentScreen = .modeSelection }) {
                Image(systemName: "chevron.left.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 1.0, green: 0.6, blue: 0.2),
                                        Color(red: 1.0, green: 0.8, blue: 0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(color: .orange.opacity(0.4), radius: 8)
                    )
            }

            Spacer()

            // Edit button - Enhanced with gradient
            Button(action: { showEditPopup = true }) {
                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.3, green: 0.7, blue: 0.95),
                                        Color(red: 0.5, green: 0.5, blue: 0.95)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 44, height: 44)
                            .shadow(color: .blue.opacity(0.4), radius: 8)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 6)
    }

    // MARK: - Profile Hero (avatar + name)

    private var profileHero: some View {
        VStack(spacing: 8) {
            // Avatar with glow
            Text(profile.avatar)
                .font(.system(size: 80))
                .shadow(color: .yellow.opacity(0.5), radius: 20)
                .shadow(color: .black.opacity(0.3), radius: 6)

            // Username with gradient
            Text(profile.username)
                .font(.custom("Baloo2-Bold", size: 32))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.9, blue: 0.3),
                            Color(red: 1.0, green: 0.6, blue: 0.2)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: .black.opacity(0.5), radius: 3)

            // Profile label with gradient
            Text("Profile")
                .font(.custom("Baloo2-SemiBold", size: 16))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.7, green: 0.3, blue: 0.9),
                            Color(red: 0.9, green: 0.4, blue: 0.8)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 2)
        }
        .padding(.top, 10)
        .padding(.bottom, 4)
    }

    // MARK: - Overall Summary (reuses OverallStat)

    private var overallSummary: some View {
        VStack(spacing: 14) {
            Text("Overall Performance")
                .font(.custom("Baloo2-Bold", size: 20))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.9, blue: 0.3),
                            Color(red: 1.0, green: 0.6, blue: 0.2)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 2)

            HStack(spacing: 0) {
                OverallStat(icon: "⭐", value: "\(profile.totalScore)",   label: "Total Score")
                Color.white.opacity(0.25).frame(width: 1, height: 44)
                OverallStat(icon: "🎮", value: "\(profile.gamesPlayed)", label: "Games")
                Color.white.opacity(0.25).frame(width: 1, height: 44)
                OverallStat(icon: "🏆", value: "\(profile.highestScore)", label: "Best Score")
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(
            ZStack {
                // Glassmorphism base
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .opacity(0.9)
                
                // Gradient overlay
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.8, green: 0.5, blue: 0.7).opacity(0.5),
                                Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blendMode(.overlay)
                
                // Border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            }
            .shadow(color: Color.purple.opacity(0.3), radius: 15)
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Recent Games

    private var recentGames: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Games")
                .font(.custom("Baloo2-Bold", size: 17))
                .foregroundColor(.white)
                .padding(.horizontal, 20)

            if profile.gameHistory.isEmpty {
                Text("No games played yet — start playing to build your history!")
                    .font(.custom("Baloo2-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.45))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            } else {
                ForEach(profile.gameHistory.prefix(10)) { entry in
                    RecentGameRow(entry: entry)
                        .padding(.horizontal, 20)
                }
            }
        }
    }

    // MARK: - Delete Button

    private var deleteButton: some View {
        Button(action: { showDeleteAlert = true }) {
            HStack(spacing: 10) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 18))
                Text("Delete Player")
                    .font(.custom("Baloo2-Bold", size: 18))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    // Gradient background
                    LinearGradient(
                        colors: [
                            Color(red: 0.9, green: 0.2, blue: 0.3),
                            Color(red: 0.8, green: 0.1, blue: 0.2)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    
                    // Glassmorphism overlay
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color.white.opacity(0.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .blendMode(.overlay)
                }
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
            )
            .shadow(color: Color.red.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
}

// MARK: - EditNamePopup

/// Popup that lets the player rename themselves
struct EditNamePopup: View {

    @ObservedObject var viewModel: GameViewModel
    @Binding var isPresented: Bool

    // MARK: - State

    @State private var name: String = ""
    @State private var selectedAvatar: String = ""
    @FocusState private var nameFieldFocused: Bool
    @State private var scale: CGFloat = 0.85
    @State private var opacity: Double = 0
    @State private var keyboardHeight: CGFloat = 0
    
    // Available avatars for selection
    let avatars = ["😊", "😎", "🤓", "🥳", "🤠", "🧐", "😺", "🦊", "🐻", "🦁", "🐼", "🐨"]

    // MARK: - Body

    var body: some View {
        ZStack {
            // Backdrop
            Color.blue.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            // Card
            VStack(spacing: 0) {
                // Title
                VStack(spacing: 6) {
                    Text("✏️")
                        .font(.system(size: 36))
                    Text("Edit Profile")
                        .font(.custom("Baloo2-Bold", size: 26))
                        .foregroundColor(.white)
                    Text("Update your name and avatar")
                        .font(.custom("Baloo2-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.75))
                }
                .padding(.top, 28)
                .padding(.bottom, 24)

                // Name input
                VStack(spacing: 8) {
                    Text("What's your name?")
                        .font(.custom("Baloo2-SemiBold", size: 16))
                        .foregroundColor(.white.opacity(0.9))

                    TextField("Enter your name", text: $name)
                        .focused($nameFieldFocused)
                        .font(.custom("Baloo2-Regular", size: 20))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.white)
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.1), radius: 4)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                        .onSubmit {
                            if !name.trimmingCharacters(in: .whitespaces).isEmpty {
                                saveName()
                            }
                        }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                // Avatar selection
                VStack(spacing: 10) {
                    Text("Choose Your Avatar")
                        .font(.custom("Baloo2-SemiBold", size: 16))
                        .foregroundColor(.white.opacity(0.9))
                    
                    // Avatar grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                        ForEach(avatars, id: \.self) { avatar in
                            Button(action: {
                                AudioManager.shared.playTapSound()
                                selectedAvatar = avatar
                            }) {
                                Text(avatar)
                                    .font(.system(size: 32))
                                    .frame(width: 50, height: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedAvatar == avatar ? Color.blue.opacity(0.5) : Color.white.opacity(0.15))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedAvatar == avatar ? Color.white : Color.clear, lineWidth: 2)
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 20)

                // Cancel / Save buttons
                HStack(spacing: 12) {
                    // Cancel
                    Button(action: { dismiss() }) {
                        Text("Cancel")
                            .font(.custom("Baloo2-Bold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.gray.opacity(0.5))
                            )
                    }

                    // Save
                    Button(action: {
                        if !name.trimmingCharacters(in: .whitespaces).isEmpty {
                            saveName()
                        }
                    }) {
                        Text("Save")
                            .font(.custom("Baloo2-Bold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        LinearGradient(
                                            colors: name.trimmingCharacters(in: .whitespaces).isEmpty
                                                ? [Color.green.opacity(0.3), Color.green.opacity(0.3)]
                                                : [.green, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: name.trimmingCharacters(in: .whitespaces).isEmpty ? .clear : .black.opacity(0.2), radius: 6)
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
            }
            .background(
                          RoundedRectangle(cornerRadius: 24)
                              .fill(
                                  LinearGradient(
                                      colors: [Color(red: 0.22, green: 0.22, blue: 0.40),
                                               Color(red: 0.15, green: 0.18, blue: 0.35)],
                                      startPoint: .top,
                                      endPoint: .bottom
                                  )
                              )
                              .shadow(color: .black.opacity(0.4), radius: 20)
                      )
            .frame(maxWidth: 360)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(y: -keyboardHeight / 4)
            .animation(.easeOut(duration: 0.25), value: keyboardHeight)
        }
        .onAppear {
            // Pre-fill with current username and avatar
            name = viewModel.currentProfile?.username ?? ""
            selectedAvatar = viewModel.currentProfile?.avatar ?? "😊"

            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                scale   = 1.0
                opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                nameFieldFocused = true
            }

            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil, queue: .main
            ) { notification in
                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = frame.height
                }
            }
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil, queue: .main
            ) { _ in
                keyboardHeight = 0
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(
                self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(
                self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }

    // MARK: - Helpers

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            scale   = 0.85
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
        }
    }

    private func saveName() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        // Update both username and avatar
        viewModel.updateProfileInfo(username: trimmed, avatar: selectedAvatar)
        isPresented = false
    }
}

// MARK: - Per-Mode Stats

/// Aggregated stats for one game mode derived from a profile's history
struct ModeStats {
    let modeName: String
    let gamesPlayed: Int
    let totalScore: Int
    let highestScore: Int
    let averageScore: Int
    let bestStreak: Int

    var hasData: Bool { gamesPlayed > 0 }
}

extension UserProfile {
    func stats(for modeName: String) -> ModeStats {
        let entries = gameHistory.filter { $0.mode == modeName }
        let played  = entries.count
        let total   = entries.reduce(0) { $0 + $1.score }
        let highest = entries.map { $0.score }.max() ?? 0
        let avg     = played > 0 ? total / played : 0
        let streak  = entries.map { $0.streak }.max() ?? 0
        return ModeStats(
            modeName: modeName,
            gamesPlayed: played,
            totalScore: total,
            highestScore: highest,
            averageScore: avg,
            bestStreak: streak
        )
    }
}

// MARK: - ModeCard

struct ModeCard: View {
    let stats: ModeStats
    let maxTotal: Int
    let badge: BadgeTier

    private var gradientColors: [Color] {
        switch stats.modeName {
        case "Educational Mode":
            return [Color(red: 0.3, green: 0.7, blue: 0.95), Color(red: 0.5, green: 0.5, blue: 0.95)]
        case "Speed Challenge":
            return [Color(red: 1.0, green: 0.6, blue: 0.2), Color(red: 1.0, green: 0.8, blue: 0.3)]
        case "Go the Distance":
            return [Color(red: 1.0, green: 0.3, blue: 0.4), Color(red: 1.0, green: 0.5, blue: 0.6)]
        case "Match a State":
            return [Color(red: 0.7, green: 0.3, blue: 0.9), Color(red: 0.9, green: 0.4, blue: 0.8)]
        default:
            return [Color(red: 0.5, green: 0.5, blue: 0.95), Color(red: 0.7, green: 0.4, blue: 0.9)]
        }
    }
    
    private var accent: Color {
        gradientColors[0]
    }

    private var icon: String {
        switch stats.modeName {
        case "Educational Mode": return "📚"
        case "Speed Challenge":  return "⚡"
        case "Go the Distance":  return "🗺️"
        case "Match a State":    return "🏛️"
        default:                 return "🎮"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Title row
            HStack {
                Text(icon).font(.system(size: 24))
                    .shadow(color: .black.opacity(0.3), radius: 2)
                Text(stats.modeName)
                    .font(.custom("Baloo2-Bold", size: 18))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2)
                Spacer()
                
                // Badge display
                if stats.hasData && badge != .none && !badge.icon.isEmpty {
                    HStack(spacing: 4) {
                        Text(badge.icon)
                            .font(.system(size: 18))
                        Text(badge.rawValue)
                            .font(.custom("Baloo2-SemiBold", size: 12))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(badge.color.opacity(0.8))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                            .shadow(color: badge.color.opacity(0.5), radius: 6)
                    )
                }
                
                if stats.hasData {
                    Text("\(stats.gamesPlayed) played")
                        .font(.custom("Baloo2-SemiBold", size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.25))
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)

            if stats.hasData {
                progressBar
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)

                HStack(spacing: 0) {
                    StatBadge(icon: "⭐", value: "\(stats.totalScore)",   label: "Total",  accent: accent)
                    StatBadge(icon: "📈", value: "\(stats.averageScore)", label: "Avg",    accent: accent)
                    StatBadge(icon: "🏆", value: "\(stats.highestScore)", label: "Best",   accent: accent)
                    StatBadge(icon: "🔥", value: "\(stats.bestStreak)",   label: "Streak", accent: accent)
                }
                .padding(.bottom, 14)
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 18))
                    Text("No games played yet")
                        .font(.custom("Baloo2-Regular", size: 14))
                }
                .foregroundColor(.white.opacity(0.45))
                .padding(.bottom, 14)
            }
        }
        .background(
            ZStack {
                // Dark base layer for better text contrast
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.12, green: 0.15, blue: 0.22))
                    .opacity(0.95)
                
                // Subtle glassmorphism overlay
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .opacity(0.3)
                
                // Subtle gradient tint (much more subtle now)
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                gradientColors[0].opacity(0.15),
                                gradientColors[1].opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blendMode(.overlay)
                
                // Colored border instead of white for mode identification
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [
                                gradientColors[0].opacity(0.7),
                                gradientColors[1].opacity(0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            }
            .shadow(color: gradientColors[0].opacity(0.3), radius: 12)
        )
        .shadow(color: .black.opacity(0.25), radius: 8)
        .padding(.horizontal, 20)
    }

    private var progressBar: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Progress")
                    .font(.custom("Baloo2-SemiBold", size: 12))
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
                Text("\(stats.totalScore) pts")
                    .font(.custom("Baloo2-Bold", size: 12))
                    .foregroundColor(accent)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white.opacity(0.08))
                        .frame(height: 9)

                    let ratio: CGFloat = maxTotal > 0
                        ? CGFloat(stats.totalScore) / CGFloat(maxTotal)
                        : 0
                    RoundedRectangle(cornerRadius: 5)
                        .fill(
                            LinearGradient(
                                colors: [accent, accent.opacity(0.55)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(geo.size.width * ratio, 18), height: 9)
                }
            }
            .frame(height: 9)
        }
    }
}

// MARK: - RecentGameRow

struct RecentGameRow: View {
    let entry: GameHistoryEntry

    private var accent: Color {
        switch entry.mode {
        case "Educational Mode": return Color(red: 0.00, green: 0.69, blue: 0.61)
        case "Speed Challenge":  return Color(red: 0.91, green: 0.27, blue: 0.37)
        case "Go the Distance":  return Color(red: 1.0, green: 0.3, blue: 0.4)
        case "Match a State":    return Color(red: 0.7, green: 0.3, blue: 0.9)
        default:                 return Color(red: 0.31, green: 0.68, blue: 0.99)
        }
    }

    private var icon: String {
        switch entry.mode {
        case "Educational Mode": return "📚"
        case "Speed Challenge":  return "⚡"
        case "Go the Distance":  return "🗺️"
        case "Match a State":    return "🏛️"
        default:                 return "🎮"
        }
    }

    private static let dateFmt: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f
    }()

    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 18))
                .frame(width: 38, height: 38)
                .background(Circle().fill(accent.opacity(0.18)))

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.mode)
                    .font(.custom("Baloo2-SemiBold", size: 14))
                    .foregroundColor(.white)
                Text(RecentGameRow.dateFmt.string(from: entry.date))
                    .font(.custom("Baloo2-Regular", size: 11))
                    .foregroundColor(.white.opacity(0.4))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("⭐ \(entry.score)")
                    .font(.custom("Baloo2-Bold", size: 15))
                    .foregroundColor(.white)
                Text("🔥 \(entry.streak)")
                    .font(.custom("Baloo2-Regular", size: 11))
                    .foregroundColor(.white.opacity(0.45))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.09, green: 0.13, blue: 0.25))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(accent.opacity(0.18), lineWidth: 1)
                )
        )
    }
}

// MARK: - Small Reusable Components

struct OverallStat: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 3) {
            Text(icon).font(.system(size: 20))
            Text(value)
                .font(.custom("Baloo2-Bold", size: 20))
                .foregroundColor(.white)
            Text(label)
                .font(.custom("Baloo2-Regular", size: 10))
                .foregroundColor(.white.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
    }
}

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    let accent: Color

    var body: some View {
        VStack(spacing: 2) {
            Text(icon).font(.system(size: 15))
            Text(value)
                .font(.custom("Baloo2-Bold", size: 17))
                .foregroundColor(.white)
            Text(label)
                .font(.custom("Baloo2-Regular", size: 10))
                .foregroundColor(accent)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

struct ProfileDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailScreen(viewModel: GameViewModel())
    }
}
