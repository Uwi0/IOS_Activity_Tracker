import SwiftUI
import SwiftData

@main
struct Activity_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ActivityView()
        }.modelContainer(for: ActivityModel.self)
    }
}
