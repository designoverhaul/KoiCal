import SwiftUI

struct HealthPlanView: View {
    @StateObject private var xaiService = XAIService()
    @State private var feedingFrequency = "Loading..."
    @AppStorage("selectedAge") private var selectedAge = 1
    @AppStorage("selectedObjective") private var selectedObjective = "General health"
    @AppStorage("location") private var location = ""
    @AppStorage("temperature") private var temperature: Double = 0.0
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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Feeding Frequency Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("FEEDING FREQUENCY")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                    
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "sparkle")
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
                .background(Color.white)
                .cornerRadius(16)
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Health Plan")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .task {
            do {
                feedingFrequency = try await xaiService.getRecommendation(
                    temperature: temperature,
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
    HealthPlanView()
} 