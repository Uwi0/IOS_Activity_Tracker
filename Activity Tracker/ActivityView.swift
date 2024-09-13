import SwiftUI
import Charts
import SwiftData

struct ActivityView: View {
    @Query(sort: \ActivityModel.name, order: .forward)
    var activities: [ActivityModel]
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Activity Tracker")
            }
            .padding()
            .navigationTitle("Activity Tracker")
        }
    }
}

#Preview {
    ActivityView()
}
