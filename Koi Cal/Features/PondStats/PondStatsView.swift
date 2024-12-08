import SwiftUI

struct PondStatsView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var weatherManager = WeatherManager()
    @AppStorage("useCelsius") private var useCelsius = false
    @AppStorage("useMetric") private var useMetric = false
    @AppStorage("pondVolume") private var pondVolume = ""
    @AppStorage("sunlightHours") private var sunlightHours = ""
    
    private var volumeLabel: String {
        useMetric ? "Liters" : "Gallons"
    }
    
    private var displayVolume: String {
        guard let volume = Double(pondVolume) else { return "" }
        if useMetric {
            // Convert gallons to liters
            return String(format: "%.0f", volume * 3.78541)
        } else {
            // Convert liters to gallons
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
                }
                .padding(.horizontal)
                
                // Sunlight Hours Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("How many hours of direct sunlight does your pond get per day?")
                        .font(.headline)
                    
                    TextField("Hours", text: $sunlightHours)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal)
                
                // Location Section
                Section {
                    HStack {
                        Text("Location")
                        Spacer()
                        if locationManager.authorizationStatus == .denied {
                            Link("Enable in Settings", destination: URL(string: "app-settings:")!)
                        } else {
                            Text(locationManager.cityName)
                                .foregroundColor(.secondary)
                        }
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
            }
        }
        .navigationTitle("Pond Stats")
        .onChange(of: useMetric) { oldValue, newValue in
            // Update the volume when measurement system changes
            if !pondVolume.isEmpty {
                let oldValue = pondVolume
                pondVolume = displayVolume
                print("Converting from \(oldValue) to \(pondVolume)")
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
