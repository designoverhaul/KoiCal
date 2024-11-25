import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedAgeGroup: String
    @Binding var selectedObjective: String
    @ObservedObject var feedingData: FeedingData
    @ObservedObject var xaiService: XAIService
    @ObservedObject var weatherManager: WeatherManager
    @State private var showingError = false
    
    let ageGroups = ["Juvenile", "Adult", "Mixed"]
    let objectives = ["Improved Color", "General Health", "Growth and Breeding", "Improved Behavior"]
    let foodTypes = ["High Protein", "Cool Season"]
    
    var body: some View {
        NavigationView {
            List {
                Section("Location") {
                    HStack {
                        Text("Pond Location")
                        Spacer()
                        Text("Atlanta, Georgia")
                            .foregroundColor(.gray)
                    }
                }
                
                Section("Fish Details") {
                    Picker("Age of Fish", selection: $selectedAgeGroup) {
                        ForEach(ageGroups, id: \.self) { age in
                            Text(age).tag(age)
                        }
                    }
                }
                
                Section("Goals") {
                    Picker("Primary Objective", selection: $selectedObjective) {
                        ForEach(objectives, id: \.self) { objective in
                            Text(objective).tag(objective)
                        }
                    }
                }
                
                Section("Food") {
                    Picker("Current Food Type", selection: $feedingData.currentFoodType) {
                        ForEach(foodTypes, id: \.self) { food in
                            Text(food).tag(food)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .presentationDetents([.height(380)])
            .onChange(of: selectedAgeGroup) { _, _ in
                updateRecommendation()
            }
            .onChange(of: selectedObjective) { _, _ in
                updateRecommendation()
            }
            .onChange(of: feedingData.currentFoodType) { _, _ in
                updateRecommendation()
            }
        }
    }
    
    private func updateRecommendation() {
        Task {
            do {
                _ = try await xaiService.getRecommendation(
                    temperature: weatherManager.currentTemperature ?? 70,
                    fishAge: selectedAgeGroup,
                    objective: selectedObjective,
                    foodType: feedingData.currentFoodType,
                    location: "Atlanta, Georgia"
                )
            } catch {
                print("Error updating recommendation: \(error)")
                showingError = true
            }
        }
    }
} 