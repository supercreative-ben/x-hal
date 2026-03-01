import SwiftUI

struct StartView: View {
    @ObservedObject var streakManager: StreakManager
    var onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Guided breathing")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.primary)

                Spacer()

                Button(action: onStart) {
                    Text("START")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
                .onHover { hovering in
                    if hovering {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }

            HStack(spacing: 5) {
                ForEach(streakManager.last10Days) { day in
                    Circle()
                        .fill(day.completed ? Color.adaptiveStreakFilled : Color.adaptiveStreakEmpty)
                        .frame(width: 8, height: 8)
                        .shadow(
                            color: day.completed ? Color.adaptiveOrbCyan.opacity(0.6) : .clear,
                            radius: day.completed ? 2 : 0
                        )
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.adaptivePillBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
