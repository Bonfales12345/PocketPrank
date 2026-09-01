import SwiftUI

struct HomeScreenView: View {
    @StateObject private var setup = PocketSetupState()
    private let pocketIconFrame = UnitFrame(x: 0.5, y: 0.5, width: 0.2, height: 0.1)

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(setup.pocketIsActivated ? "homescreenwithpocket" : "homescreen")
                    .resizable()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .ignoresSafeArea()

                if !setup.pocketIsActivated {
                    Button {
                        setup.beginSetup()
                    } label: {
                        Color.clear
                    }
                    .buttonStyle(.plain)
                    .frame(
                        width: geo.size.width * pocketIconFrame.width,
                        height: geo.size.height * pocketIconFrame.height
                    )
                    .position(
                        x: geo.size.width * pocketIconFrame.x,
                        y: geo.size.height * pocketIconFrame.y
                    )
                }
            }
        }
        .ignoresSafeArea()
        .task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            if !setup.pocketIsActivated && !setup.isPresentingSetup {
                setup.beginSetup()
            }
        }
        .sheet(isPresented: $setup.isPresentingSetup) {
            PocketSetupFlowView()
                .environmentObject(setup)
                .interactiveDismissDisabled(setup.step != .complete)
        }
    }
}

struct UnitFrame {
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
}
