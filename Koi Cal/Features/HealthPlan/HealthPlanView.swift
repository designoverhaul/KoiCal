import SwiftUI

struct HealthPlanView: View {
    @StateObject private var xaiService = XAIService()
    @StateObject private var weatherManager = WeatherManager()
    @State private var feedingFrequency = "Loading..."
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
                VStack(alignment: .leading, spacing: 24) {
                    HeaderView(
                        title: "HEALTH PLAN",
                        subtitle: "Personalized care recommendations"
                    )
                    
                    // Feeding Frequency Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("FEEDING FREQUENCY")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: "sparkles")
                                .foregroundColor(.orange)
                            
                            if xaiService.isLoading {
                                ProgressView()
                                    .tint(.gray)
                            } else {
                                Text(feedingFrequency)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(24)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, 16)
            }
            
            
           
        }
        .task {
            await weatherManager.updateTemperature()
            
            do {
                feedingFrequency = try await xaiService.getRecommendation(
                    temperature: weatherManager.currentTemperature ?? 0.0,
                    fishAge: getAgeString(),
                    objective: selectedObjective,
                    location: location,
                    feedingHistory: lastFeeding
                )
            } catch {
                feedingFrequency = "Twice a week, once a day"
                print("Error getting recommendation: \(error)")
            }
        }
    }
}

#Preview {
    NavigationView {
        HealthPlanView()
    }
} 
