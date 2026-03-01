import SwiftUI

struct BreathingView: View {
    @ObservedObject var engine: BreathingEngine
    @ObservedObject var soundManager: SoundManager
    var onStop: () -> Void

    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 10) {
            OrbView(scale: engine.orbScale)

            Text(engine.phaseLabel)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.primary)
                .frame(minWidth: 50, alignment: .leading)
                .animation(.none, value: engine.phaseLabel)

            Spacer()

            Text(timerString)
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(Color.adaptiveTimerText)

            Button {
                soundManager.isMuted.toggle()
            } label: {
                Image(systemName: soundManager.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.plain)

            if isHovering && engine.state == .running {
                Button {
                    onStop()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(.plain)
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.adaptivePillBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
        .onChange(of: engine.currentPhase) { _, newPhase in
            if engine.state == .running {
                soundManager.playForPhase(newPhase)
            }
        }
        .onAppear {
            if engine.state == .running {
                soundManager.playForPhase(engine.currentPhase)
            }
        }
    }

    private var timerString: String {
        let total = Int(ceil(engine.timeRemaining))
        let minutes = total / 60
        let seconds = total % 60
        return String(format: "-%d:%02d", minutes, seconds)
    }
}
