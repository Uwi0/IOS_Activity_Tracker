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
    
    private var totalHours: Double {
        activities.reduce(0.0){ total, activity in
            total + activity.hoursPerDay
        }
    }
    private var remainingHours: Double {
        24 - totalHours
    }
    
    private var maxHourOfSelected: Double {
        remainingHours + hoursPerDay
    }
    
    private let step: Double = 1
    
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
                .chartAngleSelection(value: $selectedCount)
                
                List(activities) { activity in
                    Text(activity.name)
                        .onTapGesture {
                            withAnimation {
                                currentActivity = activity
                                hoursPerDay = activity.hoursPerDay
                            }
                        }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                
                if let currentActivity {
                    Slider(
                        value: $hoursPerDay,
                        in: 0...maxHourOfSelected,
                        step: step
                    )
                    .onChange(of: hoursPerDay){ oldValue, newValue in
                        
                    }
                }
                
                Button("Add"){
                    addActivity()
                }.buttonStyle(.borderedProminent)
                    .disabled(remainingHours <= 0)
                
            }
            .padding()
            .navigationTitle("Activity Tracker")
        }
    }
    
    private func addActivity() {
        
    }
    
    private func deleteActivity(at offset: IndexSet) {
        
    }
    
    private func outterRadiusWhen(_ isSelected: Bool) -> MarkDimension {
        let radius = isSelected ? 1.05 : 0.95
        return .ratio(radius)
    }
}

#Preview {
    ActivityView()
}
