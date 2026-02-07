//
//  AudioManager.swift
//  ScrambledStates
//
//  Created by Margi Patel on 1/31/26.

//  Centralised audio: kid-friendly synthesised sound effects and
//  text-to-speech for reading out challenge questions.
//  No external audio files are needed — every sound is generated
//  in code from pure sine waves.
//

import Foundation
import AVFoundation

// MARK: - AudioManager

/// Singleton that owns an AVAudioEngine for tone playback and an
/// AVSpeechSynthesizer for TTS.  Instantiate once; call methods from
/// anywhere.
final class AudioManager {

    static let shared = AudioManager()

    // MARK: - Private: AVAudioEngine graph
    //
    //   output (PlayerNode)  →  mainMixerNode  →  outputNode (speakers)
    //
    private let engine = AVAudioEngine()
    private let output = AVAudioPlayerNode()
    /// The format the engine actually negotiated after start — could be
    /// stereo on real hardware or mono on simulator.  Buffers must match
    /// this exactly or CoreAudio crashes.
    private var playerFormat: AVAudioFormat!

    // MARK: - Private: TTS

    private let synthesizer = AVSpeechSynthesizer()
    /// Guard against re-speaking the identical string on SwiftUI rebuilds.
    private var lastSpokenText: String = ""

    /// Lazily resolved once on first use.  Picks the warmest female
    /// en-US voice available, preferring higher quality tiers.
    /// Falls back to the system default if nothing matches.
    private lazy var kidVoice: AVSpeechSynthesisVoice? = {
        let voices = AVSpeechSynthesisVoice.speechVoices()

        // Names ordered by warmth / naturalness for a kids app.
        // Joelle & Noelle (enhanced) are the most natural-sounding
        // female voices Apple ships for en-US.
        let preferredNames = ["Joelle", "Noelle", "Samantha"]

        // Helper: score a voice so we can sort candidates.
        // Higher is better.  Quality tier is worth more than name order.
        func score(_ v: AVSpeechSynthesisVoice) -> Int {
            let qualityPoints: Int
            switch v.quality {
            case .premium:  qualityPoints = 200
            case .enhanced: qualityPoints = 100
            default:        qualityPoints = 0   // .default / compact
            }
            let namePoints: Int
            if let idx = preferredNames.firstIndex(of: v.name) {
                namePoints = (preferredNames.count - idx) * 10
            } else {
                namePoints = 0
            }
            return qualityPoints + namePoints
        }

        // Candidates: any en-US voice whose name is in our preferred list.
        let candidates = voices.filter { v in
            v.language == "en-US" && preferredNames.contains(v.name)
        }

        if let best = candidates.max(by: { score($0) < score($1) }) {
            return best
        }

        // Wider fallback: best-quality female-sounding en-US voice
        // (heuristic: name doesn't appear in a short male-name list).
        let maleNames: Set<String> = ["Alex", "Fred", "Tom", "Daniel", "Kyle", "Oliver"]
        let femaleCandidates = voices.filter { v in
            v.language == "en-US" && !maleNames.contains(v.name)
        }
        return femaleCandidates.max(by: { score($0) < score($1) })
        // nil here means "use system default" — that's fine.
    }()
    
    // MARK: - Private: Background Music
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var isMusicMuted: Bool = false

    // MARK: - Init

    private init() {
        // Configure audio session FIRST before creating any audio components
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AudioManager: Failed to configure audio session - \(error.localizedDescription)")
        }
        
