import SwiftUI

struct GoalsView: View {
    // Current Food selection
    @AppStorage("selectedFood") private var selectedFood = 1  // Default to "Low Protein - Spring and Fall"
    
    // Rest of the code remains the same...
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Rest of the view code remains the same...
            }
        }
        .navigationTitle("Goals")  // Updated title
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    GoalsView()  // Updated preview
} 