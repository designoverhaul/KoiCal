import SwiftUI

struct FishProblemsView: View {
    @AppStorage("improveColor") private var improveColor = false
    @AppStorage("growthAndBreeding") private var growthAndBreeding = false
    @AppStorage("improvedBehavior") private var improvedBehavior = false
    
    @AppStorage("sicknessOrDeath") private var sicknessOrDeath = false
    @AppStorage("lowEnergy") private var lowEnergy = false
    @AppStorage("stuntedGrowth") private var stuntedGrowth = false
    @AppStorage("lackOfAppetite") private var lackOfAppetite = false
    @AppStorage("obesity") private var obesity = false
    @AppStorage("constantHiding") private var constantHiding = false
    
    @AppStorage("waterClarity") private var selectedWaterClarity = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    Text("Anything we should work on with your pond?")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .padding(.top, 80)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Swimprovements")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Toggle("Improve color", isOn: $improveColor)
                            Toggle("Growth and breeding", isOn: $growthAndBreeding)
                            Toggle("Improved behavior", isOn: $improvedBehavior)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Concerns")
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
                    .padding(.horizontal, 20)
                    
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
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            
            NavigationLink {
                ColorEncouragementView()
            } label: {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
            }
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
        }
        .edgesIgnoringSafeArea(.bottom)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        FishProblemsView()
    }
}
