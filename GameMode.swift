//
//  GameMode.swift
//  ScrambledStates
//
// Created by Margi Patel on 1/27/26.
//
//  Enumerations for game modes and challenge types
//

import Foundation

/// Defines the available game modes
enum GameMode {
    case solitaire              // Educational mode - learn at your own pace
    case competitive            // Speed challenge - race against the clock
    case goTheDistance          // Geographic challenge - find closest state
    case matchCapitalNickname   // Match capitals and nicknames
    
    /// Human-readable title for the game mode
    var title: String {
        switch self {
        case .solitaire: return "Educational Mode"
        case .competitive: return "Speed Challenge"
        case .goTheDistance: return "Go the Distance"
        case .matchCapitalNickname: return "Match a State"
        }
    }
    
    /// Brief description of the game mode
    var description: String {
        switch self {
        case .solitaire: return "Practice state facts at your own pace"
        case .competitive: return "Race against time to find matches"
        case .goTheDistance: return "Find the geographically closest state"
        case .matchCapitalNickname: return "Match state capitals and nicknames"
        }
    }
}

/// Represents different types of challenge prompts in the game
enum ChallengePrompt: Equatable {
    case bordersWith(String)        // Find state that borders another
    case syllableCount(Int)         // Find state with specific syllable count
    case startsWithLetter(String)   // Find state starting with letter
    case isCoastal                  // Find coastal state
    case inRegion(String)           // Find state in specific region
    case hasNickname(String)        // Find state with nickname containing word
    case endsWithLetter(String)     // Find state ending with letter
    case hasDoubleLetters           // Find state with two of same letters in a row
    case westOf(String)             // Find state west of another state
    case hasCapitalSyllables(Int)   // Find state with capital having specific syllables
    case capitalHasName             // Find state with person's name in capital
    case nicknameHasNature          // Find state with plant/animal in nickname
    case notCoastal                 // Find state that doesn't touch ocean
    
    // Capital/Nickname matching challenges
    case matchCapital(String)       // Find the state with this capital city
    case matchNickname(String)      // Find the state with this nickname
    
    // Distance-specific challenges
    case closestTo(StateCard)       // Find state geographically closest to given state
    case farthestFrom(StateCard)    // Find state geographically farthest from given state
    case northOf(String)            // Find state north of another state
    case southOf(String)            // Find state south of another state
    case eastOf(String)             // Find state east of another state
    case allEastOf(String)          // Find ALL states that are east of given state
    case mostNorthern               // Find the northernmost state
    case mostSouthern               // Find the southernmost state
    case mostEastern                // Find the easternmost state
    case mostWestern                // Find the westernmost state
    
    /// Human-readable description of the challenge
    var description: String {
        switch self {
        case .bordersWith(let state):
            return "Find a state that borders \(state)"
        case .syllableCount(let count):
            return "Find a state with \(count) syllable\(count > 1 ? "s" : "")"
        case .startsWithLetter(let letter):
            return "Find a state starting with '\(letter)'"
        case .isCoastal:
            return "Find a coastal state"
        case .inRegion(let region):
            return "Find a state in the \(region)"
        case .hasNickname(let word):
            return "Find '\(word)' state"
        case .endsWithLetter(let letter):
            return "Find a state ending with '\(letter)'"
        case .hasDoubleLetters:
            return "Find a state with two of the same letters in a row"
        case .westOf(let state):
            return "Find a state west of \(state)"
        case .hasCapitalSyllables(let count):
            return "Find a state with a \(count)-syllable capital"
        case .capitalHasName:
            return "Find a capital with a person's first name in it"
        case .nicknameHasNature:
            return "Find a state with a plant or animal in its nickname"
        case .notCoastal:
            return "Find a state that does not touch an ocean"
        case .matchCapital(let capital):
            return "Find the state whose capital is \(capital)"
        case .matchNickname(let nickname):
            return "Find '\(nickname)'"
            
        // Distance-specific challenges
        case .closestTo(let state):
            return "Find the state closest to \(state.name)"
        case .farthestFrom(let state):
            return "Find the state farthest from \(state.name)"
        case .northOf(let state):
            return "Find a state north of \(state)"
        case .southOf(let state):
            return "Find a state south of \(state)"
        case .eastOf(let state):
            return "Find a state east of \(state)"
        case .allEastOf(let state):
            return "Find all states that are east of \(state)"
        case .mostNorthern:
            return "Find the northernmost state"
        case .mostSouthern:
            return "Find the southernmost state"
        case .mostEastern:
            return "Find the easternmost state"
        case .mostWestern:
            return "Find the westernmost state"
        }
    }
    
