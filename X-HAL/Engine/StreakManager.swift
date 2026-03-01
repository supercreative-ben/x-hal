import Foundation

struct DayStatus: Identifiable {
    let id: String
    let date: Date
    let completed: Bool
}

final class StreakManager: ObservableObject {
    private static let key = "xhal_completedDates"

    @Published private(set) var completedDates: Set<String>

    init() {
        let stored = UserDefaults.standard.stringArray(forKey: Self.key) ?? []
        self.completedDates = Set(stored)
    }

    func recordCompletion() {
        let today = Self.dateString(from: Date())
        completedDates.insert(today)
        persist()
    }

    var currentStreak: Int {
        var streak = 0
        var date = Date()

        if !completedDates.contains(Self.dateString(from: date)) {
            date = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
            if !completedDates.contains(Self.dateString(from: date)) {
                return 0
            }
        }

        while completedDates.contains(Self.dateString(from: date)) {
            streak += 1
            date = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
        }

        return streak
    }

    var last10Days: [DayStatus] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (0..<10).reversed().map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
            let key = Self.dateString(from: date)
            return DayStatus(id: key, date: date, completed: completedDates.contains(key))
        }
    }

    private func persist() {
        UserDefaults.standard.set(Array(completedDates), forKey: Self.key)
    }

    private static func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
}
