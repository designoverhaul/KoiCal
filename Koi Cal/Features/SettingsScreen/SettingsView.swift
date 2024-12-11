import SwiftUI

struct SettingsView: View {
    @Binding var selectedAgeGroup: String
    @Binding var selectedObjective: String
    @ObservedObject var feedingData: FeedingData
    @ObservedObject var xaiService: XAIService
    @ObservedObject var weatherManager: WeatherManager
    @ObservedObject var locationManager: LocationManager
    @StateObject private var searchCompleter = LocationSearchCompleter()
    @AppStorage("pondVolume") private var pondVolume = ""
    @AppStorage("sunlightHours") private var sunlightHours = ""
    @AppStorage("location") private var savedLocation = ""
    @State private var searchText = ""
    @FocusState private var isVolumeFieldFocused: Bool
    @FocusState private var isSunlightFieldFocused: Bool
    @FocusState private var isLocationFieldFocused: Bool
    @AppStorage("useMetric") private var useMetric = false
    
    private let ageGroups = ["Juvenile", "Adult", "Mixed"]
    private let foodTypes = ["High Protein", "Cool Season"]
    
    var body: some View {
        NavigationView {
            Form {
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
                
                
                Section("Food") {
                    Picker("Current Food Type", selection: $feedingData.currentFoodType) {
                        ForEach(foodTypes, id: \.self) { food in
                            Text(food).tag(food)
                        }
                    }
                }
                
                Section("Measurements") {
                    Picker("Measurement System", selection: $useMetric) {
                        Text("Imperial").tag(false)
                        Text("Metric").tag(true)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How many \(volumeLabel.lowercased()) is your pond?")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "565656"))
                        
                        TextField(volumeLabel, text: $pondVolume)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .focused($isVolumeFieldFocused)
                            .onChange(of: pondVolume) { oldValue, newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered != newValue {
                                    pondVolume = filtered
                                }
                                if let number = Int(filtered) {
                                    pondVolume = number.formatted(.number)
                                }
                            }
                        
                        Text("How many hours of direct sunlight does your pond get per day?")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "565656"))
                        
                        TextField("Hours", text: $sunlightHours)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .focused($isSunlightFieldFocused)
                        
                        Text("Where is your pond located?")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "565656"))
                        
                        TextField("Enter location", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .focused($isLocationFieldFocused)
                            .onChange(of: searchText) { oldValue, newValue in
                                if newValue.count > 2 {
                                    searchCompleter.search(query: newValue)
                                }
                            }
                        
                        if !searchCompleter.suggestions.isEmpty && searchText.count > 2 && isLocationFieldFocused {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(searchCompleter.suggestions, id: \.self) { suggestion in
                                    Button(action: {
                                        savedLocation = suggestion.title
                                        searchText = suggestion.title
                                        isLocationFieldFocused = false
                                        Task {
                                            await weatherManager.updateTemperature()
                                        }
                                    }) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(suggestion.title)
                                                .foregroundColor(.primary)
                                            Text(suggestion.subtitle)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.vertical, 8)
                                    
                                    if suggestion != searchCompleter.suggestions.last {
                                        Divider()
                                    }
                                }
                            }
                            .padding(8)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isVolumeFieldFocused = false
                        isSunlightFieldFocused = false
                        isLocationFieldFocused = false
                    }
                }
            }
            .onChange(of: selectedAgeGroup) { _, _ in
                updateRecommendation()
            }
            .onChange(of: selectedObjective) { _, _ in
                updateRecommendation()
            }
            .onChange(of: feedingData.currentFoodType) { _, _ in
                updateRecommendation()
            }
            .onChange(of: useMetric) { oldValue, newValue in
                if !pondVolume.isEmpty {
                    let cleanVolume = pondVolume.replacingOccurrences(of: ",", with: "")
                    if let volume = Double(cleanVolume) {
                        let converted: Double
                        if newValue {
                            converted = volume * 3.78541
                        } else {
                            converted = volume / 3.78541
                        }
                        pondVolume = Int(converted).formatted(.number)
                    }
                }
            }
        }
    }
    
    private func updateRecommendation() {
        Task {
            if let temperature = weatherManager.currentTemperature {
                _ = try? await xaiService.getRecommendation(
                    temperature: temperature,
                    fishAge: selectedAgeGroup,
                    objective: selectedObjective,
                    location: locationManager.cityName,
                    feedingHistory: getFeedingHistory()
                )
                print("✅ Updated recommendation after settings change")
            }
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
    
    private var volumeLabel: String {
        useMetric ? "Liters" : "Gallons"
    }
} 


