import SwiftUI
import UIKit

struct PondStatsView: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var weatherManager: WeatherManager
    @AppStorage("useCelsius") private var useCelsius = false
    @AppStorage("pondLength") private var pondLength = ""
    @AppStorage("pondWidth") private var pondWidth = ""
    @AppStorage("pondDepth") private var pondDepth = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Water Quality Measurements
                WaterQualityView()
                    .padding(.bottom, 20)
                
                // Existing Pond Stats Settings
                Group {
                    // Location Section
                    Section {
                        HStack {
                            Text("Location")
                            Spacer()
                            if locationManager.authorizationStatus == .denied {
                                Button("Enable in Settings") {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            } else {
                                Text(locationManager.cityName)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Temperature Section
                    if let temp = weatherManager.currentTemperature {
                        HStack {
                            Text("Water Temperature")
                            Spacer()
                            Text(formatTemperature(temp))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Pond Dimensions Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Pond Dimensions")
                            .font(.headline)
                        
                        TextField("Length", text: $pondLength)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        TextField("Width", text: $pondWidth)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        TextField("Depth", text: $pondDepth)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Pond Stats")
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
