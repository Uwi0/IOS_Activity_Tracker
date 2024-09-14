import SwiftUI
import Charts
import SwiftData

struct ActivityView: View {
    @Query(sort: \ActivityModel.name, order: .forward)
    var activities: [ActivityModel]
    
    @Environment(\.modelContext) private var context
    
    @State private var newName: String = ""
    @State private var hoursPerDay: Double = 0
    @State private var currentActivity: ActivityModel? = nil
    @State private var selectedCount: Int? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Chart {
                    let isSelected: Bool = true
                    ForEach(activities) { activity in
                        SectorMark(
                            angle: .value("Activities", activity.hoursPerDay),
                            innerRadius: .ratio(0.6),
                            outerRadius: outterRadiusWhen(isSelected),
                            angularInset: 1
                        )
                        .foregroundStyle(.red)
                        .cornerRadius(5)
                    }
                }
            }
            .padding()
            .navigationTitle("Activity Tracker")
        }
    }
    
    private func outterRadiusWhen(_ isSelected: Bool) -> MarkDimension {
        let radius = isSelected ? 1.05 : 0.95
        return .ratio(radius)
    }
}

#Preview {
    ActivityView()
}
