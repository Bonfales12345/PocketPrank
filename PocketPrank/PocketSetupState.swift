import SwiftUI

enum PocketSetupStep: Int, CaseIterable {
    case intro
    case swayDamping
    case osUpdate
    case appInstall
    case installing
    case complete

    var next: PocketSetupStep? {
        let all = PocketSetupStep.allCases
        guard let idx = all.firstIndex(of: self), idx + 1 < all.count else { return nil }
        return all[idx + 1]
    }
}

@MainActor
final class PocketSetupState: ObservableObject {
    @Published var isPresentingSetup = false
    @Published var step: PocketSetupStep = .intro
    @Published var swayValue: Double = 0.15
    @Published var installProgress: Double = 0
    @Published var pocketIsActivated = false

    func beginSetup() {
        step = .intro
        installProgress = 0
        isPresentingSetup = true
    }

    func advance() {
        guard let next = step.next else {
            finish()
            return
        }
        withAnimation(.spring(response: 0.38, dampingFraction: 0.92)) {
            step = next
        }
        if next == .installing {
            runFakeInstall()
        }
    }

    func skip() {
        advance()
    }

    private func runFakeInstall() {
        installProgress = 0
        Task {
            let increments: [Double] = [0.06, 0.11, 0.09, 0.14, 0.08, 0.13, 0.10, 0.12, 0.09, 0.08]
            for inc in increments {
                try? await Task.sleep(nanoseconds: 220_000_000)
                withAnimation(.easeOut(duration: 0.2)) {
                    installProgress = min(1.0, installProgress + inc)
                }
            }
            try? await Task.sleep(nanoseconds: 300_000_000)
            withAnimation(.spring(response: 0.38, dampingFraction: 0.92)) {
                step = .complete
            }
        }
    }

    func finish() {
        withAnimation(.easeInOut(duration: 0.4)) {
            pocketIsActivated = true
        }
        isPresentingSetup = false
    }
}
