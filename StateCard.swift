//
//  StateCard.swift
//  ScrambledStates
//
// Created by Margi Patel on 1/29/26.
//
//  Model representing a US state card with all its properties
//

import Foundation
import CoreLocation

/// Represents a single US state with all relevant information for gameplay
struct StateCard: Identifiable, Equatable {
    // MARK: - Properties
    
    /// Unique identifier for the state
    let id = UUID()
    
    /// Official state name (e.g., "California")
    let name: String
    
    /// State nickname (e.g., "Golden State")
    let nickname: String
    
    /// State capital city
    let capital: String
    
    /// Number of syllables in the state name
    let syllables: Int
    
    /// Emoji representing state's geography or characteristics
    let shape: String
    
    /// Character/emoji representing the state's personality
    let character: String
    
    /// Array of neighboring state names
    let neighbors: [String]
    
    /// Whether the state borders an ocean
    let isCoastal: Bool
    
    /// Geographic region of the state
    let region: String
    
    /// Geographic coordinates (latitude/longitude) for map display
    let coordinates: CLLocationCoordinate2D
    
    // MARK: - Equatable Conformance
    
    /// States are equal if they have the same name
    static func == (lhs: StateCard, rhs: StateCard) -> Bool {
        lhs.name == rhs.name
    }
}
