//
//  ProfileManager.swift
//  ScrambledStates
//
//  Created by Margi Patel on 1/24/26.
//  Service managing user profiles with persistent storage
//

import Foundation
import Combine

/// Manages user profiles including creation, updates, and persistence
class ProfileManager: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Array of all saved user profiles
    @Published var profiles: [UserProfile] = []
    
    // MARK: - Private Properties
    
    /// UserDefaults key for storing profiles
    private let profilesKey = "SavedProfiles"
    
    // MARK: - Initialization
    
    init() {
        loadProfiles()
    }
    
    // MARK: - Public Methods
    
    /// Loads profiles from persistent storage
    func loadProfiles() {
        if let data = UserDefaults.standard.data(forKey: profilesKey),
           let decoded = try? JSONDecoder().decode([UserProfile].self, from: data) {
            profiles = decoded
        }
    }
    
    /// Saves all profiles to persistent storage
    func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: profilesKey)
        }
    }
    
    /// Adds a new profile to the collection
    /// - Parameter profile: The profile to add
    func addProfile(_ profile: UserProfile) {
        profiles.append(profile)
        saveProfiles()
    }
    
    /// Updates an existing profile
    /// - Parameter profile: The profile with updated information
    func updateProfile(_ profile: UserProfile) {
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = profile
            saveProfiles()
        }
    }
    
    /// Deletes a profile from the collection
    /// - Parameter profile: The profile to delete
    func deleteProfile(_ profile: UserProfile) {
        profiles.removeAll { $0.id == profile.id }
        saveProfiles()
    }
}
