import SwiftUI

extension Color {
    init(light: Color, dark: Color) {
        self.init(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return NSColor(isDark ? dark : light)
        })
    }

    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }

    static let adaptivePillBackground = Color(
        light: Color(hex: 0xF2F2F7),
        dark: Color(hex: 0x1C1C1E)
    )

    static let adaptiveTimerText = Color(
        light: Color(hex: 0x0066CC),
        dark: Color(hex: 0x7EB6FF)
    )

    static let adaptiveStreakFilled = Color(
        light: Color(hex: 0x0099CC),
        dark: Color(hex: 0x4FC3F7)
    )

    static let adaptiveStreakEmpty = Color(
        light: Color(hex: 0xD1D1D6),
        dark: Color(hex: 0x2C2C2E)
    )

    static let adaptiveOrbCyan = Color(hex: 0x4FC3F7)
}
