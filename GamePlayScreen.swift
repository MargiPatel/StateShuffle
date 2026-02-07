//
//  GamePlayScreen.swift
//  ScrambledStates
//
// Created by Margi Patel on 1/26/26.
//
//  Main gameplay screen
//

import SwiftUI

/// Main gameplay screen where the game is played
struct GamePlayScreen: View {
    
    // MARK: - Properties
    
    /// Reference to main game view model
    @ObservedObject var viewModel: GameViewModel
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("scrambledStates_gamePlay_background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .ignoresSafeArea()
                
                // Gradient overlay
        //        LinearGradient(
        //            colors: [.blue.opacity(0.3), .purple.opacity(0.3), .pink.opacity(0.2)],
        //            startPoint: .topLeading,
        //            endPoint: .bottomTrailing
        //        )
        //        .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with score and controls
                    HStack {
                        // Left side - Timer for competitive OR Map button for Go the Distance
                        if viewModel.gameMode == .competitive {
                            HStack(spacing: 6) {
                                Image(systemName: "timer")
                                    .font(.system(size: 22))
                                    .foregroundColor(viewModel.timer < 10 ? .red : .white)
                                
                                Text("\(viewModel.timer)s")
                                    .font(.custom("Baloo2-Bold", size: 26))
                                    .foregroundColor(viewModel.timer < 10 ? .red : .white)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 8)
                            )
                            .frame(minWidth: 80)
                        } else if viewModel.gameMode == .goTheDistance || viewModel.gameMode == .solitaire {
                            Button(action: {
                                AudioManager.shared.playTapSound()
                                viewModel.showingMap = true
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "map.fill")
                                        .font(.system(size: 20))
                                    Text("Map")
                                        .font(.custom("Baloo2-Bold", size: 18))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(
                                    ZStack {
                                        LinearGradient(
                                            colors: [
                                                Color(red: 1.0, green: 0.3, blue: 0.4),
                                                Color(red: 1.0, green: 0.5, blue: 0.6)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                        
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.3),
                                                Color.white.opacity(0.0)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                        .blendMode(.overlay)
                                    }
                                )
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.6), lineWidth: 2)
                                )
                                .shadow(color: Color.red.opacity(0.4), radius: 8)
                            }
                            .frame(minWidth: 80)
                        } else {
                            Spacer()
                                .frame(width: 80)
                        }
                        
                        Spacer()
                        
                        // Score in center - Enhanced
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.yellow)
                                .shadow(color: .yellow.opacity(0.5), radius: 4)
                            
                            Text("\(viewModel.score)")
                                .font(.custom("Baloo2-Bold", size: 32))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.0, green: 0.9, blue: 0.3),
                                            Color(red: 1.0, green: 0.6, blue: 0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .black.opacity(0.5), radius: 3)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    Capsule()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.yellow.opacity(0.7),
                                                    Color.orange.opacity(0.5)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2
                                        )
                                )
                                .shadow(color: .yellow.opacity(0.3), radius: 10)
                        )
                        
                        Spacer()
                        
                        // X button on right - Enhanced
                        Button(action: {
                            AudioManager.shared.playTapSound()
                            viewModel.endGame()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.white)
                                .background(
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.9, green: 0.2, blue: 0.3),
                                                    Color(red: 0.8, green: 0.1, blue: 0.2)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 44, height: 44)
                                        .shadow(color: .red.opacity(0.4), radius: 8)
                                )
                        }
                        .frame(minWidth: 80)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    
                    // Challenge area - Enhanced
                    if let challenge = viewModel.currentChallenge {
                        VStack(spacing: 10) {
                            Text("Find:")
                                .font(.custom("Baloo2-SemiBold", size: 18))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(challenge.description)
                                .font(.custom("Baloo2-Bold", size: 24))
                                .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.4))  // Dark purple
                                .shadow(color: .white.opacity(0.8), radius: 1)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(Color.white.opacity(0.95))
                                        
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 0.7, green: 0.5, blue: 0.9).opacity(0.6),
                                                        Color(red: 0.5, green: 0.4, blue: 0.8).opacity(0.4)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 2
                                            )
                                    }
                                    .shadow(color: .black.opacity(0.15), radius: 8)
                                )
                            
                            // Hint button for Educational Mode - placed right below question
                            if viewModel.gameMode == .solitaire {
                                Button(action: {
                                    AudioManager.shared.playTapSound()
                                    viewModel.showHint()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "lightbulb.fill")
                                            .font(.system(size: 20))
                                        Text("Need a Hint?")
                                            .font(.custom("Baloo2-SemiBold", size: 18))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.orange, Color.yellow],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .shadow(color: .orange.opacity(0.5), radius: 10)
                                    )
                                }
                                .opacity(viewModel.hintAvailable ? 1.0 : 0.5)
                                .disabled(!viewModel.hintAvailable)
                                .scaleEffect(viewModel.hintAvailable ? 1.0 : 0.95)
                                .animation(.easeInOut(duration: 0.2), value: viewModel.hintAvailable)
                            }
                            
                            // Show progress for multi-answer challenges
                            if case .allEastOf = challenge {
                                let totalCorrect = viewModel.playerHand.filter {
                                    challenge.matchesDistanceChallenge($0, allCards: viewModel.playerHand)
                                }.count
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    
                                    Text("\(viewModel.selectedCorrectCards.count) of \(totalCorrect) found")
                                        .font(.custom("Baloo2-SemiBold", size: 16))
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.2))
                                )
                            }
                        }
                        .padding()
                        .onTapGesture {
                            // Re-read the current question aloud on demand
                            AudioManager.shared.stopSpeaking()   // reset dedup so same text fires again
                            AudioManager.shared.speakQuestion(challenge.description)
                        }
                    }
                    
                    Spacer()
                    
                    // Player hand - state cards
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.playerHand) { state in
                                StateCardView(
                                    state: state,
                                    isSelected: viewModel.selectedCorrectCards.contains(state.id),
                                    action: {
                                        viewModel.slapCard(state)
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                    .frame(height: 200)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                }
                
                // Feedback Overlay - Clearly visible
                if viewModel.showingFeedback {
                    FeedbackOverlay(
                        feedback: viewModel.feedback,
                        isCorrect: viewModel.isCorrectAnswer,
                        geometry: geometry
                    )
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(999)
                }
                // Hint Overlay - Educational Mode only
                if viewModel.showingHint {
                    HintOverlay(
                        hintText: viewModel.hintText,
                        geometry: geometry
                    )
                    .zIndex(998)
                }
                
                // Badge Award Overlay - Shown when badge is earned
                if viewModel.showingBadgeAward, let badge = viewModel.earnedBadge {
                    BadgeAwardView(badge: badge, gameMode: viewModel.gameMode, geometry: geometry)
                        .transition(.opacity)
                        .zIndex(1000)
                }
            }
        }
        .sheet(isPresented: $viewModel.showingMap) {
            USMapView(viewModel: viewModel)
        }
    }
}

