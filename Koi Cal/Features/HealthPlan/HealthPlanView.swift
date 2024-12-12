import SwiftUI

struct HealthPlanView: View {
    @StateObject private var xaiService = XAIService()
    @StateObject private var weatherManager = WeatherManager()
    @State private var feedingFrequency = "Loading..."
    @State private var foodType = "Loading..."
    @State private var pondReport = "Loading..."
    @AppStorage("selectedAge") private var selectedAge = 1
    @AppStorage("selectedObjective") private var selectedObjective = "General health"
    @AppStorage("location") private var location = ""
    @AppStorage("lastFeeding") private var lastFeeding = ""
    @AppStorage("improveColor") private var improveColor = false
    @AppStorage("growthAndBreeding") private var growthAndBreeding = false
    @AppStorage("improvedBehavior") private var improvedBehavior = false
    @AppStorage("sicknessOrDeath") private var sicknessOrDeath = false
    @AppStorage("lowEnergy") private var lowEnergy = false
    @AppStorage("stuntedGrowth") private var stuntedGrowth = false
    @AppStorage("lackOfAppetite") private var lackOfAppetite = false
    @AppStorage("obesity") private var obesity = false
    @AppStorage("constantHiding") private var constantHiding = false
    @AppStorage("pondVolume") private var pondVolume = ""
    @AppStorage("useMetric") private var useMetric = false
    @AppStorage("currentFoodType") private var currentFoodType = "High Protein"
    @AppStorage("sunlightHours") private var sunlightHours = ""
    @AppStorage("circulationTime") private var circulationTime = ""
    @AppStorage("waterClarity") private var waterClarity = 0 // 0: None, 1: Green, 2: Black/Dark, 3: Cloudy
    @AppStorage("pH") private var pH = 8.0
    @AppStorage("kh") private var kh = 40.0
    
    #if DEBUG
    private static var hasLogged = false
    #endif
    
    init() {
        #if DEBUG
        // Only log once in debug builds
        if !HealthPlanView.hasLogged {
            print("🏗️ HealthPlanView initialized")
            HealthPlanView.hasLogged = true
        }
        #endif
        
        _xaiService = StateObject(wrappedValue: XAIService())
        _weatherManager = StateObject(wrappedValue: WeatherManager())
    }
    
    private func getAgeString() -> String {
        switch selectedAge {
            case 0: return "Juvenile"
            case 1: return "Adult"
            case 2: return "Mixed"
            default: return "Adult"
        }
    }
    
    private func getSelectedIssues() -> (goals: [String], problems: [String]) {
        var selectedGoals: [String] = []
        var selectedProblems: [String] = []
        
        // Collect selected goals
        if improveColor { selectedGoals.append("Improve color") }
        if growthAndBreeding { selectedGoals.append("Growth and breeding") }
        if improvedBehavior { selectedGoals.append("Improved behavior") }
        
        // Collect selected problems
        if sicknessOrDeath { selectedProblems.append("Sickness or death") }
        if lowEnergy { selectedProblems.append("Low energy") }
        if stuntedGrowth { selectedProblems.append("Stunted growth") }
        if lackOfAppetite { selectedProblems.append("Lack of appetite") }
        if obesity { selectedProblems.append("Obesity/bloating") }
        if constantHiding { selectedProblems.append("Constant hiding") }
        
        return (selectedGoals, selectedProblems)
    }
    
    private func getWaterClarityIssue() -> String? {
        switch waterClarity {
        case 1: return "Green water"
        case 2: return "Black or dark water"
        case 3: return "Cloudy water"
        default: return nil
        }
    }
    
    private func updateRecommendations() async {
        guard let temperature = weatherManager.currentTemperature else {
            print("❌ No temperature available for recommendations")
            return
        }
        
        do {
            let (selectedGoals, selectedProblems) = getSelectedIssues()
            
            print("\n📊 Settings:")
            print("Temperature: \(Int(temperature)) °F")
            print("Location: \(location)")
            print("Fish Age: \(getAgeString())")
            print("Pond Volume: \(pondVolume)")
            print("Current Food Type: \(currentFoodType)")
            print("Measurements: \(useMetric ? "Metric" : "Imperial")")
            print("Hours of Direct Sunlight: \(sunlightHours)")
            print("Circulation Time: \(circulationTime) seconds")
            
            if !selectedGoals.isEmpty {
                print("\n🎯 Selected Goals:")
                selectedGoals.forEach { print("✅ \($0)") }
            }
            
            if !selectedProblems.isEmpty {
                print("\n⚠️ Reported Problems:")
                selectedProblems.forEach { print("✅ \($0)") }
            }
            
            if let clarityIssue = getWaterClarityIssue() {
                print("\nWater Clarity Issues:")
                print("✅ \(clarityIssue)")
            }
            
            print("\n💧 Water Test:")
            print("pH: \(String(format: "%.1f", pH))")
            print("KH Carbonate Hardness: \(Int(kh))")
            
            let recommendations = try await xaiService.getRecommendation(
                temperature: temperature,
                fishAge: getAgeString(),
                improveColor: selectedGoals.contains("Improve color"),
                growthAndBreeding: selectedGoals.contains("Growth and breeding"),
                improvedBehavior: selectedGoals.contains("Improved behavior"),
                sicknessDeath: selectedProblems.contains("Sickness or death"),
                lowEnergy: selectedProblems.contains("Low energy"),
                stuntedGrowth: selectedProblems.contains("Stunted growth"),
                lackAppetite: selectedProblems.contains("Lack of appetite"),
                obesityBloating: selectedProblems.contains("Obesity/bloating"),
                constantHiding: selectedProblems.contains("Constant hiding"),
                location: location,
                waterTest: "pH: 7.0, Nitrate: 0, Nitrite: 0",
                pondSize: pondVolume,
                fishCount: "5",
                feedingHistory: lastFeeding
            )
            
            feedingFrequency = recommendations.feedingFrequency
            foodType = recommendations.foodType
            pondReport = recommendations.pondReport
        } catch {
            print("❌ Recommendation error: \(error)")
            feedingFrequency = "Error getting recommendation"
            foodType = "Error getting recommendation"
            pondReport = "Error getting recommendation"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // Food Type Section
                    InfoCardView(
                        title: "Food Type",
                        content: foodType,
                        showSparkle: true
                    )
                    
                    // Feeding Frequency Section
                    InfoCardView(
                        title: "Feeding Frequency",
                        content: feedingFrequency,
                        showSparkle: true
                    )
                    
                    // Pond Report Section
                    InfoCardView(
                        title: "Pond Report",
                        content: pondReport,
                        showSparkle: true
                    )
                    
                    // Water Temperature Section
                    InfoCardView(
                        title: "Water Temperature",
                        content: "\(Int(weatherManager.currentTemperature ?? 0))°F",
                        showSparkle: false
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .navigationTitle("Health Plan")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await weatherManager.updateTemperature()
                await updateRecommendations()
            }
            .refreshable {
                await updateRecommendations()
            }
        }
    }
}

#Preview {
    NavigationView {
        HealthPlanView()
    }
    .previewDisplayName("Health Plan")
} 
