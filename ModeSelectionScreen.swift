//
//  ModeSelectionScreen.swift
//  ScrambledStates
//
// Created by Margi Patel on 1/26/26.
//
//  Game mode selection screen
//
/*
import SwiftUI

/// Screen for selecting game mode
struct ModeSelectionScreen: View {
    
    // MARK: - Properties
    
    /// Reference to main game view model
    @ObservedObject var viewModel: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background Image - fills entire screen
            Image("scrambledStates_gamePlay_background")
                .resizable()
                .ignoresSafeArea()
            
            // Background gradient overlay
            LinearGradient(
                colors: [.blue.opacity(0.1), .purple.opacity(0.1), .red.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 10) {
                // Top navigation bar
                HStack {
                    
                    Button(action: {
                        AudioManager.shared.playTapSound()
                        viewModel.logout()
                    }) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 44)
                            .opacity(0.7)
                    }
                    Spacer()
                    
                    if let profile = viewModel.currentProfile {
                        HStack(spacing: 8) {
                            // Avatar
                            Text(profile.avatar)
                                .font(.system(size: 28))
                                .shadow(color: .black.opacity(0.2), radius: 3)
                            
                            // Username
                            Text(profile.username)
                                .font(.custom("Baloo2-SemiBold", size: 22))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                    Spacer()
                    
                    // Report card button (right) - shows profile
                    Button(action: {
                        AudioManager.shared.playTapSound()
                        viewModel.showProfile()
                    }) {
                        Image("reportCard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                            .fill(Color.white.opacity(0.2))
                            .shadow(color: .black.opacity(0.15), radius: 5)
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
                
                // Title
                VStack(spacing: 15) {
                    Image("scrambledStates_profile_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
                        .padding(.top, -30)
                    
                    Text("Scrambled States")
                        .font(.custom("Baloo2-Bold", size: 42))
                        .foregroundColor(.blue)
                    
                    Text("Choose Your Game Mode")
                        .font(.custom("Baloo2-Regular", size: 18))
                        .foregroundColor(Color(red: 0.49, green: 0.56, blue: 0.94))
                }
                
                Spacer()
                
                // Game mode buttons
                VStack(spacing: 20) {
                    GameModeButton(
                        mode: .solitaire,
                        icon: "book.fill",
                        color: Color(red:0.29, green: 0.56, blue: 0.89)
                    ) {
                        viewModel.startGame(mode: .solitaire)
                    }
                    
                    GameModeButton(
                        mode: .competitive,
                        icon: "timer",
                        color: .orange
                    ) {
                        viewModel.startGame(mode: .competitive)
                    }
                    
                    GameModeButton(
                        mode: .goTheDistance,
                        icon: "location.fill",
                        color: .red
                    ) {
                        viewModel.startGame(mode: .goTheDistance)
                    }
                    GameModeButton(
                        mode: .matchCapitalNickname,
                        icon: "map.circle.fill",
                        color: .purple
                    ) {
                        viewModel.startGame(mode: .matchCapitalNickname)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
        .onAppear {
            // Restart background music when returning to mode selection
        //    AudioManager.shared.playBackgroundMusic()
        }
    }
}

// MARK: - Game Mode Button Component

/// Button component for game mode selection
struct GameModeButton: View {
    let mode: GameMode
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .frame(width: 60)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(mode.title)
                        .font(.custom("Baloo2-Bold", size: 20))
                        .foregroundColor(.white)
                    
                    Text(mode.description)
                        .font(.custom("Baloo2-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(20)
            .background(color)
            .cornerRadius(20)
            .shadow(radius: 8)
        }
    }
}

// MARK: - Preview

struct ModeSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModeSelectionScreen(viewModel: GameViewModel())
    }
}
*/


//
//  ModeSelectionScreen.swift
//  ScrambledStates
//
//  Game mode selection screen
//

import SwiftUI

/// Screen for selecting game mode
struct ModeSelectionScreen: View {
    
    // MARK: - Properties
    
    /// Reference to main game view model
    @ObservedObject var viewModel: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background Image - fills entire screen
            Image("scrambledStates_gamePlay_background")
                .resizable()
                .ignoresSafeArea()
            
