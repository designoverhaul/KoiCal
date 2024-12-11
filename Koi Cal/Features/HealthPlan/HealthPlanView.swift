import SwiftUI

struct HealthPlanView: View {
    @StateObject private var xaiService = XAIService()
    @StateObject private var weatherManager = WeatherManager()
    @State private var feedingFrequency = "Loading..."
    @State private var foodType = "Loading..."
    @AppStorage("selectedAge") private var selectedAge = 1
    @AppStorage("selectedObjective") private var selectedObjective = "General health"
    @AppStorage("location") private var location = ""
    @AppStorage("lastFeeding") private var lastFeeding = ""
    
    private func getAgeString() -> String {
        switch selectedAge {
            case 0: return "Juvenile"
            case 1: return "Adult"
            case 2: return "Mixed"
            default: return "Adult"
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
        }
        .task {
            await weatherManager.updateTemperature()
            
            do {
                let recommendations = try await xaiService.getRecommendation(
                    temperature: weatherManager.currentTemperature ?? 0.0,
                    fishAge: getAgeString(),
                    objective: selectedObjective,
                    location: location,
                    feedingHistory: lastFeeding
                )
                feedingFrequency = recommendations.feedingFrequency
                foodType = recommendations.foodType
            } catch {
                print("Error getting recommendations: \(error)")
                feedingFrequency = "Unable to get recommendation"
                foodType = "Unable to get recommendation"
            }
        }
    }
}

#Preview {
    NavigationView {
        HealthPlanView()
    }
} 
