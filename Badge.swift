//
//  Badge.swift
//  ScrambledStates
//
//  Created by Margi Patel on 2/3/26.
//
//  Badge reward system for achieving streaks
//
//
//  Badge.swift
//  ScrambledStates
//
//  Badge reward system for achieving streaks
//

import Foundation
import SwiftUI

/// Badge tier levels
enum BadgeTier: String, Codable, CaseIterable {
    case none = "None"
    case bronze = "Bronze"
    case silver = "Silver"
    case gold = "Gold"
    case platinum = "Platinum"
    
    /// Icon for the badge tier
    var icon: String {
        switch self {
        case .none: return ""
        case .bronze: return "🥉"
        case .silver: return "🥈"
        case .gold: return "🥇"
        case .platinum: return "💎"
        }
    }
    
    /// Color for the badge tier
    var color: Color {
        switch self {
        case .none: return .gray
        case .bronze: return Color(red: 0.80, green: 0.50, blue: 0.20)
        case .silver: return Color(red: 0.75, green: 0.75, blue: 0.75)
        case .gold: return Color(red: 1.00, green: 0.84, blue: 0.00)
        case .platinum: return Color(red: 0.90, green: 0.89, blue: 1.00)
        }
    }
    
    /// Next tier in progression
    var nextTier: BadgeTier? {
        switch self {
        case .none: return .bronze
        case .bronze: return .silver
        case .silver: return .gold
        case .gold: return .platinum
        case .platinum: return nil
        }
    }
}

/// Tracks badges earned per game mode
struct ModeBadges: Codable {
    var educationalMode: BadgeTier = .none
    var speedChallenge: BadgeTier = .none
    var goTheDistance: BadgeTier = .none
    var matchCapitalNickname: BadgeTier = .none
    
    /// Get badge for a specific mode name
    func getBadge(for mode: String) -> BadgeTier {
        switch mode {
        case "Educational Mode": return educationalMode
        case "Speed Challenge": return speedChallenge
        case "Go the Distance": return goTheDistance
        case "Match a State": return matchCapitalNickname
        default: return .none
        }
    }
    
    /// Set badge for a specific mode name
    mutating func setBadge(for mode: String, tier: BadgeTier) {
        switch mode {
        case "Educational Mode": educationalMode = tier
        case "Speed Challenge": speedChallenge = tier
        case "Go the Distance": goTheDistance = tier
        case "Match a State": matchCapitalNickname = tier
        default: break
        }
    }
    
    /// Upgrade badge if the new tier is higher
    mutating func upgradeBadge(for mode: String, to newTier: BadgeTier) {
        let currentTier = getBadge(for: mode)
        let currentIndex = BadgeTier.allCases.firstIndex(of: currentTier) ?? 0
        let newIndex = BadgeTier.allCases.firstIndex(of: newTier) ?? 0
        
        if newIndex > currentIndex {
            setBadge(for: mode, tier: newTier)
        }
    }
}
