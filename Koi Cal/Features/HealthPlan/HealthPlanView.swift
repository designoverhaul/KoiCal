import SwiftUI

struct HealthPlanView: View {
    @StateObject private var xaiService = XAIService()
    @StateObject private var weatherManager = WeatherManager()
    @EnvironmentObject private var feedingData: FeedingData
    @EnvironmentObject private var waterQualityManager: WaterQualityManager
    @State private var feedingFrequency = "Loading..."
    @State private var foodType = "Loading..."
    @State private var pondReport = "Loading..."
    @AppStorage("fishSize") private var fishSize = FishSize.medium.rawValue
    @AppStorage("fishCount") private var fishCount = ""
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
    
    @State private var concernRecommendations: [String: String] = [:]
    
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
    
    private func getSelectedIssues() -> ([String], [String]) {
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
    
    private func getWaterClarityText() -> String {
        switch waterClarity {
        case 1: return "🟢 Green Water"
        case 2: return "⚫ Black or dark water"
        case 3: return "☁️ Cloudy water"
        default: return ""
        }
    }
    
    private func getWaterClarityTitle() -> String {
        switch waterClarity {
        case 1: return "Green Water 🟢"
        case 2: return "Black or Dark Water "
        case 3: return "Cloudy Water ☁️"
        default: return ""
        }
    }
    
    private func getFeedingHistory() -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekHistory = (0...6).map { dayOffset -> (date: Date, count: Int) in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            return (date: date, count: feedingData.getFeedingCount(for: date))
        }
        
        return weekHistory
            .map { date, count in
                let dayString: String
                if calendar.isDateInToday(date) {
                    dayString = "today"
                } else if calendar.isDateInYesterday(date) {
                    dayString = "yesterday"
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEE"
                    dayString = formatter.string(from: date).lowercased()
                }
                return "\(count) times \(dayString)"
            }
            .joined(separator: ", ")
    }
    
    private func updateRecommendations() async {
        guard let temperature = weatherManager.currentTemperature else {
            print("❌ No temperature available for recommendations")
            return
        }
        
        do {
            let (selectedGoals, selectedProblems) = getSelectedIssues()
            
            // Debug print current measurements
            print("\n🔍 Current Water Quality Measurements:")
            print("Nitrate: \(waterQualityManager.measurements[.nitrate] ?? 0)")
            print("Nitrite: \(waterQualityManager.measurements[.nitrite] ?? 0)")
            print("pH: \(waterQualityManager.measurements[.pH] ?? 0)")
            print("KH: \(waterQualityManager.measurements[.kh] ?? 0)")
            print("GH: \(waterQualityManager.measurements[.gh] ?? 0)")
            print("Fish Size: \(fishSize == FishSize.small.rawValue ? "Small" : fishSize == FishSize.medium.rawValue ? "Medium" : "Large")")
            
            let waterTestString = """
                Nitrate: \(waterQualityManager.measurements[.nitrate].map { "\(Int($0))" } ?? "Not tested") mg/L
                Nitrite: \(waterQualityManager.measurements[.nitrite].map { String(format: "%.1f", $0) } ?? "Not tested") mg/L
                pH: \(waterQualityManager.measurements[.pH].map { String(format: "%.1f", $0) } ?? "Not tested")
                KH: \(waterQualityManager.measurements[.kh].map { "\(Int($0))" } ?? "Not tested") ppm
                GH: \(waterQualityManager.measurements[.gh].map { "\(Int($0))" } ?? "Not tested") ppm
                """
            
            print("\n📝 Water Test String being sent:")
            print(waterTestString)
            
            let recommendations = try await xaiService.getRecommendation(
                temperature: temperature,
                fishAge: getAgeString(),
                fishSize: fishSize == FishSize.small.rawValue ? "Small" : 
                         fishSize == FishSize.medium.rawValue ? "Medium" : "Large",
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
                waterTest: waterTestString,
                pondSize: pondVolume,
                fishCount: fishCount.isEmpty ? "Not specified" : fishCount,
                feedingHistory: getFeedingHistory(),
                waterClarity: waterClarity,
                waterClarityText: getWaterClarityText()
            )
            
            DispatchQueue.main.async {
                self.feedingFrequency = recommendations.feedingFrequency
                self.foodType = recommendations.foodType
                self.pondReport = recommendations.pondReport
                self.concernRecommendations = recommendations.concernRecommendations
            }
        } catch {
            print("❌ Recommendation error: \(error)")
            DispatchQueue.main.async {
                self.feedingFrequency = "Error getting recommendation"
                self.foodType = "Error getting recommendation"
                self.pondReport = "Error getting recommendation"
            }
        }
    }
    
