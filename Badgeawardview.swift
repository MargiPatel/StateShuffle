//
//  BadgeAwardView.swift
//  ScrambledStates
//
// Created by Margi Patel on 2/3/26.
//
//  Animated badge award overlay
//

import SwiftUI

/// Displays animated badge award celebration
struct BadgeAwardView: View {
    let badge: BadgeTier
    let gameMode: GameMode
    let geometry: GeometryProxy
    
    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0
    @State private var rotation: Double = -180
    @State private var glowOpacity: Double = 0
    @State private var particleOffset: CGFloat = 0
    
    // Mode and tier specific messages
    private var badgeTitle: String {
        switch gameMode {
        case .solitaire: // Educational Mode
            switch badge {
            case .bronze: return "🎒 Great Start!"
            case .silver: return "🗺️ Rookie Ranger!"
            case .gold: return "🌟 Map Master!"
            case .platinum: return "🏆 Geography Champ!"
            case .none: return ""
            }
        case .competitive: // Speed Challenge
            switch badge {
            case .bronze: return "⚡ Lightning Fast!"
            case .silver: return "💡 Quick Thinker!"
            case .gold: return "⭐ Speed Star!"
            case .platinum: return "🚀 Turbo Brain!"
            case .none: return ""
            }
        case .goTheDistance:
            switch badge {
            case .bronze: return "🚗 Road Trip Hero!"
            case .silver: return "🧭 Trail Tracker!"
            case .gold: return "✈️ Travel Genius!"
            case .platinum: return "🗺️ Map Legend!"
            case .none: return ""
            }
        case .matchCapitalNickname:
            switch badge {
            case .bronze: return "🎖️ Capital Captain!"
            case .silver: return "🥷 Nickname Ninja!"
            case .gold: return "🌟 State Master!"
            case .platinum: return "👑 Capital King!"
            case .none: return ""
            }
        }
    }
    
    // Badge subtitle based on tier
    private var badgeSubtitle: String {
        switch badge {
        case .bronze: return "10 correct answers in a row!"
        case .silver: return "15 correct answers in a row!"
        case .gold: return "20 correct answers in a row!"
        case .platinum: return "25 correct answers in a row!"
        case .none: return ""
        }
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent backdrop
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Badge icon with glow effect
                ZStack {
                    // Glow circles
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(badge.color.opacity(0.3))
                            .frame(width: 150 + CGFloat(index * 20), height: 150 + CGFloat(index * 20))
                            .scaleEffect(glowOpacity)
                            .opacity(glowOpacity)
                    }
                    
                    // Badge icon
                    Text(badge.icon)
                        .font(.system(size: 100))
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(rotation))
                }
                
                // Badge tier text
                VStack(spacing: 10) {
                    Text("🎉 BADGE EARNED! 🎉")
                        .font(.custom("Baloo2-Bold", size: 24))
                        .foregroundColor(.yellow)
                        .opacity(opacity)
                    
                    Text("\(badge.rawValue) Badge")
                        .font(.custom("Baloo2-Bold", size: 32))
                        .foregroundColor(.white)
                        .opacity(opacity)
                    
                    Text(badgeTitle)
                        .font(.custom("Baloo2-Bold", size: 24))
                        .foregroundColor(badge.color)
                        .opacity(opacity)
                        .multilineTextAlignment(.center)
                    
                    Text(badgeSubtitle)
                        .font(.custom("Baloo2-Regular", size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(opacity)
                }
                
                // Decorative stars
                HStack(spacing: 20) {
                    ForEach(0..<5) { index in
                        Text("⭐")
                            .font(.system(size: 30))
                            .offset(y: particleOffset)
                            .opacity(opacity)
                            .animation(
                                .easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.1),
                                value: particleOffset
                            )
                    }
                }
                .opacity(opacity)
            }
            .padding(40)
        }
        .onAppear {
            // Play celebration sound
            AudioManager.shared.playLaunchSound()
            
            // Animate badge entrance
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                scale = 1.2
                rotation = 0
            }
            
            // Scale to normal size
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7).delay(0.6)) {
                scale = 1.0
            }
            
            // Fade in text
            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                opacity = 1.0
            }
            
            // Pulsing glow
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                glowOpacity = 0.8
            }
            
            // Floating stars
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(0.5)) {
                particleOffset = -10
            }
        }
    }
}