// MARK: - Hint Overlay Component

/// Displays helpful hints for Educational Mode
struct HintOverlay: View {
    let hintText: String
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            // Semi-transparent backdrop
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Lightbulb emoji
                Text("💡")
                    .font(.system(size: 80))
                
                // Hint title
                Text("Hint")
                    .font(.custom("Baloo2-Bold", size: 32))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.yellow, Color.orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                // Hint text
                Text(hintText)
                    .font(.custom("Baloo2-SemiBold", size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(6)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.4, green: 0.3, blue: 0.5),
                                Color(red: 0.4, green: 0.2, blue: 0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .yellow.opacity(0.5), radius: 20)
            )
            .opacity(0.7)
            .frame(maxWidth: min(geometry.size.width - 60, 450))
        }
    }
}


// MARK: - Feedback Overlay Component

/// Displays prominent feedback for correct/incorrect answers
struct FeedbackOverlay: View {
    let feedback: String
    let isCorrect: Bool
    let geometry: GeometryProxy
    
    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0
    @State private var rotation: Double = -15
    @State private var starScale: CGFloat = 0.5
    @State private var starRotation: Double = 0
    @State private var bounceOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Semi-transparent backdrop
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Animated emoji with stars for correct, heart for incorrect
                ZStack {
                    // Background stars/hearts animation
                    if isCorrect {
                        ForEach(0..<8) { index in
                            Text("⭐")
                                .font(.system(size: 30))
                                .offset(
                                    x: cos(Double(index) * .pi / 4) * 80,
                                    y: sin(Double(index) * .pi / 4) * 80
                                )
                                .scaleEffect(starScale)
                                .rotationEffect(.degrees(starRotation))
                                .opacity(opacity * 0.8)
                        }
                    } else {
                        ForEach(0..<6) { index in
                            Text("💙")
                                .font(.system(size: 25))
                                .offset(
                                    x: cos(Double(index) * .pi / 3) * 70,
                                    y: sin(Double(index) * .pi / 3) * 70
                                )
                                .scaleEffect(starScale)
                                .opacity(opacity * 0.6)
                        }
                    }
                    
                    // Large emoji indicator
                    Text(isCorrect ? "🎉" : "💪")
                        .font(.system(size: 100))
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(rotation))
                        .offset(y: bounceOffset)
                }
                
                // Cheerful message
                VStack(spacing: 8) {
                    Text(isCorrect ? "Awesome!" : "You've Got This!")
                        .font(.custom("Baloo2-Bold", size: min(geometry.size.width * 0.1, 40)))
                        .foregroundStyle(
                            LinearGradient(
                                colors: isCorrect ?
                                    [Color.yellow, Color.orange] :
                                    [Color.cyan, Color.blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .black.opacity(0.3), radius: 2)
                    
                    Text(feedback)
                        .font(.custom("Baloo2-SemiBold", size: min(geometry.size.width * 0.06, 24)))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    // Encouraging sub-message
                    if !isCorrect {
                        Text("Try again! You're learning! 🌟")
                            .font(.custom("Baloo2-Regular", size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .italic()
                    }
                }
                .opacity(opacity)
                
                // Decorative sparkles for correct
                if isCorrect {
                    HStack(spacing: 15) {
                        ForEach(0..<5) { index in
                            Text(["✨", "🌟", "⭐", "🌟", "✨"][index])
                                .font(.system(size: 20))
                                .scaleEffect(starScale)
                                .rotationEffect(.degrees(Double(index) * 10))
                        }
                    }
                    .opacity(opacity)
                }
            }
            .padding(40)
            .background(
                ZStack {
                    // Gradient background
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                colors: isCorrect ?
                                    [Color(red: 0.2, green: 0.8, blue: 0.4),
                                     Color(red: 0.1, green: 0.7, blue: 0.5)] :
                                    [Color(red: 0.3, green: 0.6, blue: 0.9),
                                     Color(red: 0.5, green: 0.4, blue: 0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .opacity(0.95)
                    
                    // Shimmer border
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.8), .white.opacity(0.3), .white.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                }
                .shadow(color: isCorrect ? .green.opacity(0.5) : .blue.opacity(0.5), radius: 30)
            )
            .scaleEffect(scale)
        }
        .onAppear {
            // Main popup animation
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 0.7
                opacity = 0.8
                rotation = 0
            }
            
            // Stars/hearts animation
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                starScale = 1.0
            }
            
            if isCorrect {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    starRotation = 360
                }
            }
            
            // Bounce animation
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.3)) {
                bounceOffset = -10
            }
        }
    }
}

