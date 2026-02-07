///
//  LoginScreen.swift
//  ScrambledStates
//
// Created by Margi Patel on 1/25/26.
//
//  User login and profile selection screen
//


import SwiftUI

/// Screen for user authentication and profile selection
struct LoginScreen: View {
    
    // MARK: - Properties
    
    /// Reference to main game view model
    @ObservedObject var viewModel: GameViewModel
    
    // MARK: - State
    
    @State private var showNewPlayerPopup = false
    @State private var isMuted = false

    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Full-screen background image — fills every pixel including safe areas
                Image("splashScreen")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                
           //     LinearGradient(
           //         colors: [.blue.opacity(0.3), .white.opacity(0.3)],
           //         startPoint: .top,
           //         endPoint: .bottom
           //     )
                // Semi-transparent overlay so text stays readable
           //     Color.black.opacity(0.35)
            //        .edgesIgnoringSafeArea(.all)
                
                // Scrollable content
                ScrollView {
                    VStack(spacing: 10) {
                        // Header with logo
                        VStack(spacing: 15) {
                            Image("scrambledStates_profile_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
                                .padding(.top, -30)
                            
                            Text("Welcome")
                                .font(.custom("Baloo2-Bold", size: 44))
                                .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.2))
                              //  .shadow(color: .white.opacity(0.3), radius: 5)
                            
                            Text("Let's get you started")
                                .font(.custom("Baloo2-SemiBold", size: 20))
                                .foregroundColor(Color(red: 0.9, green: 0.4, blue: 0.4))
                        }
                        .padding(.top, -20)
                        
                        // Existing profiles section
                        if !viewModel.profileManager.profiles.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Select Player")
                                    .font(.custom("Baloo2-Bold", size: 28))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 2)
                                    .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                                    .overlay(
                                        Text("Select Player")
                                            .font(.custom("Baloo2-Bold", size: 28))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 1.0, green: 0.9, blue: 0.3),   // Bright Yellow
                                                        Color(red: 1.0, green: 0.6, blue: 0.2)    // Orange
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .blendMode(.overlay)
                                            .opacity(0.5)
                                    )
                                    .padding(.horizontal)
                                
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(viewModel.profileManager.profiles) { profile in
                                            ProfileCardView(
                                                profile: profile,
                                                viewModel: viewModel
                                            )
                                            .transition(.asymmetric(
                                                insertion: .scale.combined(with: .opacity),
                                                removal: .scale.combined(with: .opacity)
                                            ))
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        
                        // New Player button — pinned to the bottom via Spacer above
                    //    Spacer()
                        
                        Button(action: {
                            AudioManager.shared.playTapSound()
                            showNewPlayerPopup = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.badge.plus.fill")
                                    .font(.system(size: 24))
                                Text("New Player")
                                    .font(.custom("Baloo2-Bold", size: 22))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                ZStack {
                                    // Vibrant gradient background
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.0, green: 0.6, blue: 0.2),   // Orange
                                            Color(red: 0.5, green: 0.8, blue: 0.2),   // Yellow
                                            Color(red: 0.3, green: 0.8, blue: 0.5)    // Green
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    
                                    // Glassmorphism overlay
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.0),
                                            Color.white.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .blendMode(.overlay)
                                }
                            )
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.8),
                                                Color.white.opacity(0.4)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: Color.orange.opacity(0.4), radius: 15, x: 0, y: 8)
                            .shadow(color: Color.white.opacity(0.3), radius: 8, x: 0, y: 0)
                        }
                        .padding(.top, 50)
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                    .frame(minHeight: geometry.size.height)
                }
                
                // Mute button in top-right corner
          /*      VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            AudioManager.shared.playTapSound()
                         //   AudioManager.shared.toggleMusicMute()
                            isMuted.toggle()
                        }) {
                            Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.blue.opacity(0.8),
                                                    Color.purple.opacity(0.8)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                )
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 50)
                    }
                    Spacer()
                }
               */
                // New Player popup overlay
                if showNewPlayerPopup {
                    NewPlayerPopup(
                        viewModel: viewModel,
                        isPresented: $showNewPlayerPopup
                    )
                    .transition(.opacity)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Profile Card Component

/// Displays a saved profile card for selection
struct ProfileCardView: View {
    
    // MARK: - Properties
    
    let profile: UserProfile
    @ObservedObject var viewModel: GameViewModel
    
    // MARK: - State
    
    @State private var showingDeleteConfirm = false
    @State private var showingReportCard = false
    @State private var isDeleting = false
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    @State private var showDeleteButton = false
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
                AudioManager.shared.playTapSound()
                viewModel.selectProfile(profile)
        }) {
            VStack(spacing: 12) {
                // Avatar
                Text(profile.avatar)
                    .font(.system(size: 50))
                    .shadow(color: .black.opacity(0.3), radius: 4)
         
                // Username with enhanced styling
                Text(profile.username)
                    .font(.custom("Baloo2-Bold", size: 18))
                    .foregroundColor(Color(red: 0.35, green: 0.2, blue: 0.6))  // Deep Purple
                    .shadow(color: .white.opacity(0.8), radius: 2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                // Score display
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.0))  // Gold
                    
                    Text("\(profile.totalScore)")
                        .font(.custom("Baloo2-Bold", size: 16))
                        .foregroundColor(Color(red: 0.5, green: 0.3, blue: 0.15))  // Orange
                    //    .shadow(color: .white.opacity(0.8), radius: 1)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
             //   .background(
             //       Capsule()
             //           .fill(Color.white.opacity(0.3))
             //   )
            }
            .frame(width: 140)
            .padding(.vertical, 18)
            .background(
                GeometryReader { geometry in
                    ZStack {
                        // Background image layer - fills entire card
                //        Image("scrambledStates_login_background")
                //            .resizable()
                //            .scaledToFill()
                //            .frame(width: geometry.size.width, height: geometry.size.height)
                //            .clipped()
                //            .clipShape(RoundedRectangle(cornerRadius: 15))
                //            .blur(radius: 8)  // Blur background for glass effect
                    
                        // Enhanced glassmorphism layers
                        ZStack {
                            // Darker frosted glass base for better contrast
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.ultraThinMaterial)
                                .opacity(0.95)
                            
                            // Darker colorful gradient overlay
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.8, green: 0.5, blue: 0.7).opacity(0.6),   // Deeper Pink
                                            Color(red: 0.6, green: 0.4, blue: 0.8).opacity(0.6),   // Deeper Purple
                                            Color(red: 0.5, green: 0.6, blue: 0.85).opacity(0.5)   // Deeper Blue
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .blendMode(.overlay)
                            
                            // Subtle inner glow
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.0)
                                        ],
                                        center: .topLeading,
                                        startRadius: 0,
                                        endRadius: 100
                                    )
                                )
                            
                            // Glass reflection highlight (top-left)
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.25),
                                            Color.clear
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .center
                                    )
                                )
                        }
                    
                        // Shimmer border
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.9),
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.7),
                                        Color.white.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    }
                }
            )
            .shadow(color: Color.white.opacity(0.3), radius: 8, x: 0, y: 0)  // Outer glow
            .shadow(color: Color.purple.opacity(0.2), radius: 15, x: 0, y: 8)  // Colored shadow
        }
        .onAppear {
            // Start background music when login screen appears
            AudioManager.shared.playBackgroundMusic()
        }
        .onDisappear {
            // Stop background music when leaving login screen
            AudioManager.shared.stopBackgroundMusic()
        }
    }
}

            // MARK: - ProfileSheetView