            // Background gradient overlay
            LinearGradient(
                colors: [.blue.opacity(0.1), .purple.opacity(0.1), .red.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 10) {
                // Add spacer to move header down
                Spacer()
                    .frame(height: 0)
                
                // Top navigation bar - Enhanced colors
                HStack {
                    Button(action: {
                        AudioManager.shared.playTapSound()
                        viewModel.logout()
                    }) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
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
                                    .shadow(color: .orange.opacity(0.4), radius: 8)
                            )
                    }
                    Spacer()
                    
                    if let profile = viewModel.currentProfile {
                        HStack(spacing: 8) {
                            // Avatar
                            Text(profile.avatar)
                                .font(.system(size: 32))
                                .shadow(color: .black.opacity(0.3), radius: 4)
                            
                            // Username - Enhanced with gradient
                            Text(profile.username)
                                .font(.custom("Baloo2-Bold", size: 24))
                               // .foregroundColor(Color(red: 0.35, green: 0.2, blue: 0.6))  // Deep Purple
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.0, green: 0.5, blue: 0.3),
                                            Color(red: 1.0, green: 0.6, blue: 0.2)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            /*   .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.0, green: 0.9, blue: 0.3),
                                            Color(red: 1.0, green: 0.6, blue: 0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )*/
                            //    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                     /*   .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 8)
                        )*/
                    }
                    Spacer()
                    
                    // Report card button (right) - shows profile
                    Button(action: {
                        AudioManager.shared.playTapSound()
                        viewModel.showProfile()
                    }) {
                        Image("reportCard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                            .fill(Color.white.opacity(0.2))
                            .shadow(color: .black.opacity(0.15), radius: 5)
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
                
                // Title - Enhanced with colorful gradient
                VStack(spacing: 15) {
                    Image("scrambledStates_profile_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .shadow(color: .yellow.opacity(0.5), radius: 20, x: 0, y: 10)
                        .padding(.top, -30)
                    
                    Text("State Shuffle")
                        .font(.custom("Baloo2-Bold", size: 40))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.85, green: 0.35, blue: 0.1),  // Darker golden ✅
                                    Color(red: 0.9, green: 0.65, blue: 0.2),   // Darker orange ✅
                                    Color(red: 0.85, green: 0.2, blue: 0.3)   // Darker pink-red ✅
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                  //      .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 3)
                    
                    Text("Choose Your Game Mode")
                        .font(.custom("Baloo2-SemiBold", size: 18))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
                }
                
                Spacer()
                
                // Game mode buttons - Enhanced with vibrant colors
                VStack(spacing: 16) {
                    GameModeButton(
                        mode: .solitaire,
                        icon: "book.fill",
                        gradient: [
                            Color(red: 0.3, green: 0.7, blue: 0.95),   // Bright Blue
                            Color(red: 0.5, green: 0.5, blue: 0.95)    // Purple-Blue
                        ]
                    ) {
                        viewModel.startGame(mode: .solitaire)
                    }
                    
                    GameModeButton(
                        mode: .competitive,
                        icon: "timer",
                        gradient: [
                            Color(red: 1.0, green: 0.6, blue: 0.2),    // Orange
                            Color(red: 1.0, green: 0.8, blue: 0.3)     // Golden Yellow
                        ]
                    ) {
                        viewModel.startGame(mode: .competitive)
                    }
                    
                    GameModeButton(
                        mode: .goTheDistance,
                        icon: "location.fill",
                        gradient: [
                            Color(red: 1.0, green: 0.3, blue: 0.4),    // Coral Red
                            Color(red: 1.0, green: 0.5, blue: 0.6)     // Pink
                        ]
                    ) {
                        viewModel.startGame(mode: .goTheDistance)
                    }
                    
                    GameModeButton(
                        mode: .matchCapitalNickname,
                        icon: "map.circle.fill",
                        gradient: [
                            Color(red: 0.7, green: 0.3, blue: 0.9),    // Purple
                            Color(red: 0.9, green: 0.4, blue: 0.8)     // Pink-Purple
                        ]
                    ) {
                        viewModel.startGame(mode: .matchCapitalNickname)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
        .onAppear {
            // Restart background music when returning to mode selection
        //    AudioManager.shared.playBackgroundMusic()
        }
    }
}

// MARK: - Game Mode Button Component

/// Button component for game mode selection - Enhanced kid-friendly design
struct GameModeButton: View {
    let mode: GameMode
    let icon: String
    let gradient: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Icon with glow effect - smaller to make room for text
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 55, height: 55)
                    
                    Image(systemName: icon)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 3)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.title)
                        .font(.custom("Baloo2-Bold", size: 20))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text(mode.description)
                        .font(.custom("Baloo2-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.95))
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                }
                
                Spacer(minLength: 8)
                
                // Arrow with pulse effect
                Image(systemName: "chevron.right.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.2), radius: 2)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 18)
            .background(
                ZStack {
                    // Vibrant gradient background
                    LinearGradient(
                        colors: gradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    
                    // Glassmorphism overlay
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.25),
                            Color.white.opacity(0.0),
                            Color.white.opacity(0.15)
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
                                Color.white.opacity(0.7),
                                Color.white.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: gradient[0].opacity(0.4), radius: 15, x: 0, y: 8)
            .shadow(color: Color.white.opacity(0.3), radius: 8, x: 0, y: 0)
        }
    }
}

// MARK: - Preview

struct ModeSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModeSelectionScreen(viewModel: GameViewModel())
    }
}
