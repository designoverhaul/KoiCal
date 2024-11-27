import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedAgeGroup: String
    @Binding var selectedObjective: String
    @ObservedObject var feedingData: FeedingData
    @ObservedObject var xaiService: XAIService
    @ObservedObject var weatherManager: WeatherManager
    @ObservedObject var locationManager: LocationManager
    @AppStorage("useCelsius") private var useCelsius = false
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
                        if locationManager.authorizationStatus == .denied {
                            Button("Enable in Settings") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .foregroundColor(.blue)
                        } else {
                            Text(locationManager.cityName)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let error = locationManager.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
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
                
                Section(header: Text("Display Settings")) {
                    Toggle("Show Temperature in Celsius", isOn: $useCelsius)
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
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                let weekHistory = (0...6).map { dayOffset -> (date: Date, count: Int) in
                    let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
                    return (date: date, count: feedingData.getFeedingCount(for: date))
                }
                
                let historyText = weekHistory
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
                
                _ = try await xaiService.getRecommendation(
                    temperature: weatherManager.currentTemperature ?? 70,
                    fishAge: selectedAgeGroup,
                    objective: selectedObjective,
                    location: "Atlanta, Georgia",
                    feedingHistory: historyText
                )
            } catch {
                print("Error updating recommendation: \(error)")
                showingError = true
            }
        }
    }
} 