    /// Checks if a given state matches the challenge criteria
    /// - Parameter state: The state to check
    /// - Returns: True if the state matches the challenge
    func matches(_ state: StateCard) -> Bool {
        switch self {
        case .bordersWith(let borderState):
            return state.neighbors.contains(borderState)
        case .syllableCount(let count):
            return state.syllables == count
        case .startsWithLetter(let letter):
            return state.name.lowercased().hasPrefix(letter.lowercased())
        case .isCoastal:
            return state.isCoastal
        case .inRegion(let region):
            return state.region == region
        case .hasNickname(let word):
            return state.nickname.lowercased().contains(word.lowercased())
        case .endsWithLetter(let letter):
            return state.name.lowercased().hasSuffix(letter.lowercased())
        case .hasDoubleLetters:
            return hasConsecutiveDoubleLetters(state.name)
        case .westOf(let otherState):
            return isWestOf(state, otherState: otherState)
        case .eastOf(let otherState):
            return isEastOf(state, otherState: otherState)
        case .northOf(let otherState):
            return isNorthOf(state, otherState: otherState)
        case .southOf(let otherState):
            return isSouthOf(state, otherState: otherState)
        case .hasCapitalSyllables(let count):
            return countSyllables(state.capital) == count
        case .capitalHasName:
            return capitalContainsPersonName(state.capital)
        case .nicknameHasNature:
            return nicknameContainsNature(state.nickname)
        case .notCoastal:
            return !state.isCoastal
        case .matchCapital(let capital):
            return state.capital.lowercased() == capital.lowercased()
        case .matchNickname(let nickname):
            return state.nickname.lowercased() == nickname.lowercased()
            
        // Distance challenges that require card comparison - handled in ViewModel
        case .closestTo, .farthestFrom, .allEastOf,
             .mostNorthern, .mostSouthern, .mostEastern, .mostWestern:
            return false // Will be validated in checkDistanceChallengeMatch()
        }
    }
    
    /// Checks if state matches distance challenge (requires all cards for comparison)
    /// - Parameters:
    ///   - state: The state to check
    ///   - allCards: All cards in the hand for comparison
    /// - Returns: True if the state matches the distance challenge
    func matchesDistanceChallenge(_ state: StateCard, allCards: [StateCard]) -> Bool {
        switch self {
        case .closestTo(let referenceState):
            return isClosest(state, to: referenceState, among: allCards)
        case .farthestFrom(let referenceState):
            return isFarthest(state, from: referenceState, among: allCards)
        case .northOf(let otherStateName):
            return isNorthOf(state, otherState: otherStateName)
        case .southOf(let otherStateName):
            return isSouthOf(state, otherState: otherStateName)
        case .eastOf(let otherStateName):
            return isEastOf(state, otherState: otherStateName)
        case .allEastOf(let otherStateName):
            return isEastOf(state, otherState: otherStateName)
        case .mostNorthern:
            return isMostNorthern(state, among: allCards)
        case .mostSouthern:
            return isMostSouthern(state, among: allCards)
        case .mostEastern:
            return isMostEastern(state, among: allCards)
        case .mostWestern:
            return isMostWestern(state, among: allCards)
        default:
            return matches(state) // Fall back to regular matching
        }
    }
    
    // MARK: - Helper Functions
    
    /// Checks if a string has consecutive double letters
    private func hasConsecutiveDoubleLetters(_ text: String) -> Bool {
        let lowercased = text.lowercased()
        for i in 0..<(lowercased.count - 1) {
            let index = lowercased.index(lowercased.startIndex, offsetBy: i)
            let nextIndex = lowercased.index(after: index)
            if lowercased[index] == lowercased[nextIndex] {
                return true
            }
        }
        return false
    }
    
    /// Checks if state is west of another state (simplified longitude check)
    private func isWestOf(_ state: StateCard, otherState: String) -> Bool {
        // List of approximate state longitudes (negative = west)
        let stateLongitudes: [String: Double] = [
            "Alabama": -86.8, "Alaska": -152.4, "Arizona": -111.1, "Arkansas": -92.4,
            "California": -119.7, "Colorado": -105.8, "Connecticut": -72.7, "Delaware": -75.5,
            "Florida": -81.7, "Georgia": -83.6, "Hawaii": -157.5, "Idaho": -114.7,
            "Illinois": -89.0, "Indiana": -86.3, "Iowa": -93.1, "Kansas": -98.5,
            "Kentucky": -85.3, "Louisiana": -91.8, "Maine": -69.4, "Maryland": -76.6,
            "Massachusetts": -71.5, "Michigan": -85.6, "Minnesota": -94.6, "Mississippi": -89.7,
            "Missouri": -92.6, "Montana": -110.0, "Nebraska": -99.9, "Nevada": -117.0,
            "New Hampshire": -71.6, "New Jersey": -74.5, "New Mexico": -106.0, "New York": -75.0,
            "North Carolina": -79.0, "North Dakota": -100.0, "Ohio": -82.9, "Oklahoma": -97.5,
            "Oregon": -120.5, "Pennsylvania": -77.2, "Rhode Island": -71.5, "South Carolina": -81.0,
            "South Dakota": -100.3, "Tennessee": -86.3, "Texas": -99.9, "Utah": -111.9,
            "Vermont": -72.6, "Virginia": -78.7, "Washington": -120.7, "West Virginia": -80.5,
            "Wisconsin": -89.6, "Wyoming": -107.5
        ]
        
        guard let stateLon = stateLongitudes[state.name],
              let otherLon = stateLongitudes[otherState] else {
            return false
        }
        
        return stateLon < otherLon // More negative = further west
    }
    
