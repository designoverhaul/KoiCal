import SwiftUI
import Foundation
import MapKit

struct SettingsView: View {
    @ObservedObject var feedingData: FeedingData
    @ObservedObject var xaiService: XAIService
    @ObservedObject var weatherManager: WeatherManager
    @ObservedObject var locationManager: LocationManager
    @StateObject private var searchCompleter = LocationSearchCompleter()
    @AppStorage("pondVolume") private var pondVolume = ""
    @AppStorage("sunlightHours") private var sunlightHours = ""
    @AppStorage("location") private var savedLocation = ""
    @AppStorage("circulationTime") private var circulationTime = ""
    @State private var searchText = ""
    @FocusState private var isVolumeFieldFocused: Bool
    @FocusState private var isSunlightFieldFocused: Bool
    @FocusState private var isLocationFieldFocused: Bool
    @FocusState private var isCirculationFieldFocused: Bool
    @AppStorage("useMetric") private var useMetric = false
    @State private var updateTimer: Timer?
    @AppStorage("fishSize") private var fishSize = FishSize.medium.rawValue
    @AppStorage("fishCount") private var fishCount = ""
    @FocusState private var isFishCountFieldFocused: Bool
    @AppStorage("improveColor") private var improveColor = false
    @AppStorage("growthAndBreeding") private var growthAndBreeding = false
    @AppStorage("improvedBehavior") private var improvedBehavior = false
    @AppStorage("sicknessOrDeath") private var sicknessOrDeath = false
    @AppStorage("lowEnergy") private var lowEnergy = false
    @AppStorage("stuntedGrowth") private var stuntedGrowth = false
    @AppStorage("lackOfAppetite") private var lackOfAppetite = false
    @AppStorage("obesity") private var obesity = false
    @AppStorage("constantHiding") private var constantHiding = false
    @AppStorage("waterClarity") private var waterClarity = 0
    @AppStorage("selectedAgeGroup") private var selectedAgeGroup = "Mixed"
    @EnvironmentObject var waterQualityManager: WaterQualityManager
    
    private let ageGroups = ["Juvenile", "Adult", "Mixed"]
    private let foodTypes = ["High Protein", "Cool Season"]
    
    var body: some View {
        Form {
            Section("Food") {
                Picker("Current Food Type", selection: $feedingData.currentFoodType) {
                    ForEach(foodTypes, id: \.self) { food in
                        Text(food).tag(food)
                    }
                }
            }
            
            Section("Fish Information") {
                Picker("Average fish size", selection: $fishSize) {
                    ForEach(FishSize.allCases, id: \.rawValue) { size in
                        Text(size.rawValue).tag(size.rawValue)
                    }
                }
                
                Picker("Age of Fish", selection: $selectedAgeGroup) {
                    ForEach(ageGroups, id: \.self) { age in
                        Text(age).tag(age)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("How many fish are in your pond?")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "565656"))
                    
                    TextField("Number of fish", text: $fishCount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($isFishCountFieldFocused)
                        .onChange(of: fishCount) { oldValue, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue {
                                fishCount = filtered
                            }
                            if let number = Int(filtered) {
                                fishCount = number.formatted(.number)
                            }
                        }
                }
            }
            
            Section("Pond Information") {
                VStack(alignment: .leading, spacing: 12) {
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
                            savedLocation = newValue
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
                    
                    Text("How many seconds does it take your water circulation to fill a \(circulationLabel)?")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "565656"))
                    
                    TextField("Seconds", text: $circulationTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($isCirculationFieldFocused)
                        .onChange(of: circulationTime) { oldValue, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue {
                                circulationTime = filtered
                            }
                        }
                }
            }
            
            Section {
                Picker("Measurement System", selection: $useMetric) {
                    Text("Imperial").tag(false)
                    Text("Metric").tag(true)
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("⚙️ Settings")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isVolumeFieldFocused = false
                    isSunlightFieldFocused = false
                    isLocationFieldFocused = false
                    isCirculationFieldFocused = false
                    isFishCountFieldFocused = false
                }
            }
        }
        .onChange(of: selectedAgeGroup) { _, _ in
            debounceUpdate()
        }
        .onChange(of: feedingData.currentFoodType) { _, _ in
            debounceUpdate()
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
        .onAppear {
            searchText = savedLocation
        }
    }
    
    private func updateRecommendation() {
        Task {
            if let temperature = weatherManager.currentTemperature {
                do {
                    _ = try await xaiService.getRecommendation(
                        temperature: temperature,
                        fishAge: selectedAgeGroup,
                        fishSize: fishSize == FishSize.small.rawValue ? "Small" : 
                                 fishSize == FishSize.medium.rawValue ? "Medium" : "Large",
                        improveColor: improveColor,
                        growthAndBreeding: growthAndBreeding,
                        improvedBehavior: improvedBehavior,
                        sicknessDeath: sicknessOrDeath,
                        lowEnergy: lowEnergy,
                        stuntedGrowth: stuntedGrowth,
                        lackAppetite: lackOfAppetite,
                        obesityBloating: obesity,
                        constantHiding: constantHiding,
                        location: locationManager.cityName,
                        waterTest: getWaterTestString(),
                        pondSize: pondVolume,
                        fishCount: fishCount,
                        feedingHistory: getFeedingHistory(),
                        waterClarity: waterClarity,
                        waterClarityText: getWaterClarityText(),
                        useMetric: useMetric
                    )
                } catch {
                    print("❌ Failed to update recommendation: \(error)")
                }
            } else {
                print("❌ No temperature available for recommendation")
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
    
    private func getWaterTestString() -> String {
        return """
            Nitrate: \(waterQualityManager.measurements[.nitrate].map { "\(Int($0))" } ?? "Not tested") mg/L
            Nitrite: \(waterQualityManager.measurements[.nitrite].map { String(format: "%.1f", $0) } ?? "Not tested") mg/L
            pH: \(waterQualityManager.measurements[.pH].map { String(format: "%.1f", $0) } ?? "Not tested")
            KH: \(waterQualityManager.measurements[.kh].map { "\(Int($0))" } ?? "Not tested") ppm
            GH: \(waterQualityManager.measurements[.gh].map { "\(Int($0))" } ?? "Not tested") ppm
            """
    }
    
    private func getWaterClarityText() -> String {
        switch waterClarity {
        case 1: return "🟢 Green Water"
        case 2: return "⚫ Black or dark water"
        case 3: return "☁️ Cloudy water"
        default: return ""
        }
    }
    
    private var volumeLabel: String {
        useMetric ? "Liters" : "Gallons"
    }
    
    private var circulationLabel: String {
        useMetric ? "liter" : "gallon"
    }
    
    private func debounceUpdate() {
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            updateRecommendation()
        }
    }
}

#Preview("Settings") {
    NavigationView {
        SettingsView(
            feedingData: FeedingData(),
            xaiService: XAIService(),
            weatherManager: WeatherManager(),
            locationManager: LocationManager()
        )
        .environmentObject(WaterQualityManager())
    }
} 


