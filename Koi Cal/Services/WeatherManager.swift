import Foundation
import WeatherKit
import CoreLocation
import SwiftUI

@MainActor
class WeatherManager: ObservableObject {
    @Published var currentTemperature: Double?
    @Published var errorMessage: String?
    @AppStorage("location") private var pondLocation = ""
    @AppStorage("sunlightHours") private var sunlightHours = ""
    
    func calculateWaterTemperature(airTemp: Double, sunlightHours: Double) -> Double {
        // Base difference between air and water (typically 4°F cooler)
        let baseWaterTemp = airTemp - 4
        
        // Adjust for sunlight exposure
        let sunlightAdjustment: Double
        switch Int(sunlightHours) {
        case 0...2:  // Low sun exposure
            sunlightAdjustment = -2
        case 3...5:  // Moderate sun exposure
            sunlightAdjustment = 0
        case 6...8:  // High sun exposure
            sunlightAdjustment = 2
        default:     // Very high sun exposure
            sunlightAdjustment = 4
        }
        
        let finalTemp = baseWaterTemp + sunlightAdjustment
        
        print("\n☀️ Sunlight Adjusted Water Temperature:")
        print("Air Temperature: \(String(format: "%.1f°F", airTemp))")
        print("Base Water Temperature: \(String(format: "%.1f°F", baseWaterTemp))")
        print("Sunlight Hours: \(sunlightHours)")
        print("Sunlight Adjustment: \(String(format: "%+.1f°F", sunlightAdjustment))")
        print("Final Water Temperature: \(String(format: "%.1f°F", finalTemp))")
        
        return finalTemp
    }
    
    func updateTemperature() async {
        guard !pondLocation.isEmpty else {
            errorMessage = "Please enter a location"
            return
        }
        
        do {
            let geocoder = CLGeocoder()
            let locations = try await geocoder.geocodeAddressString(pondLocation)
            
            guard let location = locations.first?.location else {
                errorMessage = "Could not find location"
                return
            }
            
            let weather = try await WeatherService.shared.weather(for: location)
            let temperature = weather.currentWeather.temperature
            
            let sunHours = Double(sunlightHours) ?? 0
            
            currentTemperature = calculateWaterTemperature(
                airTemp: temperature.converted(to: .fahrenheit).value,
                sunlightHours: sunHours
            )
        } catch {
            currentTemperature = nil
            errorMessage = error.localizedDescription
        }
    }
} 