    /// Counts syllables in a word (simplified)
    private func countSyllables(_ word: String) -> Int {
        let vowels = "aeiouy"
        var count = 0
        var previousWasVowel = false
        
        for char in word.lowercased() {
            let isVowel = vowels.contains(char)
            if isVowel && !previousWasVowel {
                count += 1
            }
            previousWasVowel = isVowel
        }
        
        // Silent 'e' adjustment
        if word.lowercased().hasSuffix("e") && count > 1 {
            count -= 1
        }
        
        return max(count, 1)
    }
    
    /// Checks if capital contains a common person's first name
    private func capitalContainsPersonName(_ capital: String) -> Bool {
        let names = ["frank", "jefferson", "james", "charles", "jackson", "lincoln",
                     "madison", "john", "thomas", "george", "pierre", "austin", "santa"]
        let lowercased = capital.lowercased()
        return names.contains { lowercased.contains($0) }
    }
    
    /// Checks if nickname contains nature words (plants/animals)
    private func nicknameContainsNature(_ nickname: String) -> Bool {
        let natureWords = ["peach", "beaver", "bear", "mountain", "pine", "magnolia",
                          "sunshine", "golden", "granite", "garden", "palm", "cotton",
                          "lone star", "evergreen", "badger", "buckeye", "pelican",
                          "sunflower", "beehive", "hawkeye", "ocean", "prairie"]
        let lowercased = nickname.lowercased()
        return natureWords.contains { lowercased.contains($0) }
    }
    
    // MARK: - Distance Helper Functions
    
