import SwiftUI

struct FishStatsView: View {
    // Current Food selection
    @State private var selectedFood = 1  // Default to "Low Protein - Spring and Fall"
    
    // Objectives multiple selection
    @State private var improveColor = false
    @State private var generalHealth = true
    @State private var growthAndBreeding = false
    @State private var improvedBehavior = false
    
    // Problems multiple selection
    @State private var aggression = false
    @State private var lowEnergy = true
    @State private var stuntedGrowth = false
    @State private var lackOfAppetite = false
    @State private var obesity = false
    @State private var constantHiding = false
    
    // Age of fish selection
    @State private var selectedAge = 1  // Default to "Adult"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeaderView(
                    title: "FISH STATS",
                    subtitle: "Track your koi's growth and health"
                )
                
                // Current Food Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Food")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(0..<3) { index in
                            Button {
                                selectedFood = index
                            } label: {
                                HStack {
                                    Image(systemName: selectedFood == index ? "circle.fill" : "circle")
                                        .foregroundColor(selectedFood == index ? .accentColor : .gray)
                                    Text(index == 0 ? "High Protein - Summer Food" :
                                        index == 1 ? "Low Protein - Spring and Fall" :
                                        "Not Feeding - Winter")
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                }
                
                // Objectives Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Objectives")
                        .font(.headline)
                    
                    Toggle("Improve color", isOn: $improveColor)
                    Toggle("General health", isOn: $generalHealth)
                    Toggle("Growth and breeding", isOn: $growthAndBreeding)
                    Toggle("Improved behavior", isOn: $improvedBehavior)
                }
                
                // Problems Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Problems")
                        .font(.headline)
                    
                    Toggle("Aggression", isOn: $aggression)
                    Toggle("Low Energy (normal in winter)", isOn: $lowEnergy)
                    Toggle("Stunted Growth", isOn: $stuntedGrowth)
                    Toggle("Lack of appetite", isOn: $lackOfAppetite)
                    Toggle("Obesity or bloating", isOn: $obesity)
                    Toggle("Constant Hiding", isOn: $constantHiding)
                }
                
                // Age of fish Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Age of fish")
                        .font(.headline)
                    
                    Picker("Age", selection: $selectedAge) {
                        Text("Juvenile").tag(0)
                        Text("Adult").tag(1)
                        Text("Mixed").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Fish Stats")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FishStatsView()
} 