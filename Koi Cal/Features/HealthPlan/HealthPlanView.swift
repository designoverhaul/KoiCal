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
                    VStack(alignment: .leading, spacing: 6) {
                        Text("FEEDING FREQUENCY")
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
                        
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .foregroundColor(.orange)
                            
                            if xaiService.isLoading {
                                ProgressView()
                                    .tint(.gray)
                            } else {
                                Text(feedingFrequency)
                                    .font(.system(size: 14))
                                    .lineSpacing(21.70)
                                    .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 1.50)
                            .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1.50)
                    )
                    .shadow(
                        color: Color(red: 0.10, green: 0.26, blue: 0.07, opacity: 0.08), 
                        radius: 13, 
                        y: 4
                    )
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
