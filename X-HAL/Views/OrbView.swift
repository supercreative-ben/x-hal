import SwiftUI

struct OrbView: View {
    var scale: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            .white,
                            Color.adaptiveOrbCyan.opacity(0.8),
                            Color.adaptiveOrbCyan.opacity(0.3),
                            Color.adaptiveOrbCyan.opacity(0.0),
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 20
                    )
                )
                .frame(width: 40, height: 40)
                .scaleEffect(scale)
                .shadow(color: Color.adaptiveOrbCyan.opacity(0.5), radius: 8 * scale)
                .shadow(color: Color.adaptiveOrbCyan.opacity(0.3), radius: 14 * scale)
        }
        .frame(width: 46, height: 46)
        .animation(.easeInOut(duration: 0.15), value: scale)
    }
}
