# StateShuffle
Kids education game 

State Shuffle
A fun, interactive iOS educational game that helps kids learn about US states through colorful gameplay and engaging challenges!
📱 Overview
State Shuffle is a vibrant, kid-friendly iOS app designed to make learning about US states exciting and memorable. Players explore state facts, geography, capitals, and nicknames through multiple game modes, earning badges and building their knowledge along the way.

✨ Features
🎮 Game Modes

Educational Mode 📚

Learn at your own pace
No time pressure
Hint system available
Perfect for beginners

Speed Challenge ⚡

Race against the clock
Fast-paced gameplay
Test your quick thinking
Beat your high score

Go the Distance 🗺️

Geographic challenge
Find the closest state
Learn state locations
Interactive map integration

Match a State 🏛️

Match capitals and nicknames
Test your memory
Fun fact challenges
Educational content

🏆 Features

Multiple Profiles - Create separate profiles for different players
Badge System - Earn Bronze, Silver, and Gold badges for achievements
Progress Tracking - Detailed statistics for each game mode
Sound Effects - Cheerful audio feedback and background music
Colorful UI - Bright, kid-friendly design with smooth animations
State Cards - Beautiful animated cards with emojis and gradients
Hint System - Context-aware hints in Educational Mode
Interactive Map - View US states on an interactive map


🎨 Design Philosophy
Kid-Friendly Interface

Vibrant Colors - Colorful gradients and pastel backgrounds
Fun Animations - Bouncing cards, shimmer effects, and smooth transitions
Large Text - Easy-to-read fonts (Baloo2 font family)
Clear Icons - Emoji-based visual cues
Glassmorphism - Modern frosted glass effects throughout

Accessibility

High Contrast - WCAG AAA compliant text visibility
Readable Fonts - Custom Baloo2 font optimized for kids
Visual Feedback - Clear success/error states
Audio Feedback - Sound effects for all interactions


🛠️ Technical Details
Requirements

iOS: 17.0 or later
Platform: iPhone, iPad
Xcode: 15.0+
Language: Swift 5.9+
Framework: SwiftUI

Key Technologies

SwiftUI - Modern declarative UI framework
MapKit - Interactive US map display
AVFoundation - Audio playback and synthesis
Core Location - Geographic calculations
Combine - Reactive programming


📂 Project Structure
ScrambledStates/
├── Models/
│   ├── GameMode.swift              # Game mode definitions
│   ├── StateCard.swift             # State data model
│   ├── UserProfile.swift           # Player profiles
│   └── Badge.swift           # Achievement badges
├── ViewModels/
│   ├── GameViewModel.swift         # Main game logic
├── Views/
│   ├── LoginScreen.swift           # Player selection
│   ├── ModeSelectionScreen.swift   # Game mode picker
│   ├── GamePlayScreen.swift        # Main gameplay
│   ├── ProfileDetailScreen.swift   # Stats & achievements
│   └── USMapView.swift             # Interactive map
│   └── BadgeAwardView.swift             # Interactive map
├── Managers/
│   └── AudioManager.swift          # Sound & music
│   └── ProfileManager.swift        # Profile management
├── Assets/
│   ├── Images/                     # Background images
│   └── background_music.mp4        # Background music file
└── README.md                       # This file

🎵 Audio Credits
Background Music
File: background_music.mp4 by Eric

Sound Effects
All sound effects are synthesized programmatically using AVFoundation - no external files required!


UI/UX enhancements and colorful theme design
Animation system implementation
Glassmorphism effects
Badge system design
Profile detail screens
Hint system implementation

Assets

State Data: Public domain US state information
Emojis: Apple emoji set (included with iOS)
Fonts: Baloo2 (SIL Open Font License)
Background Images: Custom artwork (included in project)
