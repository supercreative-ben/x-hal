import AVFoundation
import AppKit

final class SoundManager: ObservableObject {
    @Published var isMuted: Bool {
        didSet {
            UserDefaults.standard.set(isMuted, forKey: "xhal_isMuted")
            if isMuted { stopAll() }
        }
    }

    private var players: [BreathingPhase: AVAudioPlayer] = [:]
    private var completionPlayer: AVAudioPlayer?
    private var currentPhase: BreathingPhase?

    init() {
        self.isMuted = UserDefaults.standard.bool(forKey: "xhal_isMuted")
        loadSounds()
    }

    private func loadSounds() {
        let fileMap: [(BreathingPhase, String)] = [
            (.deepInhale, "deep-inhale"),
            (.shortInhale, "short-inhale"),
            (.longExhale, "long-exhale"),
        ]

        for (phase, filename) in fileMap {
            if let url = Bundle.main.url(forResource: filename, withExtension: "wav", subdirectory: "Sounds") {
                players[phase] = try? AVAudioPlayer(contentsOf: url)
                players[phase]?.prepareToPlay()
            }
        }

        if let url = Bundle.main.url(forResource: "completion", withExtension: "wav", subdirectory: "Sounds") {
            completionPlayer = try? AVAudioPlayer(contentsOf: url)
            completionPlayer?.prepareToPlay()
        }
    }

    func playForPhase(_ phase: BreathingPhase) {
        guard !isMuted else { return }

        if phase == currentPhase { return }
        stopAll()
        currentPhase = phase

        guard phase != .pause else { return }

        players[phase]?.currentTime = 0
        players[phase]?.play()
    }

    func playCompletion() {
        if let completionPlayer, !isMuted {
            completionPlayer.currentTime = 0
            completionPlayer.play()
        } else if !isMuted {
            NSSound(named: "Purr")?.play()
        }
    }

    func stopAll() {
        for player in players.values {
            player.stop()
        }
        currentPhase = nil
    }
}