        engine.attach(output)
        engine.connect(output, to: engine.mainMixerNode, format: nil)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: nil)

        do {
            try engine.start()
            // Snapshot the format the engine settled on — must use this
            // for every buffer we schedule on `output`.
            playerFormat = output.outputFormat(forBus: 0)
        } catch {
            // If the engine can't start (e.g. simulator with no audio),
            // the app continues silently — no crash.
        }
        
        // Setup background music
        setupBackgroundMusic()
    }

    // MARK: - Public: Sound Effects

    /// Warm ascending three-note chime played once on app launch.
    /// C5 → E5 → G5  (a simple major arpeggio).
    func playLaunchSound() {
        let notes: [(freq: Double, dur: Double)] = [
            (523.25, 0.30),   // C5
            (659.25, 0.30),   // E5
            (783.99, 0.50)    // G5  (held a bit longer for a nice finish)
        ]
        playToneSequence(notes, volume: 0.40)
    }

    /// Short two-note "boop" played on every button tap.
    func playTapSound() {
        let notes: [(freq: Double, dur: Double)] = [
            (880.0,  0.07),   // A5
            (1046.5, 0.10)    // C6
        ]
        playToneSequence(notes, volume: 0.30)
    }
    
    /// Celebratory sound for correct answers - upward melody with triumph
    func playCorrectSound() {
        let notes: [(freq: Double, dur: Double)] = [
            (523.25, 0.15),   // C5
            (659.25, 0.15),   // E5
            (783.99, 0.15),   // G5
            (1046.5, 0.25)    // C6 (triumphant finish)
        ]
        playToneSequence(notes, volume: 0.45)
    }
    
    /// Encouraging sound for incorrect answers - gentle downward then upward
    func playIncorrectSound() {
        let notes: [(freq: Double, dur: Double)] = [
            (392.00, 0.20),   // G4
            (349.23, 0.20),   // F4 (gentle down)
            (392.00, 0.25)    // G4 (encouraging back up)
        ]
        playToneSequence(notes, volume: 0.35)
    }

    // MARK: - Public: Text-to-Speech

    /// Reads *text* aloud using the system TTS engine.
    /// Consecutive calls with the same string are ignored so that
    /// SwiftUI view rebuilds don't re-trigger speech.
    func speakQuestion(_ text: String) {
        guard text != lastSpokenText else { return }
        lastSpokenText = text

        // Stop any previous utterance immediately so the new one
        // doesn't queue behind it.
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice          = kidVoice          // warm female en-US, best quality available
        utterance.rate           = 0.40              // slower — easy for young kids to follow
        utterance.pitchMultiplier = 1.3              // noticeably higher & more playful
        utterance.volume         = 0.90

        synthesizer.speak(utterance)
    }

    /// Stops any in-progress TTS and resets the dedup guard.
    /// Call this when leaving the gameplay screen.
    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        lastSpokenText = ""
    }

    // MARK: - Private: Tone Generation

    /// Generates a buffer for each note and schedules them sequentially
    /// on the AVAudioPlayerNode.  A 15 ms fade-in and fade-out on every
    /// buffer eliminates clicks/pops at note boundaries.
    private func playToneSequence(_ notes: [(freq: Double, dur: Double)],
                                  volume: Float) {
        // playerFormat is nil if the engine failed to start — nothing to do.
        guard let format = playerFormat else {
            print("AudioManager: playerFormat is nil, skipping tone sequence")
            return
        }
        
        // Ensure engine is running
        guard engine.isRunning else {
            print("AudioManager: engine not running, skipping tone sequence")
            return
        }

        let sampleRate  = format.sampleRate
        let channelCount = Int(format.channelCount)
        
        // Validate format
        guard sampleRate > 0, channelCount > 0 else {
            print("AudioManager: Invalid format - sampleRate: \(sampleRate), channels: \(channelCount)")
            return
        }

        for note in notes {
            let frameCount = UInt32(sampleRate * note.dur)
            
            // Ensure we have a non-zero frame count
            guard frameCount > 0 else {
                print("AudioManager: Zero frame count for note, skipping")
                continue
            }
            
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format,
                                                frameCapacity: frameCount)
            else {
                print("AudioManager: Failed to create buffer")
                continue
            }

            let fadeLen = UInt32(sampleRate * 0.015)   // 15 ms

            // Write the same tone into every channel (mono or stereo)
            for ch in 0..<channelCount {
                guard let samples = buffer.floatChannelData?[ch] else {
                    print("AudioManager: No float channel data for channel \(ch)")
                    continue
                }

                for i in 0..<frameCount {
                    var s = sinf(Float(2.0 * .pi * note.freq * Double(i) / sampleRate))

                    // Linear fade envelope to avoid clicks
                    if i < fadeLen {
                        s *= Float(i) / Float(fadeLen)
                    } else if i > frameCount - fadeLen {
                        s *= Float(frameCount - i) / Float(fadeLen)
                    }

                    samples[Int(i)] = s * volume
                }
            }

            buffer.frameLength = frameCount
            
            // Verify buffer has data before scheduling
            guard buffer.frameLength > 0 else {
                print("AudioManager: Buffer frameLength is 0, skipping")
                continue
            }
            
            output.scheduleBuffer(buffer)
        }

        if !output.isPlaying {
            output.play()
        }
    }
    
    // MARK: - Background Music Methods
    
    /// Sets up the background music player with the audio file
    private func setupBackgroundMusic() {
        // Try different audio file formats
        let formats = ["mp3", "m4a", "wav", "aac"]
        var foundFile = false
        
        for format in formats {
            if let url = Bundle.main.url(forResource: "background_music", withExtension: format) {
                do {
                    backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                    backgroundMusicPlayer?.numberOfLoops = -1  // Loop indefinitely
                    backgroundMusicPlayer?.volume = 0.3        // Set volume to 30%
                    backgroundMusicPlayer?.prepareToPlay()
                    
                    print("AudioManager: Successfully loaded background_music.\(format)")
                    foundFile = true
                    break
                } catch {
                    print("AudioManager: Failed to setup background music with .\(format) - \(error.localizedDescription)")
                }
            }
        }
        
        if !foundFile {
            print("AudioManager: background_music file not found. Tried formats: \(formats.joined(separator: ", "))")
            print("Please add an audio file named 'background_music' with one of these extensions to your project.")
        }
    }
    
    /// Starts playing background music (called on app launch/mode selection)
    func playBackgroundMusic() {
        guard let player = backgroundMusicPlayer else {
            print("AudioManager: Background music player not initialized")
            return
        }
        
        if !isMusicMuted && !player.isPlaying {
            player.play()
        }
    }
    
    /// Stops background music (called when entering gameplay)
    func stopBackgroundMusic() {
        guard let player = backgroundMusicPlayer else {
            return
        }
        
        if player.isPlaying {
            player.stop()
            player.currentTime = 0  // Reset to beginning
        }
    }
    
    /// Returns whether background music is currently muted
    var isMuted: Bool {
        return isMusicMuted
    }
    
    /// Toggles background music mute/unmute
    func toggleMusicMute() {
        isMusicMuted.toggle()
        
        if isMusicMuted {
            // Mute - pause the music (preserves position)
            backgroundMusicPlayer?.pause()
        } else {
            // Unmute - resume the music
            backgroundMusicPlayer?.play()
        }
    }
}
