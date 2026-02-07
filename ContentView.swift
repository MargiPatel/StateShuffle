//
//  ContentView.swift
//  ScrambledStates
//
// Created by Margi Patel on 1/20/26.
//
//  Main navigation controller coordinating all screens
//

import SwiftUI

/// Root view managing navigation between all app screens
struct ContentView: View {
    
    // MARK: - Properties
    
    /// Main view model managing game state
    @StateObject private var viewModel = GameViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Navigate to appropriate screen based on current state
            switch viewModel.currentScreen {
            case .splash:
                SplashScreen()
                
            case .login:
                LoginScreen(viewModel: viewModel)
                
            case .modeSelection:
                ModeSelectionScreen(viewModel: viewModel)
                
            case .game:
                GamePlayScreen(viewModel: viewModel)
                
            case .profile:
                ProfileDetailScreen(viewModel: viewModel)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentScreen)
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