/// Wraps ProfileDetailScreen for sheet presentation from the login screen.
/// It temporarily sets currentProfile so ProfileDetailScreen can read it,
/// and restores nil on dismiss so login stays active.
struct ProfileSheetView: View {
    let profile: UserProfile
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ProfileDetailScreen(viewModel: viewModel)
            .onAppear {
                viewModel.currentProfile = profile
            }
            .onDisappear {
                // Only clear if we haven't navigated away (i.e. player was deleted)
                if viewModel.currentScreen != .login {
                    viewModel.currentProfile = nil
                }
            }
    }
}

// MARK: - New Player Popup

/// Kid-friendly modal popup for entering a new player name and picking an avatar
struct NewPlayerPopup: View {
    
    @ObservedObject var viewModel: GameViewModel
    @Binding var isPresented: Bool
    
    // MARK: - State
    
    @State private var name: String = ""
    @State private var selectedAvatar: String = "😊"
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
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }
            
            // Popup card — shifts up when keyboard appears
            VStack(spacing: 0) {
                // Title bar
                VStack(spacing: 6) {
                    Text("🌟")
                        .font(.system(size: 36))
                    
                    Text("New Player")
                        .font(.custom("Baloo2-Bold", size: 26))
                        .foregroundColor(.white)
                    
                    Text("Enter your name to join the game!")
                        .font(.custom("Baloo2-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.75))
                }
                .padding(.top, 28)
                .padding(.bottom, 20)
                
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
                            if !name.isEmpty {
                                AudioManager.shared.playTapSound()
                                createProfile()
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
                
                // Done / Cancel buttons
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
                    
                    // Done
                    Button(action: {
                        if !name.isEmpty {
                            AudioManager.shared.playTapSound()
                            createProfile()
                        }
                    }) {
                        Text("Done")
                            .font(.custom("Baloo2-Bold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        LinearGradient(
                                            colors: name.isEmpty
                                                ? [Color.green.opacity(0.3), Color.green.opacity(0.3)]
                                                : [.green, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .shadow(color: name.isEmpty ? .clear : .black.opacity(0.2), radius: 6)
                    }
                    .disabled(name.isEmpty)
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
            .offset(y: -keyboardHeight / 2)
            .animation(.easeOut(duration: 0.25), value: keyboardHeight)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
            // Small delay so the spring settles before stealing focus
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                nameFieldFocused = true
            }
            
            // Listen for keyboard show/hide
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main
            ) { notification in
                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    keyboardHeight = frame.height
                }
            }
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil,
                queue: .main
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
            scale = 0.85
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
        }
    }
    
    private func createProfile() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        viewModel.login(username: trimmed, avatar: selectedAvatar)
        isPresented = false
    }
}

// MARK: - Preview

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(viewModel: GameViewModel())
    }
}
