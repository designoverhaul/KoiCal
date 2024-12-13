import SwiftUI

struct GoalsView: View {
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
    
    // Water Clarity selection
    @AppStorage("waterClarity") private var selectedWaterClarity = 0  // 0: None, 1: Green, 2: Black/Dark, 3: Cloudy
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 24) {
                    
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
                    
                    // Water Clarity Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Are you having water clarity issues?")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "565656"))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(0..<4) { index in
                                Button {
                                    selectedWaterClarity = index
                                } label: {
                                    HStack {
                                        Image(systemName: selectedWaterClarity == index ? "circle.fill" : "circle")
                                            .foregroundColor(selectedWaterClarity == index ? .accentColor : .gray)
                                        Text(index == 0 ? "None" :
                                                index == 1 ? "Green water" :
                                                index == 2 ? "Black or dark water" :
                                                "Cloudy water")
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Bottom padding
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.large)
    }
}
