//
//  UserProfile.swift
//  ScrambledStates
//
// Created by Margi Patel on 1/31/26.

//  Model representing a user's profile and game statistics
//

import Foundation

/// Represents a user profile with game statistics and history
struct UserProfile: Codable, Identifiable {
    // MARK: - Properties
    
    /// Unique identifier for the profile
    var id = UUID()
    
    /// User's chosen display name
    var username: String
    
    /// User's selected avatar emoji
    var avatar: String
    
    /// Cumulative score across all games
    var totalScore: Int
    
    /// Total number of games played
    var gamesPlayed: Int
    
    /// Highest single game score achieved
    var highestScore: Int
    
    /// Timestamp of last game played
    var lastPlayed: Date
    
    /// History of recent games (limited to 50 entries)
    var gameHistory: [GameHistoryEntry]
    
    /// Badges earned in each game mode (default to empty badges for backward compatibility)
    var badges: ModeBadges = ModeBadges()
    
    // MARK: - Initialization
    
    /// Creates a new user profile with default statistics
    /// - Parameters:
    ///   - username: Display name for the user
    ///   - avatar: Emoji representing the user
    init(username: String, avatar: String) {
        self.username = username
        self.avatar = avatar
        self.totalScore = 0
        self.gamesPlayed = 0
        self.highestScore = 0
        self.lastPlayed = Date()
        self.gameHistory = []
        self.badges = ModeBadges()
    }
}

/// Represents a single game session entry in user history
struct GameHistoryEntry: Codable, Identifiable {
    // MARK: - Properties
    
    /// Unique identifier for the history entry
    var id = UUID()
    
    /// Name of the game mode played
    var mode: String
    
    /// Score achieved in this game
    var score: Int
    
    /// When the game was played
    var date: Date
    
    /// Longest streak achieved in this game
    var streak: Int
}
