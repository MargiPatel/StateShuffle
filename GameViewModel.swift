//
//  GameViewModel.swift
//  ScrambledStates
//
//  Created by Margi Patel on 1/27/26.

//  Main view model managing game state and logic
//

import Foundation
import Combine
import CoreLocation

/// Main view model coordinating all game logic and state
class GameViewModel: ObservableObject {
    
    // MARK: - Published Properties - Navigation
    
    /// Current screen being displayed
    @Published var currentScreen: AppScreen = .splash
    
    // MARK: - Published Properties - User & Profile
    
    /// Currently active user profile
    @Published var currentProfile: UserProfile?
    
    /// Profile manager for user data persistence
    @Published var profileManager = ProfileManager()
    
    // MARK: - Published Properties - Game State
    
    /// Cards in the player's hand
    @Published var playerHand: [StateCard] = []
    
    /// Current challenge prompt
    @Published var currentChallenge: ChallengePrompt?
    
    /// Card displayed in the center (for comparison)
    @Published var centerCard: StateCard?
    
    /// Current game score
    @Published var score: Int = 0
    
    /// Points earned in this session only (before adding to total)
    @Published var sessionScore: Int = 0
    
    /// Current streak counter
    @Published var streak: Int = 0
    
    /// Active game mode
    @Published var gameMode: GameMode = .solitaire
    
    /// Feedback message to display
    @Published var feedback: String = ""
    
    /// Whether to show feedback overlay
    @Published var showingFeedback: Bool = false
    
    /// Whether the last answer was correct (for feedback UI)
    @Published var isCorrectAnswer: Bool = false
    
    /// Cards that have been correctly selected (for multi-answer challenges)
    @Published var selectedCorrectCards: Set<UUID> = []
    
    /// Whether to show map view
    @Published var showingMap: Bool = false
    
    /// Whether game has started
    @Published var gameStarted: Bool = false
    
    /// Timer countdown (for competitive mode)
    @Published var timer: Int = 30
    
    /// Whether scramble animation is active
    @Published var isScrambling: Bool = false
    
    /// Whether player can scramble cards
    @Published var canScramble: Bool = true
    
    /// Badge earned in current session (if any)
    @Published var earnedBadge: BadgeTier? = nil
    
    /// Whether to show badge award animation
    @Published var showingBadgeAward: Bool = false
    
    /// Whether hint is available (Educational Mode only)
    @Published var hintAvailable: Bool = true
    
    /// Current hint text to display
    @Published var hintText: String = ""
    
    /// Whether to show hint overlay
    @Published var showingHint: Bool = false
    
    // MARK: - Public Properties
    
    /// All available states in the game
    let allStates: [StateCard]
    
    // MARK: - Private Properties
    
    /// Timer for competitive mode
    private var timerCancellable: Timer?
    
    // MARK: - Initialization
    
