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
    @AppStorage("lowEnergy") private var lowEnergy = false
    @AppStorage("stuntedGrowth") private var stuntedGrowth = false
    @AppStorage("lackOfAppetite") private var lackOfAppetite = false
    @AppStorage("obesity") private var obesity = false
    @AppStorage("constantHiding") private var constantHiding = false
    
    // Water Clarity selection
    @AppStorage("waterClarity") private var selectedWaterClarity = 0  // 0: None, 1: Green, 2: Black/Dark, 3: Cloudy
    
    @State private var showMaxConcernsAlert = false
    
    private var selectedConcernsCount: Int {
        [sicknessOrDeath, lowEnergy, stuntedGrowth, lackOfAppetite, obesity, constantHiding]
            .filter { $0 }
            .count
    }
    
    private func handleConcernToggle(_ isOn: Bool, for binding: Binding<Bool>) {
        if isOn && selectedConcernsCount >= 2 {
            showMaxConcernsAlert = true
        } else {
            binding.wrappedValue = isOn
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Get full-picture advice for these issues based on your unique fish, climate, and pond conditions.")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Objectives Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Swimprovements")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Improve color", isOn: $improveColor)
                            Toggle("Growth and breeding", isOn: $growthAndBreeding)
                            Toggle("Improved behavior", isOn: $improvedBehavior)
                        }
                    }
                    
                    // Problems Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Concerns")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Sickness or Death", isOn: Binding(
                                get: { sicknessOrDeath },
                                set: { handleConcernToggle($0, for: $sicknessOrDeath) }
                            ))
                            Toggle("Low Energy (normal in winter)", isOn: Binding(
                                get: { lowEnergy },
                                set: { handleConcernToggle($0, for: $lowEnergy) }
                            ))
                            Toggle("Stunted Growth", isOn: Binding(
                                get: { stuntedGrowth },
                                set: { handleConcernToggle($0, for: $stuntedGrowth) }
                            ))
                            Toggle("Lack of appetite", isOn: Binding(
                                get: { lackOfAppetite },
                                set: { handleConcernToggle($0, for: $lackOfAppetite) }
                            ))
                            Toggle("Obesity or bloating", isOn: Binding(
                                get: { obesity },
                                set: { handleConcernToggle($0, for: $obesity) }
                            ))
                            Toggle("Constant Hiding", isOn: Binding(
                                get: { constantHiding },
                                set: { handleConcernToggle($0, for: $constantHiding) }
                            ))
                        }
                    }
                    
                    // Water Clarity Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Water Clarity Issues")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
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
        .navigationTitle("🎯 Goals")
        .navigationBarTitleDisplayMode(.large)
        .alert("Only two concerns can be selected at a time", isPresented: $showMaxConcernsAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    NavigationView {
        GoalsView()
    }
}
