//
//  AppScreen.swift
//  ScrambledStates
//
//  Created by Margi Patel on 1/20/26.

//  Navigation state enumeration
//

import Foundation

/// Represents the different screens/views in the application
enum AppScreen {
    case splash         // Initial loading screen
    case login          // User authentication/profile selection
    case modeSelection  // Game mode selection screen
    case game           // Active gameplay screen
    case profile        // User profile detail screen
}
