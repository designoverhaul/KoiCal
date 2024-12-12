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
    
    init() {
        print("\n=== 🏗️ HealthPlanView initialized ===")
        _xaiService = StateObject(wrappedValue: XAIService())
        _weatherManager = StateObject(wrappedValue: WeatherManager())
        print("✅ Services initialized")
    }
    
    private func getAgeString() -> String {
        switch selectedAge {
            case 0: return "Juvenile"
            case 1: return "Adult"
            case 2: return "Mixed"
            default: return "Adult"
        }
    }
    
    private func updateRecommendations() async {
        print("🔄 STEP 1: Starting updateRecommendations()")
        
        print("🌡️ STEP 2: Current temperature: \(weatherManager.currentTemperature ?? -999)")
        print("📍 STEP 3: Location: \(location)")
        print("🐟 STEP 4: Fish age: \(getAgeString())")
        print("🏊‍♂️ STEP 5: Pond volume: \(pondVolume)")
        
        guard let temperature = weatherManager.currentTemperature else {
            print("❌ ERROR: No temperature available")
            return
        }
        
        print("✅ STEP 6: About to call XAI service")
        
        do {
            let recommendations = try await xaiService.getRecommendation(
                temperature: temperature,
                fishAge: getAgeString(),
                improveColor: improveColor,
                growthAndBreeding: growthAndBreeding,
                improvedBehavior: improvedBehavior,
                sicknessDeath: sicknessOrDeath,
                lowEnergy: lowEnergy,
                stuntedGrowth: stuntedGrowth,
                lackAppetite: lackOfAppetite,
                obesityBloating: obesity,
                constantHiding: constantHiding,
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
                    Text("Debug Info:")
                        .font(.caption)
                    Text("Temperature: \(weatherManager.currentTemperature?.description ?? "none")")
                        .font(.caption)
                    Text("Location: \(location)")
                        .font(.caption)
                    
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
                        content: "72°F",
                        showSparkle: false
                    )
                    
                    // More sections...
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .navigationTitle("Health Plan")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                print("\n=== 👀 HealthPlanView appeared ===")
            }
            .task {
                print("\n=== 🚀 HealthPlanView task started ===")
                print("Getting weather...")
                await weatherManager.updateTemperature()
                print("Weather updated, getting recommendations...")
                await updateRecommendations()
                print("Task completed")
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
