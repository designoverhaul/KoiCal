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
    private let weatherService = WeatherService()
    private let geocoder = CLGeocoder()
    
    func calculateWaterTemperature(airTemp: Double, sunlightHours: Int) -> Double {
        // Base difference between air and water (typically 4°F cooler)
        let baseWaterTemp = airTemp - 4
        
        // Adjust for sunlight exposure
        let sunlightAdjustment: Double
        switch sunlightHours {
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
        // If location is empty, use a default temperature based on season
        if pondLocation.isEmpty {
            let calendar = Calendar.current
            let month = calendar.component(.month, from: Date())
            
            // Default temperatures by season (in Fahrenheit)
            let defaultTemp: Double
            switch month {
            case 12, 1, 2:  // Winter
                defaultTemp = 45.0
            case 3, 4, 5:   // Spring
                defaultTemp = 65.0
            case 6, 7, 8:   // Summer
                defaultTemp = 85.0
            case 9, 10, 11: // Fall
                defaultTemp = 65.0
            default:
                defaultTemp = 65.0
            }
            
            currentTemperature = defaultTemp
            errorMessage = nil
            
            // Use default sunlight hours (4) if not set
            let sunHours = Int(sunlightHours) ?? 4
            currentTemperature = calculateWaterTemperature(
                airTemp: defaultTemp,
                sunlightHours: sunHours
            )
            return
        }
        
        do {
            // Convert address to coordinates
            let placemarks = try await geocoder.geocodeAddressString(pondLocation)
            guard let location = placemarks.first?.location else {
                errorMessage = "Could not find location"
                return
            }
            
            // Get weather for coordinates
            let weather = try await weatherService.weather(for: location)
            let temperature = weather.currentWeather.temperature
            currentTemperature = temperature.converted(to: .fahrenheit).value
            errorMessage = nil
            
            // Use default sunlight hours (4) if not set
            let sunHours = Int(sunlightHours) ?? 4
            currentTemperature = calculateWaterTemperature(
                airTemp: currentTemperature ?? temperature.converted(to: .fahrenheit).value,
                sunlightHours: sunHours
            )
        } catch {
            currentTemperature = nil
            errorMessage = error.localizedDescription
        }
    }
} 