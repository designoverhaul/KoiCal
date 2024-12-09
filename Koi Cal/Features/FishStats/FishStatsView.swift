import SwiftUI

struct FishStatsView: View {
    // Current Food selection
    @AppStorage("selectedFood") private var selectedFood = 1  // Default to "Low Protein - Spring and Fall"
    
    // Objectives multiple selection
    @AppStorage("improveColor") private var improveColor = false
    @AppStorage("growthAndBreeding") private var growthAndBreeding = false
    @AppStorage("improvedBehavior") private var improvedBehavior = false
    
    // Problems multiple selection
    @AppStorage("sicknessOrDeath") private var sicknessOrDeath = false
    @AppStorage("lowEnergy") private var lowEnergy = true
    @AppStorage("stuntedGrowth") private var stuntedGrowth = false
    @AppStorage("lackOfAppetite") private var lackOfAppetite = false
    @AppStorage("obesity") private var obesity = false
    @AppStorage("constantHiding") private var constantHiding = false
    
    // Age of fish selection
    @AppStorage("selectedAge") private var selectedAge = 1  // Default to "Adult"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HeaderView(
                    title: "FISH STATS",
                    subtitle: "Track your koi's growth and health"
                )
                
                VStack(alignment: .leading, spacing: 24) {
                    // Current Food Section
                    VStack(alignment: .leading, spacing: 12) {
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
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Objectives")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Improve color", isOn: $improveColor)
                            Toggle("Growth and breeding", isOn: $growthAndBreeding)
                            Toggle("Improved behavior", isOn: $improvedBehavior)
                        }
                    }
                    
                    // Problems Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Problems")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Sickness or Death", isOn: $sicknessOrDeath)
                            Toggle("Low Energy (normal in winter)", isOn: $lowEnergy)
                            Toggle("Stunted Growth", isOn: $stuntedGrowth)
                            Toggle("Lack of appetite", isOn: $lackOfAppetite)
                            Toggle("Obesity or bloating", isOn: $obesity)
                            Toggle("Constant Hiding", isOn: $constantHiding)
                        }
                    }
                    
                    // Age of fish Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Age of fish")
                            .font(.headline)
                        
                        Picker("Age", selection: $selectedAge) {
                            Text("Juvenile").tag(0)
                            Text("Adult").tag(1)
                            Text("Mixed").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Bottom padding
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
        }
        .navigationTitle("Fish Stats")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FishStatsView()
} 