    init() {
        self.allStates = StateDataProvider.getAllStates()
        
        // Show login screen after splash delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.currentScreen = .login
        }
    }
    
    // MARK: - Authentication Methods
    
    /// Logs in a user (creates new profile if needed)
    /// - Parameters:
    ///   - username: User's chosen name
    ///   - avatar: User's chosen avatar emoji
    func login(username: String, avatar: String = "😊") {
        if let existingProfile = profileManager.profiles.first(where: { $0.username == username }) {
            currentProfile = existingProfile
        } else {
            let newProfile = UserProfile(username: username, avatar: avatar)
            profileManager.addProfile(newProfile)
            currentProfile = newProfile
        }
        currentScreen = .modeSelection
    }
    
    /// Selects an existing profile
    /// - Parameter profile: The profile to select
    func selectProfile(_ profile: UserProfile) {
        currentProfile = profile
        currentScreen = .modeSelection
    }
    
    /// Logs out current user and returns to login
    func logout() {
        currentProfile = nil
        currentScreen = .login
    }
    
    // MARK: - Profile Management
    
    /// Updates the current profile's score after game ends
    func updateCurrentProfileScore() {
        guard var profile = currentProfile else { return }
        
        // Create history entry for this game session (only sessionScore, not total)
        let historyEntry = GameHistoryEntry(
            mode: gameMode.title,
            score: sessionScore,  // Save only points earned this session
            date: Date(),
            streak: streak
        )
        profile.gameHistory.insert(historyEntry, at: 0)
        
        // Keep only last 50 games
        if profile.gameHistory.count > 50 {
            profile.gameHistory = Array(profile.gameHistory.prefix(50))
        }
        
        // Update statistics (add sessionScore to total)
        profile.totalScore += sessionScore
        profile.gamesPlayed += 1
        profile.lastPlayed = Date()
        
        if sessionScore > profile.highestScore {
            profile.highestScore = sessionScore
        }
        
        // Save changes
        currentProfile = profile
        profileManager.updateProfile(profile)
    }
    
    /// Updates profile username and avatar
    /// - Parameters:
    ///   - username: New username
    ///   - avatar: New avatar emoji
    func updateProfileInfo(username: String, avatar: String) {
        guard var profile = currentProfile else { return }
        profile.username = username
        profile.avatar = avatar
        currentProfile = profile
        profileManager.updateProfile(profile)
    }
    
    /// Shows the profile detail screen
    func showProfile() {
        currentScreen = .profile
    }
    
    // MARK: - Game Flow Methods
    
    /// Starts a new game with specified mode
    /// - Parameter mode: The game mode to play
    func startGame(mode: GameMode) {
        gameMode = mode
        gameStarted = true
        currentScreen = .game
        
        // Load existing total score for this mode
        if let profile = currentProfile {
            let modeName = mode.title
            let modeEntries = profile.gameHistory.filter { $0.mode == modeName }
            let totalModeScore = modeEntries.reduce(0) { $0 + $1.score }
            score = totalModeScore
        } else {
            score = 0
        }
        
        sessionScore = 0  // Reset session score
        streak = 0
        dealCards()
        
        // Stop background music during gameplay
        AudioManager.shared.stopBackgroundMusic()
        
        if mode == .competitive {
            startTimer()
        }
    }
    
    /// Ends the current game and saves score
    func endGame() {
        stopTimer()
        AudioManager.shared.stopSpeaking()
        updateCurrentProfileScore()
        gameStarted = false
        currentScreen = .modeSelection
    }
    
    /// Deals cards to the player's hand
    func dealCards() {
        if gameMode == .solitaire || gameMode == .competitive || gameMode == .matchCapitalNickname {
            // Generate challenge based on game mode
            if gameMode == .competitive {
                generateCompetitiveChallenge()
            } else if gameMode == .matchCapitalNickname {
                generateCapitalNicknameChallenge()
            } else {
                generateChallenge()
            }
            
            // Ensure at least one correct answer in hand
            guard let challenge = currentChallenge else { return }
            
            // Find all states that match the challenge
            var matchingStates = allStates.filter { challenge.matches($0) }
            var attempts = 0
            
            // Keep trying to find a valid challenge with matching states
            while matchingStates.isEmpty && attempts < 20 {
                if gameMode == .competitive {
                    generateCompetitiveChallenge()
                } else if gameMode == .matchCapitalNickname {
                    generateCapitalNicknameChallenge()
                } else {
                    generateChallenge()
                }
                guard let newChallenge = currentChallenge else { return }
                matchingStates = allStates.filter { newChallenge.matches($0) }
                attempts += 1
            }
            
            // If we still can't find matches, create a simple challenge
            if matchingStates.isEmpty {
                // Fallback: just pick any 5 random cards
                playerHand = Array(allStates.shuffled().prefix(5))
                // Set a basic challenge that at least one card will match
                if let firstCard = playerHand.first {
                    currentChallenge = .startsWithLetter(String(firstCard.name.prefix(1)))
                }
                return
            }
            
            // Pick one guaranteed correct answer
            let correctCard = matchingStates.randomElement()!
            
            // Pick 4 other random cards (that may or may not be correct)
            let otherCards = allStates.filter { $0.id != correctCard.id }.shuffled().prefix(4)
            
            // Combine and shuffle to hide the correct answer
            playerHand = Array([correctCard] + otherCards).shuffled()
            
        } else if gameMode == .goTheDistance {
            // For distance mode, generate distance challenge first
            generateDistanceChallenge()
            
            // Get the reference state if this is a closest/farthest challenge
            var excludedState: StateCard? = nil
            if case .closestTo(let referenceState) = currentChallenge {
                excludedState = referenceState
            } else if case .farthestFrom(let referenceState) = currentChallenge {
                excludedState = referenceState
            }
            
            // Deal random cards, excluding the reference state
            if let excluded = excludedState {
                let availableStates = allStates.filter { $0.id != excluded.id }
                playerHand = Array(availableStates.shuffled().prefix(5))
            } else {
                // For other challenges, deal any 5 cards
                playerHand = Array(allStates.shuffled().prefix(5))
            }
        }
        
        // Speak the final challenge question ONCE after cards are dealt
        if let challenge = currentChallenge {
            AudioManager.shared.speakQuestion(challenge.description)
        }
        
        // Reset hint availability for Educational Mode
        if gameMode == .solitaire {
            hintAvailable = true
        }
    }
    
    /// Generates a distance-specific challenge for Go the Distance mode
    func generateDistanceChallenge() {
        // With 50 states, use more diverse reference states
        let referenceStates = ["California", "Texas", "Florida", "New York", "Maine",
                              "Alaska", "Hawaii", "Washington", "Montana", "Louisiana"]
        let directionStates = ["Kansas", "Ohio", "Tennessee", "Virginia", "Illinois",
                              "Missouri", "Iowa", "Colorado", "Georgia", "Michigan"]
        
        // Pick a random reference state that won't be in the hand
        guard let referenceStateName = referenceStates.randomElement(),
              let referenceState = allStates.first(where: { $0.name == referenceStateName }) else {
            return
        }
        
        let challenges: [ChallengePrompt] = [
            .closestTo(referenceState),
            .farthestFrom(referenceState),
            .northOf(directionStates.randomElement()!),
            .southOf(directionStates.randomElement()!),
            .eastOf(directionStates.randomElement()!),
            .allEastOf(directionStates.randomElement()!),
            .mostNorthern,
            .mostSouthern,
            .mostEastern,
            .mostWestern
        ]
        
        currentChallenge = challenges.randomElement()
        // Don't speak here - will speak after dealCards confirms valid challenge
    }
    
    /// Generates a random challenge prompt
    func generateChallenge() {
        // With 50 states, use a wider variety for challenges
        let commonStates = ["Texas", "California", "New York", "Florida", "Illinois",
                           "Pennsylvania", "Ohio", "Georgia", "Michigan", "Virginia",
                           "Tennessee", "Missouri", "Wisconsin", "Washington", "Colorado"]
        
        // List of states for directional challenges
        let directionStates = ["Kansas", "Mississippi", "Ohio", "Illinois", "Missouri",
                              "Tennessee", "Virginia", "Iowa", "Colorado", "Texas",
                              "Georgia", "Michigan", "Wisconsin", "Indiana", "Kentucky"]
        
        let challenges: [ChallengePrompt] = [
            // Original challenges (no capital questions in Educational mode)
            .syllableCount(Int.random(in: 2...5)),
            .startsWithLetter(String("ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()!)),
            .isCoastal,
            .inRegion(["South", "West", "Northeast", "Midwest"].randomElement()!),
            .endsWithLetter(String("AEIOU".randomElement()!)),
            
            // New challenges (no capital-related)
            .bordersWith(commonStates.randomElement()!),
            .hasDoubleLetters,
            .nicknameHasNature,
            .notCoastal,
            
            // Directional challenges
            .westOf(directionStates.randomElement()!),
            .eastOf(directionStates.randomElement()!),
            .northOf(directionStates.randomElement()!),
            .southOf(directionStates.randomElement()!)
        ]
        currentChallenge = challenges.randomElement()
        // Don't speak here - will speak after dealCards confirms valid challenge
    }
    
    /// Generates challenge for Speed Challenge mode (includes distance questions)
    func generateCompetitiveChallenge() {
        let commonStates = ["Texas", "California", "New York", "Florida", "Illinois",
                           "Pennsylvania", "Ohio", "Georgia", "Michigan", "Virginia"]
        
        let directionStates = ["Kansas", "Mississippi", "Ohio", "Illinois", "Missouri",
                              "Tennessee", "Virginia", "Iowa", "Colorado", "Georgia"]
        
        // Reference states for distance challenges
        let referenceStates = ["Kansas", "Nevada", "Tennessee", "Virginia", "Colorado",
                              "Missouri", "Iowa", "Colorado", "Georgia", "Michigan"]
        
        // Pick a random reference state
        guard let referenceStateName = referenceStates.randomElement(),
              let referenceState = allStates.first(where: { $0.name == referenceStateName }) else {
            // Fallback to regular challenge
            generateChallenge()
            return
        }
        
        let challenges: [ChallengePrompt] = [
            // Regular challenges
            .syllableCount(Int.random(in: 2...5)),
            .startsWithLetter(String("ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()!)),
            .isCoastal,
            .inRegion(["South", "West", "Northeast", "Midwest"].randomElement()!),
            .endsWithLetter(String("AEIOU".randomElement()!)),
            .bordersWith(commonStates.randomElement()!),
            .hasDoubleLetters,
            .nicknameHasNature,
            .notCoastal,
            .westOf(directionStates.randomElement()!),
            .eastOf(directionStates.randomElement()!),
            .northOf(directionStates.randomElement()!),
            .southOf(directionStates.randomElement()!),
            
            // Distance challenges from Go the Distance mode
            .closestTo(referenceState),
            .farthestFrom(referenceState),
            .mostNorthern,
            .mostSouthern,
            .mostEastern,
            .mostWestern
        ]
        
        currentChallenge = challenges.randomElement()
        // Don't speak here - will speak after dealCards confirms valid challenge
    }
    
    /// Generates challenge for Match a Capital/Nickname mode
    func generateCapitalNicknameChallenge() {
        // Pick a random state for the challenge
        guard let randomState = allStates.randomElement() else { return }
        
        // Randomly choose between capital or nickname challenge
        let challenges: [ChallengePrompt] = [
            .matchCapital(randomState.capital),
            .matchNickname(randomState.nickname)
        ]
        
        currentChallenge = challenges.randomElement()
        // Don't speak here - will speak after dealCards confirms valid challenge
    }
    
    // MARK: - Game Action Methods
    
    /// Handles player "slapping" a card
    /// - Parameter card: The card that was slapped
    func slapCard(_ card: StateCard) {
        AudioManager.shared.playTapSound()
        if gameMode == .solitaire || gameMode == .competitive || gameMode == .matchCapitalNickname {
            checkChallengeMatch(card)
        } else if gameMode == .goTheDistance {
            checkDistanceMatch(card)
        }
    }
    
    /// Checks if card matches the current challenge
    /// - Parameter card: The card to check
    private func checkChallengeMatch(_ card: StateCard) {
        guard let challenge = currentChallenge else { return }
        
        // Check if this is a distance-type challenge (for competitive mode)
        switch challenge {
        case .closestTo, .farthestFrom, .mostNorthern, .mostSouthern, .mostEastern, .mostWestern, .allEastOf:
            // Route to distance matching logic
            checkDistanceMatch(card)
            return
        default:
            break
        }
        
        // Regular challenge matching
        if challenge.matches(card) {
            // Correct match
            handleCorrectAnswer(card)
        } else {
            // Incorrect match
            handleIncorrectAnswer()
        }
    }
    
    /// Checks distance match for "Go the Distance" mode
    /// - Parameter card: The card to check
    private func checkDistanceMatch(_ card: StateCard) {
        guard let challenge = currentChallenge else { return }
        
        // Check if this is a multi-answer challenge
        if case .allEastOf = challenge {
            // Multi-answer challenge - allow multiple correct selections
            if challenge.matchesDistanceChallenge(card, allCards: playerHand) {
                // Mark as selected
                selectedCorrectCards.insert(card.id)
                let points = 5
                score += points
                sessionScore += points
                streak += 1  // Increment streak for each correct answer
                isCorrectAnswer = true
                
                // Play celebratory sound for correct answer
                AudioManager.shared.playCorrectSound()
                
                // Check for badge award
                let badgeWasAwarded = willAwardBadge()
                checkForBadgeAward()
                
                // Cheerful multi-answer feedback
                let multiAnswerPhrases = ["Yay!", "Nice!", "Great!", "Awesome!", "Perfect!"]
                let cheer = multiAnswerPhrases.randomElement() ?? "Yes!"
                feedback = "\(cheer) \(selectedCorrectCards.count) found! 🎯"
                showFeedbackMessage()
                
                // Check if all correct answers have been found
                let allCorrectCards = playerHand.filter { challenge.matchesDistanceChallenge($0, allCards: playerHand) }
                if selectedCorrectCards.count >= allCorrectCards.count {
                    // All found! Move to next challenge - wait for badge if awarded
                    let delay: Double = badgeWasAwarded ? 7.0 : 2.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        self.selectedCorrectCards.removeAll()
                        self.dealCards() // Get new cards and challenge
                    }
                }
            } else {
                // Wrong answer
                handleIncorrectAnswer()
            }
        } else {
            // Single-answer challenge
            if challenge.matchesDistanceChallenge(card, allCards: playerHand) {
                handleCorrectAnswer(card)
            } else {
                handleIncorrectAnswer()
            }
        }
    }
    
    /// Handles correct answer logic
    /// - Parameter card: The correctly matched card
    private func handleCorrectAnswer(_ card: StateCard) {
        let points = 10 + (streak * 5)
        score += points
        sessionScore += points
        streak += 1
        isCorrectAnswer = true
        
        // Play celebratory sound for correct answer
        AudioManager.shared.playCorrectSound()
        
        // Check for badge award at streak of 10
        let badgeWasAwarded = willAwardBadge()
        checkForBadgeAward()
        
        // Cheerful feedback messages
        let cheerfulPhrases = ["Amazing!", "Fantastic!", "Brilliant!", "Super!", "Excellent!"]
        let randomCheer = cheerfulPhrases.randomElement() ?? "Great!"
        
        // Customize feedback based on challenge type
        guard let challenge = currentChallenge else { return }
        
        switch challenge {
        case .hasCapitalSyllables:
            feedback = "\(randomCheer) +\(10 + ((streak - 1) * 5)) points\n\(card.name): \(card.capital)"
        case .capitalHasName:
            feedback = "\(randomCheer) +\(10 + ((streak - 1) * 5)) points\n\(card.name): \(card.capital)"
        default:
            feedback = "\(randomCheer) +\(10 + ((streak - 1) * 5)) points"
        }
        
        showFeedbackMessage()
        
        // Wait for feedback (and badge if awarded) before dealing new cards
        let delay: Double = badgeWasAwarded ? 7.0 : 2.0  // 2.5s feedback + 4s badge = 6.5s, use 7s to be safe
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // Deal completely new hand with new challenge
            self.dealCards()
        }
    }
    
    /// Handles incorrect answer logic
    private func handleIncorrectAnswer() {
        streak = 0
        isCorrectAnswer = false
        
        // Encouraging feedback messages
        let encouragingPhrases = [
            "Almost there! Keep trying!",
            "Good effort! Try again!",
            "Nice try! You can do it!",
            "So close! Give it another go!",
            "Keep going! You're learning!"
        ]
        feedback = encouragingPhrases.randomElement() ?? "Try again!"
        
        // Play encouraging sound for incorrect answer
        AudioManager.shared.playIncorrectSound()
        
        showFeedbackMessage()
        // Note: Cards stay in hand, player can try again
    }
    
    /// Shows feedback message with auto-dismiss
    private func showFeedbackMessage() {
        showingFeedback = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.showingFeedback = false
        }
    }
    
    /// Shows hint for Educational Mode
    func showHint() {
        print("🔍 showHint called - gameMode: \(gameMode), hintAvailable: \(hintAvailable)")
        
        guard gameMode == .solitaire && hintAvailable else {
            print("🔍 Guard failed - gameMode check: \(gameMode == .solitaire), hintAvailable: \(hintAvailable)")
            return
        }
        
        guard let challenge = currentChallenge else {
            print("🔍 No current challenge")
            return
        }
        
        print("🔍 Current challenge: \(challenge)")
        
        // Find the correct answer
        let correctCard = playerHand.first { card in
            challenge.matches(card)
        }
        
        guard let card = correctCard else {
            print("🔍 No correct card found in hand")
            return
        }
        
        print("🔍 Correct card found: \(card.name)")
        
        // Generate helpful hint based on challenge type
        switch challenge {
        case .startsWithLetter(let letter):
            hintText = "💡 Look for a state starting with '\(letter)'!\nThe answer is in the \(card.region) region."
            
        case .endsWithLetter(let letter):
            hintText = "💡 Find a state ending with '\(letter)'!\nHint: It's in the \(card.region) region."
            
        case .syllableCount(let count):
            hintText = "💡 Find a state with \(count) syllable\(count == 1 ? "" : "s")!\nIt's in the \(card.region) region."
            
        case .inRegion(let region):
            hintText = "💡 Find a \(region) state!\nHint: It starts with '\(card.name.prefix(1))'."
            
        case .isCoastal:
            hintText = "💡 Find a coastal state!\nHint: \(card.name) touches the ocean."
            
        case .hasNickname(let word):
            hintText = "💡 Look for '\(word)' state!\nHint: The state is \(card.name)."
            
        case .bordersWith(let state):
            hintText = "💡 Find a state bordering \(state)!\nHint: It's in the \(card.region) region."
        
        default:
            // For any other challenge types (directional, etc.)
            // Extract the challenge description to give a contextual hint
            let description = challenge.description.lowercased()
            
            if description.contains("east") {
                hintText = "💡 Look for a state to the EAST!\nHint: \(card.name) is in the \(card.region)."
            } else if description.contains("west") {
                hintText = "💡 Look for a state to the WEST!\nHint: \(card.name) is in the \(card.region)."
            } else if description.contains("north") {
                hintText = "💡 Look for a state to the NORTH!\nHint: \(card.name) is in the \(card.region)."
            } else if description.contains("south") {
                hintText = "💡 Look for a state to the SOUTH!\nHint: \(card.name) is in the \(card.region)."
            } else if description.contains("double") || description.contains("repeated") {
                hintText = "💡 Look for repeated letters in the name!\nHint: \(card.name) has double letters."
            } else if description.contains("nature") || description.contains("nickname") {
                hintText = "💡 Think about the state's nickname!\nHint: \(card.nickname) for \(card.name)."
            } else if description.contains("not coastal") || description.contains("landlocked") {
                hintText = "💡 Find a landlocked state!\nHint: \(card.name) is inland."
            } else {
                hintText = "💡 Think about the question carefully!\nHint: The answer is \(card.name)."
            }
        }
        
        print("🔍 Hint text generated: \(hintText)")
        
        // Show hint and disable hint button temporarily
        DispatchQueue.main.async {
            self.showingHint = true
            self.hintAvailable = false
            
            print("🔍 showingHint set to: \(self.showingHint)")
            print("🔍 hintAvailable set to: \(self.hintAvailable)")
        }
        
        // Re-enable hint after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            print("🔍 Auto-dismissing hint")
            self.showingHint = false
            self.hintAvailable = true
        }
    }
    
    /// Scrambles the player's hand
    func scrambleCards() {
        guard canScramble else { return }
        
        isScrambling = true
        canScramble = false
        
        playerHand.shuffle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isScrambling = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.canScramble = true
        }
    }
    
    // MARK: - Timer Methods
    
    /// Starts the countdown timer for competitive mode
    private func startTimer() {
        timer = 30
        timerCancellable = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timer > 0 {
                self.timer -= 1
            } else {
                self.endGame()
            }
        }
    }
    
    /// Stops the countdown timer
    private func stopTimer() {
        timerCancellable?.invalidate()
        timerCancellable = nil
    }
    
    // MARK: - Utility Methods
    
    /// Calculates distance between two coordinates
    /// - Parameters:
    ///   - from: Starting coordinate
    ///   - to: Ending coordinate
    /// - Returns: Distance in meters
    private func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }
    
    // MARK: - Badge System
    
    /// Checks if a badge will be awarded (without actually awarding it)
    private func willAwardBadge() -> Bool {
        // Check if at a streak milestone (10, 15, 20, 25 correct answers)
        guard let profile = currentProfile else { return false }
        
        let modeName = gameMode.title
        let currentBadge = profile.badges.getBadge(for: modeName)
        
        // Determine which badge would be awarded based on streak
        let newBadge: BadgeTier
        switch streak {
        case 10:
            newBadge = .bronze
        case 15:
            newBadge = .silver
        case 20:
            newBadge = .gold
        case 25:
            newBadge = .platinum
        default:
            return false
        }
        
        // Check if it would be an upgrade
        let currentIndex = BadgeTier.allCases.firstIndex(of: currentBadge) ?? 0
        let newIndex = BadgeTier.allCases.firstIndex(of: newBadge) ?? 0
        
        return newIndex > currentIndex
    }
    
    /// Checks if player has earned a badge and awards it
    private func checkForBadgeAward() {
        print("🏆 checkForBadgeAward called - streak: \(streak)")
        
        guard var profile = currentProfile else {
            print("🏆 No current profile")
            return
        }
        
        let modeName = gameMode.title
        let currentBadge = profile.badges.getBadge(for: modeName)
        print("🏆 Mode: \(modeName), Current badge: \(currentBadge.rawValue)")
        
        // Determine which badge to award based on streak (10, 15, 20, 25)
        let newBadge: BadgeTier
        switch streak {
        case 10:
            newBadge = .bronze
        case 15:
            newBadge = .silver
        case 20:
            newBadge = .gold
        case 25:
            newBadge = .platinum
        default:
            print("🏆 Streak \(streak) doesn't match any badge tier (10, 15, 20, 25)")
            return
        }
        
        print("🏆 New badge would be: \(newBadge.rawValue)")
        
        // Only award if it's an upgrade
        let currentIndex = BadgeTier.allCases.firstIndex(of: currentBadge) ?? 0
        let newIndex = BadgeTier.allCases.firstIndex(of: newBadge) ?? 0
        
        print("🏆 Current index: \(currentIndex), New index: \(newIndex)")
        
        if newIndex > currentIndex {
            print("🏆 AWARDING BADGE: \(newBadge.rawValue)")
            
            // Award the badge
            profile.badges.upgradeBadge(for: modeName, to: newBadge)
            currentProfile = profile
            profileManager.updateProfile(profile)
            
            // Show badge award animation
            earnedBadge = newBadge
            print("🏆 earnedBadge set to: \(newBadge.rawValue)")
            
            // Reset streak to 0 after badge is awarded
            print("🏆 Resetting streak from \(streak) to 0")
            streak = 0
            
            // Delay to show current feedback first, then show badge
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                print("🏆 Setting showingBadgeAward = true")
                self.showingBadgeAward = true
                
                // Auto-dismiss after 4 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    print("🏆 Setting showingBadgeAward = false")
                    self.showingBadgeAward = false
                }
            }
        } else {
            print("🏆 Not an upgrade - skipping badge award")
        }
    }
}
