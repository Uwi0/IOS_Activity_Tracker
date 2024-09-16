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
                if activities.isEmpty {
                    ContentUnavailableView("Enter an Activity", systemImage: "list.dash")
                } else {
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
                }
                
                List {
                    ForEach(activities) { activity in
                        ActivityRow(activity: activity)
                            .contentShape(Rectangle())
                            .listRowBackground(selectedColorItemBy(name: activity.name))
                            .onTapGesture {
                                withAnimation {
                                    currentActivity = activity
                                    hoursPerDay = activity.hoursPerDay
                                }
                            }
                    }
                    .onDelete(perform: deleteActivity)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                
                TextField("Enter new activity", text: $newName)
                    .padding()
                    .background(.blue.gradient.opacity(0.3))
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                
                if currentActivity != nil {
                    Slider(
                        value: $hoursPerDay,
                        in: 0...maxHourOfSelected,
                        step: step
                    )
                    .onChange(of: hoursPerDay){ oldValue, newValue in
                        editActivityHour(newValue)
                    }
                }
                
                Button("Add"){
                    addActivity()
                }.buttonStyle(.borderedProminent)
                    .disabled(remainingHours <= 0)
                
            }
            .padding()
            .navigationTitle("Activity Tracker")
            .toolbar{ EditButton().onChange(of: selectedCount){ oldValue, newValue in
                if let newValue {
                    withAnimation {
                        getSelected(value: newValue)
                    }
                }
            }
            }
        }
    }
    
    private func addActivity() {
        if !newName.isEmpty && activityAlreadyAdded() {
            let activity = ActivityModel(name: newName, hoursPerDay: hoursPerDay)
            context.insert(activity)
            newName = ""
            currentActivity = activity
        }
    }
    
    private func activityAlreadyAdded() -> Bool {
        !activities.contains(where: { activity in
            activity.name.lowercased() == newName.lowercased()
        })
    }
    
    private func editActivityHour(_ newValue: Double) {
        if let index = self.activities.firstIndex(where: { activity in
            activity.name == currentActivity?.name
        }){
            activities[index].hoursPerDay = newValue
        }
    }
    
    private func deleteActivity(at offset: IndexSet) {
        offset.forEach { index in
            let activity = activities[index]
            context.delete(activity)
        }
    }
    
    private func getSelected(value: Int) {
        
    }
    
    private func outterRadiusWhen(_ isSelected: Bool) -> MarkDimension {
        let radius = isSelected ? 1.05 : 0.95
        return .ratio(radius)
    }
    
    private func selectedColorItemBy(name: String) -> Color {
        currentActivity?.name == name ? .blue.opacity(0.3) : .clear
    }
}

#Preview {
    ActivityView()
}
