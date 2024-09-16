import SwiftUI

struct ActivityRow: View {
    let activity: ActivityModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.name)
                    .font(.title)
                Text(hoursPerdayBuilder())
            }
            Spacer()
        }
    }
    
    private func hoursPerdayBuilder() -> String {
        "Hours per day: \(activity.hoursPerDay.formatted())"
    }
}

#Preview {
    ActivityRow(activity: .init(name: "Eat weco", hoursPerDay: 2))
}