// MARK: - State Card View Component

/// Displays a single state card with fun animations
struct StateCardView: View {
    let state: StateCard
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var scale: CGFloat = 0.8
    @State private var rotation: Double = 0
    @State private var shimmerOffset: CGFloat = -200
    @State private var bounceOffset: CGFloat = 0
    @State private var glowOpacity: Double = 0.3
    
    // Lighter gradient colors for better text contrast
    private var cardGradients: [[Color]] {
        [
            [Color(red: 1.0, green: 0.85, blue: 0.9), Color(red: 1.0, green: 0.92, blue: 0.95)],   // Soft Pink
            [Color(red: 0.85, green: 0.9, blue: 1.0), Color(red: 0.9, green: 0.94, blue: 1.0)],    // Soft Blue
            [Color(red: 1.0, green: 0.95, blue: 0.75), Color(red: 1.0, green: 0.97, blue: 0.85)],  // Soft Yellow
            [Color(red: 0.85, green: 0.95, blue: 0.85), Color(red: 0.9, green: 0.98, blue: 0.9)],  // Soft Green
            [Color(red: 0.92, green: 0.85, blue: 1.0), Color(red: 0.96, green: 0.92, blue: 1.0)],  // Soft Purple
            [Color(red: 1.0, green: 0.88, blue: 0.8), Color(red: 1.0, green: 0.94, blue: 0.9)]     // Soft Orange
        ]
    }
    
