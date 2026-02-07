//
//  SplashScreen.swift
//  ScrambledStates
//
// Created by Margi Patel on 2/3/26.
//
//  Initial splash screen shown on app launch
//

import SwiftUI

/// Splash screen displayed during app initialization
struct SplashScreen: View {
    
    // MARK: - Animation State
    
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var logoRotation: Double = 0
    @State private var logoOffsetY: CGFloat = -30
    @State private var pulseScale: CGFloat = 1.0
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("splashScreen")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                // Content positioned at top
                VStack(spacing: 20) {
                    // Top section with logo and title
                    VStack(spacing: 100) {
                        // App logo
                        Image("scrambledStates_profile_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .scaleEffect(logoScale * pulseScale)
                            .rotationEffect(.degrees(logoRotation))
                            .offset(y: logoOffsetY)
                            .opacity(logoOpacity)
                        
                        // App title and tagline
                        VStack(spacing: 8) {
                            Text("State Shuffle")
                                .font(.custom("Baloo2-Bold", size: 44))
                                .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.85, green: 0.65, blue: 0.1),  // Darker golden ✅
                                                Color(red: 0.9, green: 0.45, blue: 0.0),   // Darker orange ✅
                                                Color(red: 0.85, green: 0.2, blue: 0.3)   // Darker pink-red ✅
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                .opacity(0.95)
                            
                            Text("Shuffle. Solve. Shine! ✨")
                                .font(.custom("Baloo2-SemiBold", size: 22))
                                .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                             //   Color(red: 0.9, green: 0.8, blue: 2.5),   // Darker blue ✅
                                                Color(red: 0.7, green: 0.5, blue: 0.85),   // Darker purple ✅
                                                Color(red: 0.85, green: 0.6, blue: 0.75)  // Darker pink ✅
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                //.opacity(0.95)
                        }
                    }
                    .padding(.top, 200)
                    
                    Spacer()
                }
            }
            .onAppear {
                // Stage 1: Initial entrance - scale, fade, slide up (0-0.8s)
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                    logoScale = 1.5
                    logoOpacity = 1.0
                    logoOffsetY = 0
                }
                
                // Stage 2: Gentle rotation (0.5-1.2s)
                withAnimation(.easeInOut(duration: 0.7).delay(0.5)) {
                    logoRotation = 360
                }
                
                // Stage 3: Subtle pulse effect (1.0-2.0s)
                withAnimation(.easeInOut(duration: 0.5).delay(1.0)) {
                    pulseScale = 1.1
                }
                withAnimation(.easeInOut(duration: 0.5).delay(1.5)) {
                    pulseScale = 1.0
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Preview

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
