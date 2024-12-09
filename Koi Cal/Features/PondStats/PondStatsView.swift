import SwiftUI
import MapKit

struct PondStatsView: View {
    @StateObject private var weatherManager = WeatherManager()
    @AppStorage("useCelsius") private var useCelsius = false
    @AppStorage("useMetric") private var useMetric = false
    @AppStorage("pondVolume") private var pondVolume = ""
    @AppStorage("sunlightHours") private var sunlightHours = ""
    @AppStorage("location") private var savedLocation = ""
    @State private var searchText = ""
    @State private var locationSuggestions: [MKLocalSearchCompletion] = []
    @State private var searchCompleter = MKLocalSearchCompleter()
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
                    
                    if !locationSuggestions.isEmpty && searchText.count > 2 && isLocationFieldFocused {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(locationSuggestions, id: \.self) { suggestion in
                                Button(action: {
                                    savedLocation = suggestion.title
                                    searchText = suggestion.title
                                    locationSuggestions.removeAll()
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
                                
                                if suggestion != locationSuggestions.last {
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
            searchCompleter.delegate = SearchCompleterDelegate(suggestions: $locationSuggestions)
            searchText = savedLocation
        }
        .onChange(of: searchText) { oldValue, newValue in
            if newValue.count > 2 {
                searchCompleter.queryFragment = newValue
            } else {
                locationSuggestions.removeAll()
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

class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate, ObservableObject {
    @Binding var suggestions: [MKLocalSearchCompletion]
    
    init(suggestions: Binding<[MKLocalSearchCompletion]>) {
        _suggestions = suggestions
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Location search failed with error: \(error.localizedDescription)")
    }
}