    /// Calculates distance between two states
    private func distance(from: StateCard, to: StateCard) -> Double {
        let lat1 = from.coordinates.latitude
        let lon1 = from.coordinates.longitude
        let lat2 = to.coordinates.latitude
        let lon2 = to.coordinates.longitude
        
        let dLat = (lat2 - lat1) * .pi / 180
        let dLon = (lon2 - lon1) * .pi / 180
        
        let a = sin(dLat/2) * sin(dLat/2) +
                cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) *
                sin(dLon/2) * sin(dLon/2)
        
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        return c
    }
    
    /// Checks if state is closest to reference among all cards
    private func isClosest(_ state: StateCard, to reference: StateCard, among cards: [StateCard]) -> Bool {
        // Exclude the reference state itself from comparison
        let validCards = cards.filter { $0.id != reference.id }
        guard !validCards.isEmpty else { return false }
        
        let distances = validCards.map { distance(from: reference, to: $0) }
        guard let minDist = distances.min() else { return false }
        return distance(from: reference, to: state) == minDist
    }
    
    /// Checks if state is farthest from reference among all cards
    private func isFarthest(_ state: StateCard, from reference: StateCard, among cards: [StateCard]) -> Bool {
        // Exclude the reference state itself from comparison
        let validCards = cards.filter { $0.id != reference.id }
        guard !validCards.isEmpty else { return false }
        
        let distances = validCards.map { distance(from: reference, to: $0) }
        guard let maxDist = distances.max() else { return false }
        return distance(from: reference, to: state) == maxDist
    }
    
    /// Checks if state is north of another (higher latitude)
    private func isNorthOf(_ state: StateCard, otherState: String) -> Bool {
        let stateLats = getStateLatitudes()
        guard let stateLat = stateLats[state.name],
              let otherLat = stateLats[otherState] else { return false }
        return stateLat > otherLat
    }
    
    /// Checks if state is south of another (lower latitude)
    private func isSouthOf(_ state: StateCard, otherState: String) -> Bool {
        let stateLats = getStateLatitudes()
        guard let stateLat = stateLats[state.name],
              let otherLat = stateLats[otherState] else { return false }
        return stateLat < otherLat
    }
    
    /// Checks if state is east of another (higher longitude)
    private func isEastOf(_ state: StateCard, otherState: String) -> Bool {
        let stateLons = getStateLongitudes()
        guard let stateLon = stateLons[state.name],
              let otherLon = stateLons[otherState] else { return false }
        return stateLon > otherLon
    }
    
    /// Checks if state is the northernmost
    private func isMostNorthern(_ state: StateCard, among cards: [StateCard]) -> Bool {
        let lats = cards.map { $0.coordinates.latitude }
        guard let maxLat = lats.max() else { return false }
        return state.coordinates.latitude == maxLat
    }
    
    /// Checks if state is the southernmost
    private func isMostSouthern(_ state: StateCard, among cards: [StateCard]) -> Bool {
        let lats = cards.map { $0.coordinates.latitude }
        guard let minLat = lats.min() else { return false }
        return state.coordinates.latitude == minLat
    }
    
    /// Checks if state is the easternmost
    private func isMostEastern(_ state: StateCard, among cards: [StateCard]) -> Bool {
        let lons = cards.map { $0.coordinates.longitude }
        guard let maxLon = lons.max() else { return false }
        return state.coordinates.longitude == maxLon
    }
    
    /// Checks if state is the westernmost
    private func isMostWestern(_ state: StateCard, among cards: [StateCard]) -> Bool {
        let lons = cards.map { $0.coordinates.longitude }
        guard let minLon = lons.min() else { return false }
        return state.coordinates.longitude == minLon
    }
    
    /// Returns state latitudes
    private func getStateLatitudes() -> [String: Double] {
        return [
            "Alabama": 32.8, "Alaska": 64.0, "Arizona": 34.0, "Arkansas": 34.8,
            "California": 36.8, "Colorado": 39.0, "Connecticut": 41.6, "Delaware": 39.0,
            "Florida": 28.0, "Georgia": 33.0, "Hawaii": 21.0, "Idaho": 44.0,
            "Illinois": 40.0, "Indiana": 40.0, "Iowa": 42.0, "Kansas": 38.5,
            "Kentucky": 37.5, "Louisiana": 31.0, "Maine": 45.5, "Maryland": 39.0,
            "Massachusetts": 42.4, "Michigan": 44.5, "Minnesota": 46.0, "Mississippi": 33.0,
            "Missouri": 38.5, "Montana": 47.0, "Nebraska": 41.5, "Nevada": 39.0,
            "New Hampshire": 44.0, "New Jersey": 40.0, "New Mexico": 34.5, "New York": 43.0,
            "North Carolina": 35.5, "North Dakota": 47.5, "Ohio": 40.5, "Oklahoma": 35.5,
            "Oregon": 44.0, "Pennsylvania": 41.0, "Rhode Island": 41.7, "South Carolina": 34.0,
            "South Dakota": 44.5, "Tennessee": 36.0, "Texas": 31.0, "Utah": 39.5,
            "Vermont": 44.0, "Virginia": 37.5, "Washington": 47.5, "West Virginia": 39.0,
            "Wisconsin": 44.5, "Wyoming": 43.0
        ]
    }
    
    /// Returns state longitudes
    private func getStateLongitudes() -> [String: Double] {
        return [
            "Alabama": -86.8, "Alaska": -152.0, "Arizona": -111.5, "Arkansas": -92.4,
            "California": -119.5, "Colorado": -105.5, "Connecticut": -72.7, "Delaware": -75.5,
            "Florida": -81.5, "Georgia": -83.5, "Hawaii": -157.5, "Idaho": -114.5,
            "Illinois": -89.0, "Indiana": -86.0, "Iowa": -93.5, "Kansas": -98.0,
            "Kentucky": -85.0, "Louisiana": -92.0, "Maine": -69.0, "Maryland": -77.0,
            "Massachusetts": -71.5, "Michigan": -85.0, "Minnesota": -94.0, "Mississippi": -89.5,
            "Missouri": -92.5, "Montana": -110.0, "Nebraska": -99.5, "Nevada": -117.0,
            "New Hampshire": -71.5, "New Jersey": -74.5, "New Mexico": -106.0, "New York": -75.0,
            "North Carolina": -79.0, "North Dakota": -100.0, "Ohio": -82.5, "Oklahoma": -97.5,
            "Oregon": -120.5, "Pennsylvania": -77.5, "Rhode Island": -71.5, "South Carolina": -81.0,
            "South Dakota": -100.0, "Tennessee": -86.0, "Texas": -99.0, "Utah": -111.5,
            "Vermont": -72.5, "Virginia": -78.5, "Washington": -120.5, "West Virginia": -80.5,
            "Wisconsin": -89.5, "Wyoming": -107.5
        ]
    }
}
