import SwiftUI
import MapKit

class LocationSearchManager: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var suggestions: [MKLocalSearchCompletion] = []
    private let completer: MKLocalSearchCompleter
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
        completer.resultTypes = .address
    }
    
    func search(query: String) {
        completer.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results
        print("Got \(suggestions.count) location suggestions")
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Location search failed with error: \(error.localizedDescription)")
        suggestions = []
    }
}

struct PondStatsView: View {
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var locationManager = LocationSearchManager()
    @AppStorage("useCelsius") private var useCelsius = false
    @AppStorage("useMetric") private var useMetric = false
    @AppStorage("pondVolume") private var pondVolume = ""
    @AppStorage("sunlightHours") private var sunlightHours = ""
    @AppStorage("location") private var savedLocation = ""
    @State private var searchText = ""
    @FocusState private var isVolumeFieldFocused: Bool
    @FocusState private var isSunlightFieldFocused: Bool
    @FocusState private var isLocationFieldFocused: Bool
    
    private var volumeLabel: String {
        useMetric ? "Liters" : "Gallons"
    }
    
    private var displayVolume: String {
        guard let volume = Double(pondVolume) else { return "" }
        if useMetric {
            return String(format: "%.0f", volume * 3.78541)
        } else {
            return String(format: "%.0f", volume / 3.78541)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Water Quality Measurements
                WaterQualityView()
                    .padding(.bottom, 20)
                
                // Measurements Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Measurements")
                        .font(.title2)
                        .padding(.horizontal)
                    
                    Picker("Measurement System", selection: $useMetric) {
                        Text("Imperial").tag(false)
                        Text("Metric").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
                
                // Pond Volume Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("How many \(volumeLabel.lowercased()) is your pond?")
                        .font(.headline)
                    
                    TextField(volumeLabel, text: $pondVolume)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($isVolumeFieldFocused)
                }
                .padding(.horizontal)
                
                // Sunlight Hours Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("How many hours of direct sunlight does your pond get per day?")
                        .font(.headline)
                    
                    TextField("Hours", text: $sunlightHours)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($isSunlightFieldFocused)
                }
                .padding(.horizontal)
                
                // Location Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Where is your pond located?")
                        .font(.headline)
                    
                    TextField("Enter location", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .focused($isLocationFieldFocused)
                        .onChange(of: searchText) { oldValue, newValue in
                            if newValue.count > 2 {
                                locationManager.search(query: newValue)
                            }
                        }
                    
                    if !locationManager.suggestions.isEmpty && searchText.count > 2 && isLocationFieldFocused {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(locationManager.suggestions, id: \.self) { suggestion in
                                Button(action: {
                                    savedLocation = suggestion.title
                                    searchText = suggestion.title
                                    isLocationFieldFocused = false
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
                                
                                if suggestion != locationManager.suggestions.last {
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
                .padding(.horizontal)
                
                // Temperature Section
                if let temp = weatherManager.currentTemperature {
                    HStack {
                        Text("Water Temperature")
                        Spacer()
                        Text(formatTemperature(temp))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
                
                // Bottom padding
                Spacer()
                    .frame(height: 100)
            }
        }
        .navigationTitle("Pond Stats")
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
        .onChange(of: useMetric) { oldValue, newValue in
            if !pondVolume.isEmpty {
                let oldValue = pondVolume
                pondVolume = displayVolume
                print("Converting from \(oldValue) to \(pondVolume)")
            }
        }
        .onAppear {
            if !savedLocation.isEmpty {
                searchText = savedLocation
            }
        }
    }
    
    private func formatTemperature(_ fahrenheit: Double) -> String {
        if useCelsius {
            let celsius = (fahrenheit - 32) * 5/9
            return String(format: "%.0f°C", celsius)
        } else {
            return String(format: "%.0f°F", fahrenheit)
        }
    }
}
