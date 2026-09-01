import SwiftUI

@main
struct PocketPrankApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreenView()
                .statusBarHidden(false)
                .preferredColorScheme(.dark)
        }
    }
}
