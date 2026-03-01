import AppKit
import SwiftUI
import HotKey

final class FloatingPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.nonactivatingPanel, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        isFloatingPanel = true
        level = .floating
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        isMovableByWindowBackground = true
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var panel: FloatingPanel!
    private var hotKey: HotKey?
    private var eventMonitor: Any?

    private let engine = BreathingEngine()
    private let soundManager = SoundManager()
    private let streakManager = StreakManager()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "wind", accessibilityDescription: "X-HAL")
            button.action = #selector(togglePanel)
            button.target = self
        }

        let contentView = PanelContentView(
            engine: engine,
            soundManager: soundManager,
            streakManager: streakManager
        )

        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame = NSRect(x: 0, y: 0, width: 260, height: 70)

        panel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 260, height: 70))
        panel.contentView = hostingView
        centerPanel()

        hotKey = HotKey(key: .x, modifiers: [.command, .shift])
        hotKey?.keyDownHandler = { [weak self] in
            self?.togglePanel()
        }

        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self else { return event }
            if event.keyCode == 53 {
                if self.engine.state == .running {
                    self.engine.stop()
                    self.soundManager.stopAll()
                } else {
                    self.hidePanel()
                }
                return nil
            }
            return event
        }

        showPanel()
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showPanel()
        return false
    }

    @objc private func togglePanel() {
        if panel.isVisible {
            if engine.state != .running {
                hidePanel()
            }
        } else {
            showPanel()
        }
    }

    private func showPanel() {
        if !panel.isVisible {
            centerPanel()
        }
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func hidePanel() {
        panel.orderOut(nil)
    }

    private func centerPanel() {
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.visibleFrame
        let x = screenFrame.midX - panel.frame.width / 2
        let y = screenFrame.midY - panel.frame.height / 2
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}

struct PanelContentView: View {
    @ObservedObject var engine: BreathingEngine
    @ObservedObject var soundManager: SoundManager
    @ObservedObject var streakManager: StreakManager

    var body: some View {
        Group {
            switch engine.state {
            case .idle:
                StartView(streakManager: streakManager) {
                    engine.start()
                }
            case .running:
                BreathingView(engine: engine, soundManager: soundManager) {
                    engine.stop()
                    soundManager.stopAll()
                }
            case .completed:
                BreathingView(engine: engine, soundManager: soundManager) {}
            }
        }
        .frame(width: 260, height: 70)
        .onChange(of: engine.state) { _, newState in
            if newState == .completed {
                streakManager.recordCompletion()
                soundManager.playCompletion()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak engine] in
                    engine?.reset()
                }
            }
        }
    }
}
