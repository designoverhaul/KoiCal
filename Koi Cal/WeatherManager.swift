import SwiftUI
import WeatherKit
import CoreLocation

@MainActor
class WeatherManager: ObservableObject {
    private let weatherService = WeatherService.shared
    @Published var currentTemperature: Double?
    @Published var errorMessage: String?
    
    func getTemperature(for location: CLLocation?) async {
        guard let location = location else {
            print("No location available")
            errorMessage = "Location not available"
            return
        }
        
        do {
            print("Fetching weather for location: \(location.coordinate)")
            let weather = try await weatherService.weather(for: location)
            let temp = weather.currentWeather.temperature
            print("Got temperature: \(temp.converted(to: .fahrenheit).value)°F")
            currentTemperature = temp.converted(to: .fahrenheit).value
            errorMessage = nil
        } catch {
            print("Error fetching weather: \(error.localizedDescription)")
            errorMessage = "Unable to fetch weather data: \(error.localizedDescription)"
        }
    }
} 