    private func formatTemperature(_ fahrenheit: Double) -> String {
        if useMetric {
            let celsius = (fahrenheit - 32) * 5/9
            return String(format: "%.0f°C", celsius)
        } else {
            return String(format: "%.0f°F", fahrenheit)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Generate Health Plan Button
                Button {
                    Task {
                        print("🔄 Generating new health plan...")
                        await updateRecommendations()
                    }
                } label: {
                    Text("Get New Plan")
                        .font(.headline)
                        .foregroundColor(Color(hex: "F18833"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "FFEDDA"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "F18833"), lineWidth: 1)
                        )
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
                
                // Rest of content
                VStack(spacing: 0) {
                    // Feeding Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "fork.knife")
                                .foregroundColor(Color(hex: "F18833"))
                                .font(.title3)
                            
                            Text("Feeding")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        
                        InfoCardView(
                            title: "Food Type",
                            content: foodType,
                            showSparkle: true
                        )
                        
                        InfoCardView(
                            title: "Feeding Frequency",
                            content: feedingFrequency,
                            showSparkle: true
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Water Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "water.waves")
                                .foregroundColor(Color(hex: "F18833"))
                                .font(.title3)
                            
                            Text("Water")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        
                        InfoCardView(
                            title: "Pond Report",
                            content: pondReport,
                            showSparkle: true
                        )
                        
                        if waterClarity > 0 {
                            InfoCardView(
                                title: getWaterClarityTitle(),
                                content: concernRecommendations[getWaterClarityText()] ?? "Loading...",
                                showSparkle: true
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Fish Concerns Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "cross.case.fill")
                                .foregroundColor(Color(hex: "F18833"))
                                .font(.title3)
                            
                            Text("Fish Concerns")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        
                        if !sicknessOrDeath && !lowEnergy && !stuntedGrowth && 
                           !lackOfAppetite && !obesity && !constantHiding {
                            InfoCardView(
                                title: "",
                                content: "None 👍",
                                showSparkle: false
                            )
                        }
                        
                        if sicknessOrDeath {
                            InfoCardView(
                                title: "Sickness or Death",
                                content: concernRecommendations["Sickness or death"] ?? "Loading...",
                                showSparkle: true
                            )
                        }
                        
                        if lowEnergy {
                            InfoCardView(
                                title: "Low Energy",
                                content: concernRecommendations["Low energy"] ?? "Loading...",
                                showSparkle: true
                            )
                        }
                        
                        if stuntedGrowth {
                            InfoCardView(
                                title: "Stunted Growth",
                                content: concernRecommendations["Stunted growth"] ?? "Loading...",
                                showSparkle: true
                            )
                        }
                        
                        if lackOfAppetite {
                            InfoCardView(
                                title: "Lack of Appetite",
                                content: concernRecommendations["Lack of appetite"] ?? "Loading...",
                                showSparkle: true
                            )
                        }
                        
                        if obesity {
                            InfoCardView(
                                title: "Obesity or Bloating",
                                content: concernRecommendations["Obesity/bloating"] ?? "Loading...",
                                showSparkle: true
                            )
                        }
                        
                        if constantHiding {
                            InfoCardView(
                                title: "Constant Hiding",
                                content: concernRecommendations["Constant hiding"] ?? "Loading...",
                                showSparkle: true
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Bottom padding
                    Spacer()
                        .frame(height: 100)
                }
            }
            .padding(.top, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("✨ Health Plan")
        .navigationBarTitleDisplayMode(.large)
        .task {
            // Only get temperature on initial load
            await weatherManager.updateTemperature()
            
            // Only get initial recommendations if we don't have any yet
            if feedingFrequency == "Loading..." {
                await updateRecommendations()
            }
        }
    }
}

#Preview("Health Plan") {
    NavigationView {
        HealthPlanView()
            .environmentObject(WaterQualityManager())
            .environmentObject(FeedingData())
    }
} 
