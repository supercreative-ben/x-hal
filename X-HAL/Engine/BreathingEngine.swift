import Foundation
import Combine

enum BreathingPhase: String {
    case deepInhale
    case shortInhale
    case longExhale
    case pause

    var duration: TimeInterval {
        switch self {
        case .deepInhale: return 4.0
        case .shortInhale: return 2.0
        case .longExhale: return 6.0
        case .pause: return 1.0
        }
    }

    var label: String {
        switch self {
        case .deepInhale: return "Inhale"
        case .shortInhale: return "More"
        case .longExhale: return "Exhale"
        case .pause: return ""
        }
    }

    var next: BreathingPhase {
        switch self {
        case .deepInhale: return .shortInhale
        case .shortInhale: return .longExhale
        case .longExhale: return .pause
        case .pause: return .deepInhale
        }
    }

    var targetScale: CGFloat {
        switch self {
        case .deepInhale: return 1.0
        case .shortInhale: return 1.3
        case .longExhale: return 0.4
        case .pause: return 0.4
        }
    }

    var startScale: CGFloat {
        switch self {
        case .deepInhale: return 0.4
        case .shortInhale: return 1.0
        case .longExhale: return 1.3
        case .pause: return 0.4
        }
    }
}

enum SessionState: Equatable {
    case idle
    case running
    case completed
}

final class BreathingEngine: ObservableObject {
    static let sessionDuration: TimeInterval = 300 // 5 minutes

    @Published var state: SessionState = .idle
    @Published var currentPhase: BreathingPhase = .deepInhale
    @Published var orbScale: CGFloat = 0.4
    @Published var timeRemaining: TimeInterval = sessionDuration
    @Published var completionMessage: String = ""

    private var timer: AnyCancellable?
    private var sessionStartDate: Date?
    private var phaseStartDate: Date?

    private let completionMessages = [
        "You crushed it, Dave",
        "Nervous system: recalibrated",
        "HAL approves",
        "Back to work, Dave",
        "Cortisol levels: nominal",
        "Breathing protocol: complete",
        "All systems nominal, Dave",
    ]

    var phaseLabel: String {
        if state == .completed { return completionMessage }
        return currentPhase.label
    }

    var phaseProgress: CGFloat {
        guard let phaseStart = phaseStartDate else { return 0 }
        let elapsed = Date().timeIntervalSince(phaseStart)
        return min(CGFloat(elapsed / currentPhase.duration), 1.0)
    }

    func start() {
        state = .running
        currentPhase = .deepInhale
        sessionStartDate = Date()
        phaseStartDate = Date()
        timeRemaining = Self.sessionDuration
        orbScale = currentPhase.startScale

        timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func stop() {
        timer?.cancel()
        timer = nil
        state = .idle
        currentPhase = .deepInhale
        orbScale = 0.4
        timeRemaining = Self.sessionDuration
        sessionStartDate = nil
        phaseStartDate = nil
    }

    func reset() {
        timer?.cancel()
        timer = nil
        state = .idle
        currentPhase = .deepInhale
        orbScale = 0.4
        timeRemaining = Self.sessionDuration
        sessionStartDate = nil
        phaseStartDate = nil
        completionMessage = ""
    }

    private func tick() {
        guard state == .running, let sessionStart = sessionStartDate, let phaseStart = phaseStartDate else { return }

        let totalElapsed = Date().timeIntervalSince(sessionStart)
        timeRemaining = max(Self.sessionDuration - totalElapsed, 0)

        if timeRemaining <= 0 {
            complete()
            return
        }

        let phaseElapsed = Date().timeIntervalSince(phaseStart)
        let progress = min(CGFloat(phaseElapsed / currentPhase.duration), 1.0)

        let easedProgress = easeInOut(progress)
        orbScale = currentPhase.startScale + (currentPhase.targetScale - currentPhase.startScale) * easedProgress

        if phaseElapsed >= currentPhase.duration {
            advancePhase()
        }
    }

    private func advancePhase() {
        currentPhase = currentPhase.next
        phaseStartDate = Date()
    }

    private func complete() {
        timer?.cancel()
        timer = nil
        state = .completed
        orbScale = 0.6
        completionMessage = completionMessages.randomElement() ?? "Done"
    }

    private func easeInOut(_ t: CGFloat) -> CGFloat {
        t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
    }
}