    // Select gradient based on state name (deterministic but varied)
    private var backgroundGradient: [Color] {
        let index = abs(state.name.hashValue) % cardGradients.count
        return cardGradients[index]
    }
    
    var body: some View {
        Button(action: {
            // Fun bounce animation
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                scale = 0.9
                rotation = Double.random(in: -8...8)
                bounceOffset = -5
            }
            
            // Play tap sound
            AudioManager.shared.playTapSound()
            
            // Bounce back
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    scale = 1.0
                    rotation = 0
                    bounceOffset = 0
                }
            }
            
            // Execute action after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                action()
            }
        }) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 8) {
                    // State emoji/shape
                    Text(state.shape)
                        .font(.system(size: 50))
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                        .shadow(color: .black.opacity(0.2), radius: 4)
                    
                    // State name
                    Text(state.name)
                        .font(.custom("Baloo2-Bold", size: 19))
                        .foregroundColor(Color(red: 0.15, green: 0.12, blue: 0.25))  // Dark navy/purple
                        .shadow(color: .white.opacity(0.9), radius: 1)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    
                    // Nickname
                    Text(state.nickname)
                        .font(.custom("Baloo2-Regular", size: 11))
                        .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.4))  // Medium purple-gray
                        .shadow(color: .white.opacity(0.6), radius: 1)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                }
                .frame(width: 120, height: 160)
                .padding(10)
                .background(
                    ZStack {
                        // Vibrant gradient background
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: isSelected
                                        ? [Color(red: 0.2, green: 0.8, blue: 0.4),
                                           Color(red: 0.3, green: 0.9, blue: 0.5)]
                                        : backgroundGradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        // Shimmer effect
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.0),
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset)
                            .mask(RoundedRectangle(cornerRadius: 20))
                        
                        // Glass reflection
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.0)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                        
                        // Border with glow
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: isSelected
                                        ? [Color.green, Color.green.opacity(0.6)]
                                        : [Color.white.opacity(0.7), Color.white.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected ? 3 : 2
                            )
                    }
                    .shadow(color: isSelected ? Color.green.opacity(0.4) : Color.black.opacity(0.15), radius: 12, x: 0, y: 4)
                )
                
                // Green checkmark overlay for selected cards
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)
                            .shadow(color: .black.opacity(0.2), radius: 4)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(x: 5, y: -5)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
        .offset(y: bounceOffset)
        .disabled(isSelected) // Prevent re-selecting
        .onAppear {
            // Entrance animation with delay
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double.random(in: 0...0.3))) {
                scale = 1.0
            }
            
            // Shimmer effect
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                shimmerOffset = 400
            }
            
            // Subtle continuous bounce
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                bounceOffset = -3
            }
            
            // Pulsing glow
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                glowOpacity = 0.6
            }
        }
    }
}

// MARK: - Preview

struct GamePlayScreen_Previews: PreviewProvider {
    static var previews: some View {
        GamePlayScreen(viewModel: GameViewModel())
    }
}
